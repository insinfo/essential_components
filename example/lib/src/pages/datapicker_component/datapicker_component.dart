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
<es-accordion-panel heading="Título do acordeon">
  <p>Lorem ipsum dolor, sit amet consectetur adipisicing elit. Delectus dignissimos site.</p>
</es-accordion-panel>''';
  String codeComponent = '''
import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';
import 'package:example/src/services/person_service.dart';

@Component(
  selector: 'accordeon-component',
  styleUrls: ['accordeon_component.css'],
  templateUrl: 'accordeon_component.html',
  directives: [
    coreDirectives,
    EsAccordionPanelComponent
  ],
  exports: [],
  providers: [ClassProvider(PersonService)]
)
class AccordeonComponent { }
  ''';

  DataPickerComponent();

  @override
  void ngOnInit() {
    codeHtml = highlightingHtml(codeHtml);
    codeComponent = highlightingHtml(codeComponent);
  }

  void reloadData(dynamic event) {
    //print(event);
  }
}
