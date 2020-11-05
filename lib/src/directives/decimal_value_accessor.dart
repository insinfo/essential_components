import 'package:angular/angular.dart';
import 'dart:html';
import 'package:angular_forms/angular_forms.dart';

import 'package:decimal/decimal.dart';

///
///Essa classe permite definir um novo tipo de conversão entre um input text
/// e um valor de modelo do tipo decimal
///Como usar um tipo de dados personalizado com ngModel no Angular Dart
@Directive(
  selector: 'input[type=decimal][ngControl],'
      'input[type=decimal][ngFormControl],'
      'input[type=decimal][ngModel]',
  providers: [
    ExistingProvider.forToken(NG_VALIDATORS, DecimalValueAccessor),
  ],
)
class DecimalValueAccessor implements ControlValueAccessor {
  final InputElement _element;

  DecimalValueAccessor(HtmlElement element) : _element = element as InputElement;

  @HostListener('change', ['\$event.target.value'])
  @HostListener('input', ['\$event.target.value'])
  void handleChange(String value) {
    Decimal dec;
    try {
      dec = Decimal.parse(value);
    } catch (e) {
      // mark feild as invalid
      return;
    }

    onChange((value == '' ? null : dec), rawValue: value);
  }

  @override
  void writeValue(value) {
    _element.value = '$value';
  }

  @override
  void onDisabledChanged(bool isDisabled) {
    _element.disabled = isDisabled;
  }

  TouchFunction onTouched = () {};

  @HostListener('blur')
  void touchHandler() {
    onTouched();
  }

  /// Set the function to be called when the control receives a touch event.
  @override
  void registerOnTouched(TouchFunction fn) {
    onTouched = fn;
  }

  ChangeFunction<Decimal> onChange = (Decimal _, {String rawValue}) {};

  /// Set the function to be called when the control receives a change event.
  @override
  void registerOnChange(ChangeFunction<Decimal> fn) {
    onChange = fn;
  }
}
