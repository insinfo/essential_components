import 'dart:html' as html;

class SimpleLoadingComponent {
  List<html.DivElement> loadings = <html.DivElement>[];
  html.HtmlElement _target;
  int requisicoes = 0;
  //Uuid uniqueIdGen;
  static SimpleLoadingComponent instance;

  static SimpleLoadingComponent getInstance() {
    if (instance == null) {
      return SimpleLoadingComponent();
    } else {
      return instance;
    }
  }

  SimpleLoadingComponent() {
    // uniqueIdGen = Uuid();
  }

  void show({html.HtmlElement target}) {
    _target = target;
    var template = ''' 
      <div style="z-index: 1000; position: absolute;
          border: none; margin: 0px; padding: 0px; 
          width: 100%; height: 100%; top: 0px; left: 0px; 
          background-color: rgb(255, 255, 255);
          opacity: 0.5; cursor: default; 
          ">
      </div>
      <div style="z-index: 1011; position: absolute; 
          display: flex; align-items: center; justify-content: center;
          border: 0px;  margin: 0px; padding: 0px; 
          width: 100%; height: 100%;
          top: 0px; left: 0px; text-align: center; 
          color: #36aff4; 
          cursor: default; opacity: 0.856319;">
          <i class="icon-spinner9 spinner" style="font-size: 57px;"></i>
      </div>
    ''';
    var loading = html.DivElement();
    loading.classes.add('SimpleLoadingComponent');
    loading.setInnerHtml(template,
        treeSanitizer: html.NodeTreeSanitizer.trusted);

    if (_target == null) {
      html.document.querySelector('body').append(loading);
    } else {
      _target.append(loading);
    }
    loadings.add(loading);
    requisicoes++;
  }

  void hide() {
    if (loadings.isNotEmpty) {
      loadings.last.remove();
      loadings.removeLast();
    }
  }
}
