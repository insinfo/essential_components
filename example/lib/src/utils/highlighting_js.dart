@JS()
library highlightingjs;

import 'package:js/js.dart';

//@JS('Prism.languages.dart')
//dynamic PrismLanguagesDart;

//@JS('Prism.highlight')
//external String initHighlighting(String code, dynamic lang, String la);
//Prism.highlight('',Prism.languages.dart, 'dart');

@JS('highlightingHtml')
external String highlightingHtml(String code);

@JS('highlightingDart')
external String highlightingDart(String code);