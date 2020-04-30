import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

@Directive(selector: 'es-toggle-button')
class EsToggleButtonDirective extends DefaultValueAccessor {
  NgModel ngModel;

  /// if it is equals to the [ngModel] value then the checkbox is going to be active
  @Input()
  dynamic trueValue = true;

  /// if it is not equals to the [ngModel] value then the checkbox is not going to be active
  @Input()
  dynamic falseValue = false;

  var _value;

  /// active status of the button
  @HostBinding('class.active')
  bool get active => trueValue == _value;

  EsToggleButtonDirective(this.ngModel, HtmlElement elementRef)
      : super(elementRef) {
    ngModel.valueAccessor = this;
  }

  /// this function is fired whenever a new write is done to the [ngModel]
  @override
  void writeValue(value) async {
    _value = value;
    super.writeValue(_value);
  }

  /// toggles the state of the [active] attribute
  void toggle(bool checked) {
    _value = checked ? trueValue : falseValue;
    ngModel.viewToModelUpdate(_value);
  }

  /// Listens on the click event of the button
  @HostListener('click')
  void onClick() => toggle(!active);
}
