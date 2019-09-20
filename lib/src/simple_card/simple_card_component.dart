import 'dart:async';

import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';

class SimpleCardModel {
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

  
  @override
  void ngAfterContentInit() {
  }

  toogleMinimize() {
    displayMinimize = !displayMinimize;
  }

  toggleClose() {
    hiddenClose = !hiddenClose;
  }

  bool isLoading = true;

  reload() {
    _dataRequest.add(true);
  }

  goToUrl() {
    print(this.data.getModel().linkUrl);
  }

  bool hasButton() {
    return data.getModel().templateLink == TemplateLink.BUTTON;
  }

  bool hasTitle() {
    return data.getModel().contentTitle != null;
  }
}