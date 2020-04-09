import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:essential_components/essential_components.dart';
import 'package:example/src/models/person.dart';
import 'package:example/src/services/person_service.dart';
import 'package:essential_rest/essential_rest.dart';

@Component(
    selector: 'select-dialog-component',
    styleUrls: ['select_dialog_component.css'],
    templateUrl: 'select_dialog_component.html',
    directives: [
      coreDirectives,
      formDirectives,
      esDynamicTabsDirectives,
      EssentialSelectDialogComponent
    ],
    exports: [],
    providers: [ClassProvider(PersonService)])
class SelectDialogComponent implements OnInit {
  Person person = Person();
  RList<Person> persons = RList<Person>();

  PersonService _service;
  SelectDialogComponent(this._service);

  @override
  void ngOnInit() {
    findAll();
  }

  findAll() {
    _service.findAll().then((RestResponseGeneric resp) {
      if (resp.statusCode == 200) {
        persons = resp.dataTypedList;
      }
    });
  }

}
