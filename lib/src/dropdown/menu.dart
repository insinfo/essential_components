import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'dart:html';
import 'package:intl/intl.dart';
import 'dart:async';
import '../core/helper.dart';

/// Creates a dropdown-menu component that will be showed
/// every time that a [EsDropdownDirective] is open
@Directive(selector: 'es-dropdown-menu, .dropdown-menu')
class EsDropdownMenuDirective {
  HtmlElement elementRef;

  EsDropdownMenuDirective(this.elementRef);
}
