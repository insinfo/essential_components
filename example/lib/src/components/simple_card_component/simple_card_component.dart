import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';
import 'package:example/src/components/simple_card_component/simple.dart';
import 'package:example/src/models/person.dart';
import 'package:example/src/services/person_service.dart';

@Component(
  selector: 'simple-card-component',
  styleUrls: ['simple_card_component.css'],
  templateUrl: 'simple_card_component.html',
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
