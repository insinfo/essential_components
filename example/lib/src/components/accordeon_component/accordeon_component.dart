import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';
import 'package:example/src/services/person_service.dart';

@Component(
  selector: 'accordeon-component',
  styleUrls: ['accordeon_component.css'],
  templateUrl: 'accordeon_component.html',
  directives: [
    coreDirectives,
    esDynamicTabsDirectives,
    EsAccordionPanelComponent
  ],
  exports: [],
  providers: [ClassProvider(PersonService)]
)
class AccordeonComponent implements OnInit {

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



  AccordeonComponent();

  @override
  void ngOnInit() {
  }

}
