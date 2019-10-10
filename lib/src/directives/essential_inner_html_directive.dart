import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/core.dart';

import 'dart:html' as html;

@Directive(selector: '[esinnerhtml]')
class EssentialInnerHTMLDirective implements AfterContentInit {

  @Input('esinnerhtml')
  String content = 'l';

  final Element _el;
  
  EssentialInnerHTMLDirective(this._el);

  @override
  void ngAfterContentInit() {
    html.HtmlElement element = _el;
    element.setInnerHtml(content, treeSanitizer: html.NodeTreeSanitizer.trusted);
  }
}
