import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';
import 'package:example/src/models/person.dart';
import 'package:example/src/services/person_service.dart';
import 'package:essential_rest/essential_rest.dart';
import 'package:example/src/utils/highlighting_js.dart';

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
    providers: [ClassProvider(PersonService)])
class DropdownDialogComponent implements OnInit {
  @Input('btnRadio')
  EsRadioButtonDirective btnRadio;

  @ViewChild('dropdownDialog')
  EssentialDropdownDialogComponent dropdownDialog;

  RList<Person> persons;
  final PersonService _service;

  DropdownDialogComponent(this._service);

  @override
  void ngOnInit() {
    dartCode = highlightingHtml(dartCode);
    htmlCode = highlightingDart(htmlCode);
    _service.findAll().then((RestResponseGeneric resp) {
      if (resp.statusCode == 200) {
        persons = resp.dataTypedList;
        //print(persons);
      }
    });
  }

  String dartCode = '''
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
        //print(persons);
      }
    });
  }
  ''';

  String htmlCode = '''
  <es-dropdown-dialog label="Add Item" (change)="onSelect(\$event)" #dropdownDialog
      [data]="persons" (dataRequest)="onRequest(\$event)" [title]="'Title Dropdown'"
      (click)="addItem(\$event)" [openonclick]="true">
  </es-dropdown-dialog>'
  ''';

  void onSelect(dynamic event) {
    //print(event);
  }

  void onRequest(dynamic event) {
    //print(event);
  }

  void addItem(dynamic event) {
    //print(event);
  }
}
