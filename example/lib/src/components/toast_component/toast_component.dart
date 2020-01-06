import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';

@Component(
  selector: 'toast-ex-component',
  styleUrls: ['toast_component.css'],
  templateUrl: 'toast_component.html',
  directives: [
    coreDirectives,
    esDynamicTabsDirectives,
  ],
  exports: [],
  providers: []
)
class ToastExComponent {

}
