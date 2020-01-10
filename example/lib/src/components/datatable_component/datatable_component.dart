import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';
import 'package:example/src/models/person.dart';
import 'package:example/src/services/person_service.dart';

import '../../utils/highlighting_js.dart';

import 'package:highlight/highlight.dart';

@Component(
    selector: 'datatable-component',
    styleUrls: ['datatable_component.css'],
    templateUrl: 'datatable_component.html',
    directives: [coreDirectives, esDynamicTabsDirectives, EssentialDataTableComponent],
    exports: [],
    providers: [ClassProvider(PersonService)])
class DataTableComponent implements OnInit {
  @ViewChild('dataTable')
  EssentialDataTableComponent dataTable;

  String codeHtml =
      '''<es-data-table #dataTable [data]="persons" (dataRequest)="onRequestData(\$event)" [showCheckboxSelect]="false"></es-data-table>''';
  String codeComponent = '''
    import 'package:angular/angular.dart';
    import 'package:essential_components/essential_components.dart';
    import 'package:example/src/models/person.dart';
    import 'package:example/src/services/person_service.dart';

    @Component(
      selector: 'datatable-component',
      styleUrls: ['datatable_component.css'],
      templateUrl: 'datatable_component.html',
      directives: [
        coreDirectives,
        esDynamicTabsDirectives,
        EssentialDataTableComponent
      ],
      exports: [],
      providers: [ClassProvider(PersonService)]
    )
    class DataTableComponent implements OnInit {

      @ViewChild('dataTable')
      EssentialDataTableComponent dataTable;

      PersonService _personService;

    RList<Person> persons;
    Person person;

    DataTableComponent(this._personService);

    @override
    void ngOnInit() async {
      findAll();
    }

    findAll() {
      _personService.findAll().then((RestResponseGeneric resp) {
        if (resp.statusCode == 200) {
          persons = resp.dataTypedList;
        }
      });
    }

    onRequestData(DataTableFilter filters) {
    }
  ''';

  String codeService = '''
    import 'package:angular/angular.dart';
        import 'package:essential_components/essential_components.dart';
        import 'package:example/src/models/person.dart';

        @Injectable()
        class PersonService {

            RestClientGeneric rest;

            PersonService() {
            RestClientGeneric.basePath = '';
            RestClientGeneric.host = "localhost";
            RestClientGeneric.protocol = UriMuProtoType.http;
            RestClientGeneric.port = 8080;
            rest = RestClientGeneric<Person>(factories: {Person: (x) => Person.fromJson(x)});
                }

            Future<RestResponseGeneric> findAll({DataTableFilter filters}) {
                return rest.getAll('/exemple_data.json', queryParameters: filters?.getParams());
            }

        }
  ''';

  PersonService _personService;

  RList<Person> persons;
  Person person;

  DataTableComponent(this._personService);

  @override
  void ngOnInit() async {
    findAll();
    /*codeHtml = highlight.parse(codeHtml, language: 'html').toHtml();
    codeService = highlight.parse(codeService, language: 'dart').toHtml();
    codeComponent = highlight.parse(codeComponent, language: 'dart').toHtml();*/
    
    codeHtml = highlightingHtml(codeHtml);
    codeService = highlightingDart(codeService);
    codeComponent = highlightingDart(codeComponent);
    print(highlightingHtml(codeHtml));
  }

  findAll() {
    _personService.findAll().then((RestResponseGeneric resp) {
      if (resp.statusCode == 200) {
        persons = resp.dataTypedList;
      }
    });
  }

  onRequestData(DataTableFilter filters) {}
}
