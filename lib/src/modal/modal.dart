import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';

enum EssentialModalSize { miniSize, smallSize, defaultSize, largeSize, fullSize }

enum EssentialModalHeaderColor { primary, danger, success, info, brown, teal, none }

@Component(
    selector: 'es-modal',
    templateUrl: 'modal.html',
    styleUrls: ['modal.css'],
    directives: [coreDirectives, formDirectives, routerDirectives])
class EssentialModalComponent {
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

  @Input('headerColor')
  EssentialModalHeaderColor modalHeaderColor = EssentialModalHeaderColor.primary;

  String get sizeHeaderColorClass {
    return _enumModalHeaderColorToCssClass(modalHeaderColor);
  }

  @Input('size')
  EssentialModalSize modalSize = EssentialModalSize.largeSize;

  String get sizeClass {
    return _enumModalSizeToCssClass(modalSize);
  }

  @Input()
  bool showheader = false;

  @Input()
  bool showDialog = false;

  @Input()
  String title = '';

  final _closeRequest = StreamController<bool>();

  @Output()
  Stream<bool> get close => _closeRequest.stream;

  void openDialog() {
    showDialog = true;
  }

  void closeDialog() {
    showDialog = false;
    _closeRequest.add(showDialog);
  }
}
