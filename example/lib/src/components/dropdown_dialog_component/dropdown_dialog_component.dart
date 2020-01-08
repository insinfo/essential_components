import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';
import 'package:example/src/models/person.dart';
import 'package:example/src/services/person_service.dart';

@Component(
  selector: 'dropdown-dialog-component',
  styleUrls: ['dropdown_dialog_component.css'],
  templateUrl: 'dropdown_dialog_component.html',
  directives: [
    coreDirectives,
    esDynamicTabsDirectives,
    EsRadioButtonDirective,
    bsDropdownDirectives,
    EssentialDropdownDialogComponent
  ],
  exports: [],
  providers: [ClassProvider(PersonService)]
)
class DropdownDialogComponent implements OnInit {

  @Input('btnRadio')
  EsRadioButtonDirective btnRadio;

  @ViewChild('dropdownDialog')
  EssentialDropdownDialogComponent dropdownDialog; 

  RList<Person> persons;
  PersonService _service;

  DropdownDialogComponent(this._service);

  @override
  void ngOnInit() {
    _service.findAll().then((RestResponseGeneric resp) {
      if (resp.statusCode == 200) {
        persons = resp.dataTypedList;
        print(persons);
      }
    });
  }

  onSelect(dynamic event) {
    print(event);
  }

  onRequest(dynamic event) {
    print(event);
  }

  addItem(dynamic event) {
    print(event);
  }

}
