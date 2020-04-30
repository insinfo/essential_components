import 'package:angular/angular.dart';
import 'dart:html';
import 'package:angular_forms/angular_forms.dart';

/*import 'package:angular/angular.dart'
    show ChangeHandler, ControlValueAccessor, ngValueAccessor, TouchHandler;*/

///
///Essa classe permite definir um novo tipo de conversão entre um input text
/// e um valor de modelo do tipo decimal
///Como usar um tipo de dados personalizado com ngModel no Angular Dart
/// The accessor for writing a DateTime value and listening to changes that is used by the
/// [NgModel], [NgFormControl], and [NgControlName] directives.
///
///  ### Example
///
///  <input type="date" [(ngModel)]="age">
@Directive(
  selector: 'input[type=date][ngControl],'
      'input[type=date][ngFormControl],'
      'input[type=date][ngModel]',
  providers: [
    ExistingProvider.forToken(ngValueAccessor, DateTimeValueAccessor),
  ],
)
class DateTimeValueAccessor implements ControlValueAccessor {
  final InputElement _element;

  DateTimeValueAccessor(HtmlElement element)
      : _element = element as InputElement;

  @HostListener('change', ['\$event.target.value'])
  @HostListener('input', ['\$event.target.value'])
  void handleChange(String value) {
    DateTime dec;
    try {
      dec = DateTime.tryParse(value);
    } catch (e) {
      //  mark feild as invalid
      return;
    }
    onChange((value == '' ? null : dec), rawValue: value);
  }

  @override
  void writeValue(value) {
    DateTime dec;
    try {
      dec = value as DateTime;
    } catch (e) {
      // mark feild as invalid
      return;
    }
    var r = dec != null ? dec.toIso8601String().substring(0, 10) : '';
    _element.value = '$r';
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

  ChangeFunction<DateTime> onChange = (DateTime _, {String rawValue}) {};

  /// Set the function to be called when the control receives a change event.
  @override
  void registerOnChange(ChangeFunction<DateTime> fn) {
    onChange = fn;
  }
}
