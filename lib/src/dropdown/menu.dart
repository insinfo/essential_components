import 'package:angular/angular.dart';
import 'dart:html';

/// Creates a dropdown-menu component that will be showed
/// every time that a [EsDropdownDirective] is open
@Directive(selector: 'es-dropdown-menu, .dropdown-menu')
class EsDropdownMenuDirective {
  HtmlElement elementRef;

  EsDropdownMenuDirective(this.elementRef);
}
