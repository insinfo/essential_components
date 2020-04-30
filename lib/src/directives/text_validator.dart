import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

@Directive(
  selector: ''
      '[textvalidator][ngControl],'
      '[textvalidator][ngFormControl],'
      '[textvalidator][ngModel]',
  providers: [
    ExistingProvider.forToken(NG_VALIDATORS, TextValidator),
  ],
)
class TextValidator implements Validator {
  @Input()
  int minLength;

  @Input()
  int maxLength;

  @Input()
  String locale = 'pt-br';

  InputElement _el;
  DivElement _divPai;
  DivElement _node;
  String _value;

  TextValidator(Element el) {
    _el = el;
    print('TextValidator ${_el}');
  }

  /* bool _isNodeCreated(DivElement div) {
    return div.querySelector('.text-validation') != null;
  }*/

  bool _hasSelectorValidationEl() {
    return _divPai.querySelector('.text-validation') == null;
  }

  void _createNode() {
    _node = DivElement();
    _node.classes.add('text-validation');
    _node.classes.add('text-danger');
  }

  void _addFeedbackValidationWithMessageError(String messageError) {
    _node.text = messageError;
    _divPai.append(_node);
  }

  void _hasNullOrEmpty() {
    if (_value == null || _value.isEmpty) {
      _addFeedbackValidationWithMessageError('Este campo é obrigatório');
    }
  }

  void _hasInvalidLength() {
    if (_value.length < minLength || _value.length > maxLength) {
      _addFeedbackValidationWithMessageError(
          'O valor precisa ter entre ${minLength} à ${maxLength} caracteres.');
    } else {
      _node.remove();
    }
  }

  @override
  Map<String, dynamic> validate(AbstractControl control) {
    _divPai = _el.parent as DivElement;
    print('div ${_divPai}');
    if (control != null) {
      _value = control.value.toString();
      if (_hasSelectorValidationEl()) {
        _createNode();
      }
      _hasNullOrEmpty();
      _hasInvalidLength();
    }

    return null;
  }
}
