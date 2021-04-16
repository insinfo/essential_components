import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:essential_components/essential_components.dart';
import 'package:example/src/services/person_service.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:example/src/utils/highlighting_js.dart';

@Component(
    selector: 'datapicker-component',
    styleUrls: ['datapicker_component.css'],
    templateUrl: 'datapicker_component.html',
    directives: [
      formDirectives,
      coreDirectives,
      EssentialToastComponent,
      routerDirectives,
      EssentialDataTableComponent,
      MaxlengthDirective,
      esDynamicTabsDirectives,
      EssentialSimpleSelectComponent,
      EsSimpleSelectOptionComponent,
      EsDatePickerPopupComponent,
      EsDatePickerComponent
    ],
    exports: [],
    providers: [ClassProvider(PersonService)])
class DataPickerComponent implements OnInit {
  @Input('btnRadio')
  EsRadioButtonDirective btnRadio;

  DateTime date = DateTime.now();

  String codeHtml = '''

 <es-date-picker-popup [(ngModel)]="date" currentText="Today" clearText="Clear" closeText="Close"
            [format]="'dd/MM/yyyy'" [localeRender]="'pt_BR'">
        </es-date-picker-popup>

''';
  
  var codeDart = '''
@Component(
    selector: 'datapicker-example',
    styleUrls: ['datapicker_example.css'],
    templateUrl: 'datapicker_example.html',
    directives: [
      formDirectives,
      coreDirectives,     
      EsDatePickerPopupComponent,
      EsDatePickerComponent
    ],
   )
class DataPickerComponent {
var date = DateTime.now();


}


  ''';
  DataPickerComponent();

  @override
  void ngOnInit() {
    codeHtml = highlightingHtml(codeHtml);
    codeDart = highlightingDart(codeDart);
  }

  void reloadData(dynamic event) {
    //print(event);
  }
}
