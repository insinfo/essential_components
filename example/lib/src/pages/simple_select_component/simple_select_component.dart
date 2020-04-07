import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:example/src/models/person.dart';
import 'package:example/src/services/person_service.dart';

@Component(
  selector: 'simple-select-component',
  styleUrls: ['simple_select_component.css'],
  templateUrl: 'simple_select_component.html',
  directives: [
    coreDirectives,
    esDynamicTabsDirectives,
    EssentialSimpleSelectComponent,
    EsSimpleSelectOptionComponent,
    formDirectives
  ],
  exports: [],
  providers: [
    ClassProvider(PersonService)
  ]
)
class SimpleSelectComponent implements OnInit {
  PersonService _personService;
  RList<Person> persons = RList<Person>();
  Person person;
  StyleType color = StyleType.SUCCESS;

  SimpleSelectComponent(this._personService);

  @override
  void ngOnInit() {
    findAllPerson();
  }

  void findAllPerson() {
    _personService.findAll().then((RestResponseGeneric resp) {
      if (resp.status == RestStatus.SUCCESS) {
        persons = resp.dataTypedList;
      }
    });
  }

  
}
