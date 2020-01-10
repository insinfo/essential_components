import 'package:angular/angular.dart';
import 'dart:html';
import 'dart:async';
import '../directives/collapse.dart';

import '../fontawesome/fontawesome.dart';

/// Directives needed to create a accordion ES_ACCORDION_DIRECTIVES to esAcoordionDirectives
const esAcoordionDirectives = [EssentialAccordionComponent, EsAccordionPanelComponent];

@Component(
    selector: 'es-accordion',
    template: '<ng-content></ng-content>',
    directives: [coreDirectives, EsAccordionPanelComponent])
class EssentialAccordionComponent implements AfterContentInit {
  @Input()
  bool closeOthers;

  @ContentChildren(EsAccordionPanelComponent)
  List<EsAccordionPanelComponent> panels;

  @override
  ngAfterContentInit() {
    panels.forEach((p) => p.parentAccordion = this);
  }

  closeOtherPanels(EsAccordionPanelComponent openGroup) {
    if (closeOthers == false) {
      return;
    }
    panels.forEach((panel) {
      if (!identical(panel, openGroup)) {
        panel.isOpen = false;
      }
    });
  }

  addPanel(EsAccordionPanelComponent panel) {
    panels.add(panel);
  }

  removePanel(EsAccordionPanelComponent panel) {
    panels.remove(panel);
  }
}

@Component(selector: 'es-accordion-panel', templateUrl: 'accordion_panel.html', directives: [
  EssentialCollapseDirective,
  coreDirectives,
  fontAwesomeDirectives
], styleUrls: [
  'accordion.css',
])
class EsAccordionPanelComponent implements OnInit {
  EsAccordionPanelComponent();
  EssentialAccordionComponent parentAccordion;
  TemplateRef headingTemplate;

  @Input()
  String icon = "angle-double-up";
  /* get icon {
    return _icon == "angle-double-down" ? "angle-double-up" : "angle-double-down";
  }*/

  changeIcon() {
    icon = isOpen ? "angle-double-up" : "angle-double-down";
  }

  @Input()
  String panelClass;

  /// clickable text in accordion's group header
  @Input()
  String heading;

  /// if `true` disables accordion group
  @Input()
  bool isDisabled = false;

  bool _isOpen = false;

  /// is accordion group open or closed
  @HostBinding('class.panel-open')
  bool get isOpen => _isOpen;

  final _isOpenChangeCtrl = StreamController<bool>.broadcast();

  /// emits if the panel [isOpen]
  @Output()
  Stream<bool> get isOpenChange => _isOpenChangeCtrl.stream;

  /// if `true` opens the panel
  @Input()
  set isOpen(bool value) {
    isOpenTimer?.cancel();
    isOpenTimer = Timer(const Duration(milliseconds: 60), () {
      _isOpen = value;
      if (value) {
        parentAccordion?.closeOtherPanels(this);
      }
      _isOpenChangeCtrl.add(value);
    });
  }

  Timer isOpenTimer;

  /// initialize the default values of the attributes
  @override
  ngOnInit() {
    panelClass = '';
  }

  /// toggles the [isOpen] state of the panel
  toggleOpen(MouseEvent event) {
    event.preventDefault();
    if (!isDisabled) {
      isOpen = !isOpen;
    }
    changeIcon();
  }
}
