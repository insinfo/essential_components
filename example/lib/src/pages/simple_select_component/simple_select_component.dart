import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:example/src/models/person.dart';
import 'package:example/src/services/person_service.dart';
import 'package:essential_rest/essential_rest.dart';
import 'package:example/src/utils/highlighting_js.dart';

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
    providers: [ClassProvider(PersonService)])
class SimpleSelectComponent implements OnInit {
  final PersonService _personService;
  RList<Person> persons = RList<Person>();
  Person person;
  StyleType color = StyleType.SUCCESS;

  SimpleSelectComponent(this._personService);

  @override
  void ngOnInit() {
    dartCode = highlightingHtml(dartCode);
    htmlCode = highlightingHtml(htmlCode);
    modelCode = highlightingHtml(modelCode);
    findAllPerson();
  }

  void findAllPerson() {
    _personService.findAll().then((RestResponseGeneric resp) {
      if (resp.status == RestStatus.SUCCESS) {
        persons = resp.dataTypedList;
      }
    });
  }

  String htmlCode = '''
  <es-simple-select [(ngModel)]="person" displaytype="button" buttonText="Selecione"
                                                  [options]="persons" [color]="color">
                                    <es-simple-select-option [value]="null" [disable]="true">Abobora</es-simple-select-option>
                                    <es-simple-select-option [value]="null" [disable]="true">Maça</es-simple-select-option>
                                </es-simple-select>
''';

  String dartCode = '''
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
''';

  String modelCode = '''
  class Person implements ISimpleSelectRender {
  String name;
  @override
  String getDisplayName() {
    return name;
  }
} 
  ''';
}
