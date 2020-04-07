import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';

@Component(
  selector: 'simple-dialog-component',
  styleUrls: ['simple_dialog_component.css'],
  templateUrl: 'simple_dialog_component.html',
  directives: [
    coreDirectives,
    esDynamicTabsDirectives,
    SimpleDialogComponent
  ],
  exports: [],
  providers: []
)
class ExSimpleDialogComponent {

  SimpleDialogComponent dialog;

  ExSimpleDialogComponent();

  showAlert() {
    SimpleDialogComponent.showAlert('Legal! Yes shure!', title: 'Success', detailLabel: 'Detail label', dialogColor: DialogColor.SUCCESS, subMessage: 'Estou muito orgulhoso de você!');
  }

}
