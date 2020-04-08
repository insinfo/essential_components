import 'dart:html' as html;

enum DialogColor { DANGER, PRIMARY, SUCCESS, WARNING, INFO, PINK }

class SimpleDialogComponent {
  static getColor(DialogColor dialogColor) {
    var headerColor = '';
    switch (dialogColor) {
      case DialogColor.PRIMARY:
        headerColor = 'primary';
        break;
      case DialogColor.SUCCESS:
        headerColor = 'success';
        break;
      case DialogColor.DANGER:
        headerColor = 'danger';
        break;
      case DialogColor.WARNING:
        headerColor = 'orange-300';
        break;
      case DialogColor.INFO:
        headerColor = 'info';
        break;
      case DialogColor.PINK:
        headerColor = 'info';
        break;
    }
    return headerColor;
  }

  static showFullScreenDialog(String content) {
    var template = ''' 
    <div style="width: 100%;height: 100%;display: block; 
    position: fixed;top: 0;left: 0;background: rgba(255, 255, 255, 0.5);">
    $content
    </div>
     ''';
    // ignore: omit_local_variable_types
    html.DivElement root = html.DivElement();
    html.document.querySelector('body').append(root);
    root.setInnerHtml(template, treeSanitizer: html.NodeTreeSanitizer.trusted);
  }

  static showFullScreenAlert(String message, {backgroundColor = '#de589d'}) {
    var template = ''' 
    <div style="width: 100%;height: 100%;display: block; 
        position: fixed;top: 0;left: 0;background: rgba(255, 255, 255, 0.5);">
        <div style="display:flex;align-items:center;justify-content:center;width: 100%;height: 100%;">
            <h1 style="width:50%;height:77px;text-align:center;background:$backgroundColor;color:#fff;padding:20px;">$message</h1>
        </div>
    </div>
     ''';
    html.document.querySelector('.FullScreenAlert')?.remove();
    // ignore: omit_local_variable_types
    html.DivElement root = html.DivElement();
    root.classes.add('FullScreenAlert');
    html.document.querySelector('body').append(root);
    root.setInnerHtml(template, treeSanitizer: html.NodeTreeSanitizer.trusted);
  }

  static showAlert(String message,
      {String subMessage,
      String title = 'Alerta',
      String detailLabel = 'Detalhe',
      DialogColor dialogColor = DialogColor.PRIMARY}) {
    var template = ''' 
      <div class="bootbox modal fade bootbox-alert show" tabindex="-1" role="dialog" style="padding-right: 17px; display: block;">
        <div class="modal-dialog">
            <div class="modal-content">                
                <div class="modal-header bg-${getColor(dialogColor)}">
                  <h6 class="modal-title">$title</h6>
                  <!--<button type="button" class="close" data-dismiss="modal">×</button>-->
							  </div>
                <div class="modal-body">
                    <div class="bootbox-body" style="overflow:hidden;">$message</div>                     
                </div>
                <div class="modal-footer">
                    <button data-bb-handler="ok" type="button" class="BtnOk btn btn-primary">OK</button>
                </div>
            </div>
        </div>
    </div>
    <div class="modal-backdrop fade show"></div>
    ''';
    var root = html.DivElement();
    html.document.querySelector('body').append(root);
    root.setInnerHtml(template, treeSanitizer: html.NodeTreeSanitizer.trusted);
    if (subMessage != null) {
      var btnEle = html.DivElement();
      btnEle.attributes['style'] = "padding-top:15px;padding-bottom:5px;cursor: pointer;";
      var t =
          '<label class="text-muted" style="cursor: pointer;">$detailLabel  </label> <a class="list-icons-item dropdown-toggle" data-toggle="dropdown" ></a>';
      btnEle.setInnerHtml(t, treeSanitizer: html.NodeTreeSanitizer.trusted);
      root.querySelector('.modal-body').append(btnEle);

      var container = html.DivElement();
      container.classes.add('modal-detail');
      root.querySelector('.modal-body').append(container);

      btnEle.onClick.listen((e) {
        var el = e.target as html.HtmlElement;
        if (el?.closest('.modal-body')?.querySelector('.modal-detail')?.style?.display == 'none') {
          el?.closest('.modal-body')?.querySelector('.modal-detail')?.style?.display = 'block';
        } else {
          el?.closest('.modal-body')?.querySelector('.modal-detail')?.style?.display = 'none';
        }
      });

      container.style.overflow = 'hidden';
      container.style.display = 'none';
      container.text = subMessage;
    }
    root.querySelector('button.BtnOk').onClick.listen((e) {
      root.remove();
    });
  }

  static showConfirm(String message,
      {String title = "Confirmar",
      String cancelButtonText = "Cancelar",
      Function cancelAction,
      String confirmButtonText = "Sim",
      Function confirmAction,
      DialogColor dialogColor = DialogColor.WARNING}) {
    var template = ''' 
      <div class="bootbox modal fade bootbox-alert show" tabindex="-1" role="dialog" style="padding-right: 17px; display: block;">
        <div class="modal-dialog">
            <div class="modal-content">                
                <div class="modal-header bg-${getColor(dialogColor)}">
                  <h6 class="modal-title">$title</h6>
                  <!--<button type="button" class="close" data-dismiss="modal">×</button>-->
							  </div>
                <div class="modal-body">
                    <div class="bootbox-body">$message</div>
                </div>
               <div class="modal-footer">
               <button data-bb-handler="cancel" type="button" class="BtnCancel btn btn-link">$cancelButtonText</button>
               <button data-bb-handler="confirm" type="button" class="BtnOk btn bg-orange-600">$confirmButtonText</button></div>
            </div>
        </div>
    </div>
    <div class="modal-backdrop fade show"></div>
    ''';
    html.DivElement root = html.DivElement();
    html.document.querySelector('body').append(root);
    root.setInnerHtml(template, treeSanitizer: html.NodeTreeSanitizer.trusted);
    root.querySelector('button.BtnCancel').onClick.listen((e) {
      if (cancelAction != null) {
        cancelAction();
      }
      root.remove();
    });
    root.querySelector('button.BtnOk').onClick.listen((e) {
      if (confirmAction != null) {
        confirmAction();
      }
      root.remove();
    });
  }
}
