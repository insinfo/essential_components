import 'dart:async';
import 'package:angular/angular.dart';

/// Directives needed to create a tab-set
const esTabsDirectives  =  [
   EsTabComponent,
   EsTabsComponent,
   EsTabContentComponent,
   EsTabPanelDirective
];

@Component(
  selector: 'es-tabs',
  templateUrl: 'simple_tabs.html',
  directives: [coreDirectives]
)
class EsTabsComponent implements AfterContentInit {
  /// children tabs
  @ContentChildren(EsTabComponent)
  List<EsTabComponent> tabs;

  final _onTabChangeCtrl = StreamController<EsTabComponent>.broadcast();

  /// emits when the tab number change
  @Output()
  Stream<EsTabComponent> get onTabChange => _onTabChangeCtrl.stream;

  /// handles selected tab
  EsTabComponent _selected;

  /// gets the selected tab
  EsTabComponent get selected => _selected;

  @override
  void ngAfterContentInit() {
    _selected = tabs.firstWhere((EsTabComponent tab) => tab.active, orElse: () {
      final tab = tabs.first;
      tab?.active = true;
      return tab;
    });
  }

  /// sets the selected tab
  void setSelected(EsTabComponent tab) {
    tabs.forEach((EsTabComponent tab) => tab.active = false);
    tab.active = true;
    _selected = tab;
    _onTabChangeCtrl.add(tab);
  }

  /// prepends `#` to the [path]
  String toAnchor(String path) => '#$path';
}

@Directive(selector: 'template[esTab]')
class EsTabComponent {
  /// reference to the template
  TemplateRef templateRef;

  /// handles if the tab is active
  @Input()
  bool active = false;

  /// handles which panel will be selected
  @Input()
  String select;

  /// constructs a [EsTabComponent]
  EsTabComponent(this.templateRef);
}

@Component(
    selector: 'es-tab-content',
    template: '<template [ngTemplateOutlet]="current.templateRef"></template>',
    directives: [coreDirectives])
class EsTabContentComponent implements AfterContentInit {
  /// [BsTabsComponent] target the this content is listening to
  @Input('for')
  EsTabsComponent target;

  /// displayed panels
  @ContentChildren(EsTabPanelDirective)
  List<EsTabPanelDirective> panels;

  EsTabPanelDirective _current;

  /// Current tab panel
  EsTabPanelDirective get current => _current;

  @override
  void ngAfterContentInit() {
    _setCurrent(target.selected);
    target.onTabChange.listen(_setCurrent);
  }

  void _setCurrent(EsTabComponent tab) {
    _current = panels.firstWhere((EsTabPanelDirective panel) => panel.name == tab?.select);
  }
}

/// panel of the tabs component
@Directive(selector: 'template[es-tab-panel]')
class EsTabPanelDirective {
  TemplateRef templateRef;

  @Input()
  String name;
  EsTabPanelDirective(this.templateRef);
}
