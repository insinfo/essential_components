import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';

@Component(
  selector: 'simple-dialog-component',
  styleUrls: ['simple_dialog_component.css'],
  templateUrl: 'simple_dialog_component.html',
  directives: [
    coreDirectives,
    esDynamicTabsDirectives,
  ],
  exports: [],
  providers: []
)
class SimpleDialogComponent {

}
