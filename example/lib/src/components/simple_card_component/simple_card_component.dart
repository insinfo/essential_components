import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';

@Component(
  selector: 'simple-card-component',
  styleUrls: ['simple_card_component.css'],
  templateUrl: 'simple_card_component.html',
  directives: [
    coreDirectives,
    esDynamicTabsDirectives,
  ],
  exports: [],
  providers: []
)
class SimpleCardComponent {

}
