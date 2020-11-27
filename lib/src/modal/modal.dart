import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';
import 'dart:html' as html;

enum EssentialModalSize { miniSize, smallSize, defaultSize, largeSize, fullSize }

/*extension EssentialModalSizeExtension on EssentialModalSize {
  String get asCssClass {
    switch (this) {
      case EssentialModalSize.miniSize:
        return 'modal-xs';
        break;
      case EssentialModalSize.smallSize:
        return 'modal-sm';
        break;
      case EssentialModalSize.defaultSize:
        return '';
        break;
      case EssentialModalSize.largeSize:
        return 'modal-lg';
        break;
      case EssentialModalSize.fullSize:
        return 'modal-full';
        break;
      default:
        return '';
    }
  }
  String asString() => toString().split('.').last;
}*/

enum EssentialModalHeaderColor { primary, danger, success, info, brown, teal, none }

/*extension EssentialModalHeaderColorExtension on EssentialModalHeaderColor {
  String get asCssClass {
    switch (this) {
      case EssentialModalHeaderColor.primary:
        return 'bg-primary';
        break;
      case EssentialModalHeaderColor.danger:
        return 'bg-danger';
        break;
      case EssentialModalHeaderColor.success:
        return 'bg-success';
        break;
      case EssentialModalHeaderColor.info:
        return 'bg-info';
        break;
      case EssentialModalHeaderColor.brown:
        return 'bg-brown';
        break;
      case EssentialModalHeaderColor.teal:
        return 'bg-teal';
        break;
      case EssentialModalHeaderColor.none:
        return '';
        break;
      default:
        return '';
    }
  }
}*/

@Component(
    selector: 'es-modal',
    templateUrl: 'modal.html',
    styleUrls: ['modal.css'],
    directives: [coreDirectives, formDirectives, routerDirectives])
class EssentialModalComponent {
  @Input('headerColor')
  EssentialModalHeaderColor modalHeaderColor = EssentialModalHeaderColor.primary;

  String get headerColorClass {
    return _enumModalHeaderColorToCssClass(modalHeaderColor);
  }

  String _enumModalHeaderColorToCssClass(EssentialModalHeaderColor _enum) {
    switch (_enum) {
      case EssentialModalHeaderColor.primary:
        return 'bg-primary';
        break;
      case EssentialModalHeaderColor.danger:
        return 'bg-danger';
        break;
      case EssentialModalHeaderColor.success:
        return 'bg-success';
        break;
      case EssentialModalHeaderColor.info:
        return 'bg-info';
        break;
      case EssentialModalHeaderColor.brown:
        return 'bg-brown';
        break;
      case EssentialModalHeaderColor.teal:
        return 'bg-teal';
        break;
      case EssentialModalHeaderColor.none:
        return '';
        break;
      default:
        return '';
    }
  }

  @Input()
  bool disabledBackdropClick = true;

  @ViewChild('currentModal')
  html.DivElement currentModal;

  @Input('size')
  EssentialModalSize modalSize = EssentialModalSize.largeSize;

  String _enumModalSizeToCssClass(EssentialModalSize _enum) {
    switch (_enum) {
      case EssentialModalSize.miniSize:
        return 'modal-xs';
        break;
      case EssentialModalSize.smallSize:
        return 'modal-sm';
        break;
      case EssentialModalSize.defaultSize:
        return '';
        break;
      case EssentialModalSize.largeSize:
        return 'modal-lg';
        break;
      case EssentialModalSize.fullSize:
        return 'modal-full';
        break;
      default:
        return '';
    }
  }

  String get sizeClass {
    return _enumModalSizeToCssClass(modalSize);
  }

  @Input()
  bool showheader = false;

  @Input()
  bool showHeaderCloseBtn = true;

  @Input()
  bool blockCloseAction = false;

  bool inputShowDialog = false;

  //

  @Input('showDialog')
  set showDialog(bool v) {
    var modais = html.document.body.querySelectorAll('.essentialModal');
    if (v) {
      html.document.body.classes.add('modal-open');
      if (modais.length > 1) {
        for (var idx = 0; idx < modais.length - 1; idx++) {
          var modal = modais[idx];

          if (modal != currentModal) {
            var oldClass = modal.classes.join(' ').replaceAll('modal', 'modal-back');
            modal.attributes['class'] = oldClass;
          }
        }
      }
    } else {
      for (var idx = 0; idx < modais.length; idx++) {
        var modal = modais[idx];
        var oldClass = modal.classes.join(' ').replaceAll('modal-back', 'modal');
        modal.attributes['class'] = oldClass;
      }
    }
    inputShowDialog = v;
  }

  bool get showDialog => inputShowDialog;

  @Input()
  String title = '';

  final _closeRequest = StreamController<bool>();

  @Output()
  Stream<bool> get close => _closeRequest.stream;

  void openDialog() {
    showDialog = true;
  }

  void closeDialog() {
    if (!blockCloseAction) {
      showDialog = false;
    }

    _closeRequest.add(showDialog);
  }
}
