import 'dart:async';
import 'dart:html' as html;
import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';

class SimpleCardModel {
  String guid;
  String headerContent;
  String contentTitle;
  String content;
  String icon;
  String iconColor = 'blue';
  String linkUrl;
  String linkLabel;
  TemplateLink templateLink;
  String alignBtn = 'left';
  String btnColor = 'blue';

  /*
   * Estrutura do Guid ligado ao localstorage
   * URL_GUID 
   */
  String getGuid() {
    return html.window.location.hostname + '_' + guid;
  }

  void setHeaderContent (String value) => this.headerContent = value;
}

enum TemplateLink {
  BUTTON, LINK, ANCOR
}

abstract class SimpleCardRender {
  SimpleCardModel getModel();
}

@Component(
    selector: 'es-simple-card',
    templateUrl: 'simple_card_component.html',
    styleUrls: ['simple_card_component.css'],
    directives: [coreDirectives, EssentialCollapseDirective]
)
class EssentialSimpleCardComponent implements AfterContentInit {

  final _dataRequest = StreamController<bool>();

  @Output()
  Stream<bool> get dataRequest => _dataRequest.stream;
  
  @Input('data')
  SimpleCardRender data;

  @Input()
  bool showActions = true;

  @Input()
  bool showIcon = true;

  @Input()
  bool showHeaderTitle = true;

  @Input()
  bool showContentTitle = true;

  @Input()
  bool showContent = true;

  @Input()
  bool showBtn = true;
  /*
   * Essas ações estarão disponíveis para o desenvolvedor
   */
  bool showMinimizeBtn = true;
  bool showRefreshBtn = true;
  bool showCloseBtn = true;

  /*
   * Ações que o usuário ira tomar.
   * A opção de minimar vai ser salva no LocalStorage 
   */
  bool displayMinimize = false;
  bool hiddenClose = false;

  var model;
  
  @override
  void ngAfterContentInit() {
    model = data?.getModel();
    String isMinimize = html.window.localStorage[this.model.getGuid()];
    if (isMinimize == 'false') {
      displayMinimize = false;
    } else {
      if (!hasHeaderContent() && model.contentTitle != null) {
        model.setHeaderContent(model.contentTitle);
      }
      displayMinimize = true;
    }
  }
  toogleMinimize() {
   displayMinimize = !displayMinimize;
    if (cardIsMinimized()) {
      showHeaderTitle = true;
      if (!hasHeaderContent() && model.contentTitle != null) {
        model.setHeaderContent(model.contentTitle);
      }
    } else {
      model.setHeaderContent(null);
      showHeaderTitle = true;
    }
    html.window.localStorage[this.model.getGuid()] = displayMinimize.toString();
  }

  bool hasHeaderContent() {
    return model.headerContent != null;
  }

  bool cardIsMinimized() {
    return displayMinimize == true;
  }

  toggleClose() {
    hiddenClose = !hiddenClose;
  }

  bool isLoading = true;

  reload() {
    _dataRequest.add(true);
  }

  goToUrl() {
    print(this.model.linkUrl);
  }

  bool hasButton() {
    return model.templateLink == TemplateLink.BUTTON;
  }

}