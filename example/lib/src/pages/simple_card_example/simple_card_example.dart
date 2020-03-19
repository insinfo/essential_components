import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';
import 'simple.dart';
import '../../models/person.dart';
import '../../services/person_service.dart';

@Component(
  selector: 'simple-card-component',
  styleUrls: ['simple_card_example.css'],
  templateUrl: 'simple_card_example.html',
  directives: [
    coreDirectives,
    esDynamicTabsDirectives,
    EssentialSimpleCardComponent
  ],
  exports: [],
  providers: []
)
class SimpleCardComponent {

  Simple simple = Simple();

  SimpleCardComponent();



}
