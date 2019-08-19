import 'dart:html';
import 'package:angular/angular.dart';

@Directive(selector: '[customMaxlength]')
class MaxlengthDirective {
  @Input()
  int customMaxlength;
  MaxlengthDirective(Element el) {
    InputElement inputEl = el;
    inputEl.onKeyPress.listen((e) {
      if (e.keyCode != 8 && inputEl.value.length == customMaxlength) {
        e.preventDefault();
        return false;
      }
    });
  }
}
