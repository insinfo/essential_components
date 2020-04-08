
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
/*
class Validators {
  ///  Validator that requires controls to have a non-empty value.
  static Map<String, bool> required(AbstractControl control) {
    return control.value == null || control.value == '' ? {'required': true} : null;
  }

  ///  Validator that requires controls to have a value of a minimum length.
  static ValidatorFn minLength(num minLength) {
    return /* Map < String , dynamic > */ (AbstractControl control) {
      if (Validators.required(control) != null) return null;
      String v = control.value;
      return v.length < minLength
          ? {
              'minlength': {'requiredLength': minLength, 'actualLength': v.length}
            }
          : null;
    };
  }

  ///  Validator that requires controls to have a value of a maximum length.
  static ValidatorFn maxLength(num maxLength) {
    return /* Map < String , dynamic > */ (AbstractControl control) {
      if (Validators.required(control) != null) return null;
      String v = control.value;
      return v.length > maxLength
          ? {
              'maxlength': {'requiredLength': maxLength, 'actualLength': v.length}
            }
          : null;
    };
  }
}

/// A [Directive] adding minimum-length validator to controls with `minlength`.
///
/// ```html
/// <input ngControl="fullName" minLength="10" />
/// ```
@Directive(
  selector: ''
      '[minlength][ngControl],'
      '[minlength][ngFormControl],'
      '[minlength][ngModel]',
  providers: [
    ExistingProvider.forToken(NG_VALIDATORS, MinLengthValidator),
  ],
)
class MinLengthValidator implements Validator {
  @HostBinding('attr.minlength')
  String minLengthAttr;

  int _minLength;
  int get minLength => _minLength;

  @Input('minlength')
  set minLength(int value) {
    _minLength = value;
    minLengthAttr = value?.toString();
  }

  @override
  Map<String, dynamic> validate(AbstractControl c) {
    final v = c?.value?.toString();
    if (v == null || v == '') return null;
    return v.length < minLength
        ? {
            'minlength': {'requiredLength': minLength, 'actualLength': v.length}
          }
        : null;
  }
}*/

@Directive(
  selector: ''
      '[anovalidator][ngControl],'
      '[anovalidator][ngFormControl],'
      '[anovalidator][ngModel]',
  providers: [
    ExistingProvider.forToken(NG_VALIDATORS, AnoValidator),
  ],
)
class AnoValidator implements Validator {
  @override
  Map<String, dynamic> validate(AbstractControl control) {
    int value;
    if (int.tryParse(control.value.toString()) != null) {
      value = int.tryParse(control.value.toString());
    } else {
      value = 0;
    }
    return value < 1000
        ? {
            'anovalidator': {'valid': false}
          }
        : null;
  }
}
