import 'dart:html' as html;

enum DialogColor { DANGER, PRIMARY, SUCCESS, WARNING, INFO }

class SimpleDialogComponent {
  static getColor(DialogColor dialogColor) {
    var headerColor = "";
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
        headerColor = 'orange-600';
        break;
      case DialogColor.INFO:
        headerColor = 'info';
        break;
    }
    return headerColor;
  }

  static showAlert(String message, {String title = "Alerta", DialogColor dialogColor = DialogColor.PRIMARY}) {
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
                    <button data-bb-handler="ok" type="button" class="BtnOk btn btn-primary">OK</button>
                </div>
            </div>
        </div>
    </div>
    <div class="modal-backdrop fade show"></div>
    ''';
    html.DivElement root = html.DivElement();
    html.document.querySelector('body').append(root);
    root.setInnerHtml(template, treeSanitizer: html.NodeTreeSanitizer.trusted);
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
