import 'dart:async';
import 'package:angular/angular.dart';

import 'dynamic_tab_header_directive.dart';
import 'dynamic_tabs.dart';

/// Creates a tab which will be inside the [EsTabsxComponents]
@Directive(selector: 'es-tabx')
class EsTabxDirective {
  EsTabxDirective(this._ref);

  final ChangeDetectorRef _ref;

  @HostBinding('class.tab-pane')
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
  bool get active => _active;

  /// if tab is active equals true, or set `true` to activate tab
  @Input()
  set active(bool active) {
    active ??= true;
    if (_active != active) {
      _active = active;
      //_ref.detectChanges();
      _ref.markForCheck();
    }
    if (active) {
      _selectCtrl.add(this);
    } else {
      _deselectCtrl.add(this);
    }
  }
}
