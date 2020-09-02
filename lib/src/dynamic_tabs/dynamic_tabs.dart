import 'dart:async';

import 'package:angular/angular.dart';

import 'dynamic_tab_directive.dart';
import 'dynamic_tab_header_directive.dart';

/// Directives needed to create a tab-set
const esDynamicTabsDirectives = [EsTabxDirective, BsTabxHeaderDirective, EsTabsxComponents];

@Component(selector: 'es-tabsx', templateUrl: 'dynamic_tabs.html', directives: [coreDirectives])
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

  Map get navTypeMap =>
      {'flex-column': vertical, 'nav-justified': justified, 'nav-tabs': type == 'tabs', 'nav-pills': type == 'pills'};

  Map tabTypeMap(EsTabxDirective tab) => {'active': tab.active, 'disabled': tab.disabled};

  /// List of sub tabs
  @ContentChildren(EsTabxDirective)
  List<EsTabxDirective> tabs = [];

  /// initialize attributes
  @override
  void ngOnInit() {
    type ??= 'tabs';
    placement ??= 'top';
  }

  final _selectCtrl = StreamController<EsTabxDirective>.broadcast();

  /// emits the selected element change
  @Output()
  Stream<EsTabxDirective> get select => _selectCtrl.stream;

  @override
  void ngAfterContentInit() {
    activateTab(tabs.firstWhere((tab) => tab.active, orElse: () => tabs[0]));

    //selected element change
    tabs.forEach((t) {
      t.select.listen((event) {
        _selectCtrl.add(event);
      });
    });
  }

  /// adds a new tab at the end
  void addTab(EsTabxDirective tab) {
    tabs.add(tab);
    tab.active = tabs.length == 1 && tab.active != false;
  }

  /// removes the specified tab
  void removeTab(EsTabxDirective tab) {
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

  void activateTab(EsTabxDirective tab) {
    if (tab.disabled) return;

    tabs.forEach((t) {
      t.active = t == tab;
    });
  }
}
