import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';
import 'package:example/src/utils/highlighting_js.dart';

import '../../utils/highlighting_js.dart';

@Component(
  selector: 'recaptcha_example',
  styleUrls: ['recaptcha_example.css'],
  templateUrl: 'recaptcha_example.html',
  directives: [
    coreDirectives,
    esDynamicTabsDirectives,
    EssentialRecaptcha,
  ],
)
class RecaptchaExample implements OnInit {
  var site_key = '6Leab-IUAAAAAG-gOiCC2bSa2LVUJRYTYUCxlJ6G';
  var secret_key = '6Leab-IUAAAAAKHraCk_tfi5XqpoUNI8CMx7TFcC';
  String value;
 
  onVerify(e) {
     print('onVerify $e');
  }

  String codeHtml = '''
 <essential-recaptcha [(ngModel)]="value" [key]="site_key" (verify)="onVerify(\$event)" [auto-render]="true"></essential-recaptcha>
''';

  String codeDart = '''
import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';

@Component(
  selector: 'example',
  styleUrls: ['example.css'],
  templateUrl: 'example.html',
  directives: [
    coreDirectives,
    EssentialRecaptcha,
  ],
)
class AccordeonComponent { 
  var site_key = '6Leab-IUAAAAAG-gOiCC2bSa2LVUJRYTYUCxlJ6G';
  String value;
 
  onVerify(e) {
     print('onVerify \$e');
  }
}
  ''';

  RecaptchaExample();

  @override
  void ngOnInit() {
    codeDart = highlightingDart(codeDart);
    codeHtml = highlightingHtml(codeHtml);
  }
}
