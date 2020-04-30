import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';
import 'package:example/src/utils/highlighting_js.dart';
import 'simple.dart';

@Component(
    selector: 'simple-card-component',
    styleUrls: ['simple_card_example.css'],
    templateUrl: 'simple_card_example.html',
    directives: [
      coreDirectives,
      esDynamicTabsDirectives,
      EssentialSimpleCardComponent
    ],
    exports: [],
    providers: [])
class SimpleCardComponent implements OnInit {
  Simple simple = Simple();

  String htmlCode = '''
  <es-simple-card [data]="simple"></es-simple-card>
''';
  String dartCode = '''
  class Simple implements SimpleCardRender {
  @override
  SimpleCardModel getModel() {
    SimpleCardModel data = SimpleCardModel();
    data.guid = 'ContactSuport';
    data.contentTitle = 'Suporte';
    data.content = '<p class="text-center">Para entrar em contato com a equipe de suporte,<br> ligue no telefone (22) 2771-6187 ou <br> em um dos ramais 6187 e 6249.<p>';
    data.linkUrl = '';
    data.alignBtn = 'center';
    data.linkLabel = 'Ligar agora';
    data.templateLink = TemplateLink.BUTTON;
    data.btnColor = 'orange';
    data.icon = 'lifebuoy';
    data.iconColor = 'orange';
    return data;
  }
}
  ''';

  SimpleCardComponent();

  @override
  void ngOnInit() {
    dartCode = highlightingHtml(dartCode);
    htmlCode = highlightingHtml(htmlCode);
  }
}
