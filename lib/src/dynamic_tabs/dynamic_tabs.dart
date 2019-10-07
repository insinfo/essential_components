import 'dart:async';
import "package:angular/angular.dart";

/// Directives needed to create a tab-set
const esDynamicTabsDirectives = [EsTabxDirective, BsTabxHeaderDirective, EsTabsxComponents];

@Component(selector: "es-tabsx", templateUrl: 'dynamic_tabs.html', directives: [coreDirectives])
class EsTabsxComponents implements OnInit, AfterContentInit {
  /// if `true` tabs will be placed vertically
  bool get vertical => placement == 'left' || placement == 'right';

  @HostBinding('class.flex-row')
  bool get placementLeft => placement == 'left';

  @HostBinding('class.flex-row-reverse')
  bool get placementRight => placement == 'right';

  @HostBinding('class.flex-column-reverse')
  bool get placementBottom => placement == 'bottom';

  @Input()
  @HostBinding('attr.placement')
  String placement;

  /// if `true` tabs will be justified
  @Input()
  bool justified = false;

  /// navigation context class: 'tabs' or 'pills'
  @Input()
  String type;

  /// List of sub tabs
  @ContentChildren(EsTabxDirective)
  List<EsTabxDirective> tabs = [];

  /// initialize attributes
  ngOnInit() {
    type ??= "tabs";
    placement ??= 'top';
  }

  @override
  ngAfterContentInit() {
    activateTab(tabs.firstWhere((tab) => tab.active, orElse: () => tabs[0]));
  }

  /// adds a new tab at the end
  addTab(EsTabxDirective tab) {
    tabs.add(tab);
    tab.active = tabs.length == 1 && tab.active != false;
  }

  /// removes the specified tab
  removeTab(EsTabxDirective tab) {
    var index = tabs.indexOf(tab);
    if (index == -1) return;

    // Select a new tab if the tab to be removed is selected and not destroyed
    if (tab.active && tabs.length > 1) {
      // If this is the last tab, select the previous tab. else, the next tab.
      var newActiveIndex = index == tabs.length - 1 ? index - 1 : index + 1;
      tabs[newActiveIndex].active = true;
    }
    tabs.remove(tab);
  }

  activateTab(EsTabxDirective tab) {
    if (tab.disabled) return;

    tabs.forEach((t) {
      t.active = t == tab;
    });
  }
}

/// Creates a tab which will be inside the [EsTabsxComponents]
///

@Directive(selector: "es-tabx")
class EsTabxDirective {
  EsTabxDirective(this._ref);

  final ChangeDetectorRef _ref;

  @HostBinding("class.tab-pane")
  bool tabPane = true;

  /// provides the injected parent tabset
  EsTabsxComponents tabsx;

  /// if `true` tab can not be activated
  @Input()
  bool disabled = false;

  /// tab header text
  @Input()
  String header;

  /// Template reference to the heading template
  @ContentChild(BsTabxHeaderDirective)
  BsTabxHeaderDirective headerTemplate;

  final _selectCtrl = StreamController<EsTabxDirective>.broadcast();

  /// emits the selected element change
  @Output()
  Stream<EsTabxDirective> get select => _selectCtrl.stream;

  final _deselectCtrl = StreamController<EsTabxDirective>.broadcast();

  /// emits the deselected element change
  @Output()
  Stream get deselect => _deselectCtrl.stream;

  bool _active = false;

  /// if tab is active equals true, or set `true` to activate tab
  @HostBinding('class.active')
  get active => _active;

  /// if tab is active equals true, or set `true` to activate tab
  @Input()
  set active(bool active) {
    active ??= true;
    if (_active != active) {
      _active = active;
      _ref.detectChanges();
    }
    if (active) {
      _selectCtrl.add(this);
    } else {
      _deselectCtrl.add(this);
    }
  }
}

/// Creates a new tab header template
@Directive(selector: "template[bs-tabx-header]")
class BsTabxHeaderDirective {
  /// constructs a [BsTabxHeaderDirective] injecting its own [templateRef] and its parent [tab]
  BsTabxHeaderDirective(this.templateRef);

  TemplateRef templateRef;
}
