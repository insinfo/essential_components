import 'dart:html' as html;

class SimpleLoadingComponent {
  static html.DivElement _loading;
  static html.HtmlElement _target;
  static int requisicoes = 0;
  static show({html.HtmlElement target}) {
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
    _loading = html.DivElement();
    _loading.setInnerHtml(template, treeSanitizer: html.NodeTreeSanitizer.trusted);

    if (requisicoes == 0) {
      if (_target == null) {
        html.document.querySelector('body').append(_loading);
        /*var element = html.document.querySelector('body :first-child');
        if (element != null) {
          element.style.filter = "blur(10px)";
          element.style.transition = "2s filter linear";
        }*/
      } else {
        _target.append(_loading);
      }
    }
    requisicoes++;
  }

  static hide({html.HtmlElement target}) {
    _target = target;

    if (requisicoes <= 1) {
      /*var element = html.document.querySelector('body :first-child');
      if (element != null) {
        element.style.filter = "blur(0px)";       
      }*/
      _loading.remove();
    }

    if (requisicoes > 0) {
      requisicoes--;
    }
  }
}
