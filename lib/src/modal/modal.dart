import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';

@Component(
    selector: 'es-modal',
    templateUrl: 'modal.html',
    styleUrls: ['modal.css'],
    directives: [coreDirectives, formDirectives, routerDirectives])
class EssentialModalComponent {
  @Input()
  bool showheader = false;

  @Input()
  bool showDialog = false;

  @Input()
  String title = '';

  final _closeRequest = StreamController<bool>();

  Map<String, bool> get showDialogMap => {
    'showElement': showDialog,
    'hideElement': !showDialog
  };

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
