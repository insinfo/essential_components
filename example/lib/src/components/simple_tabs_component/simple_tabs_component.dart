import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';

@Component(
  selector: 'simple-tabs-component',
  styleUrls: ['simple_tabs_component.css'],
  templateUrl: 'simple_tabs_component.html',
  directives: [
    coreDirectives,
    esDynamicTabsDirectives,
  ],
  exports: [],
  providers: []
)
class SimpleTabsComponent {

}
