import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/core.dart';

import 'dart:html' as html;

@Directive(selector: '[esinnerhtml]') //esinnerhtml
class EssentialInnerHTMLDirective implements AfterContentInit {
  @Input('esinnerhtml')
  String content = 'l';

  final Element _el;

  EssentialInnerHTMLDirective(this._el);

  @override
  void ngAfterContentInit() {
    //html.TableCellElement element = _el;
    _el.setInnerHtml(content, treeSanitizer: html.NodeTreeSanitizer.trusted);
  }
}
