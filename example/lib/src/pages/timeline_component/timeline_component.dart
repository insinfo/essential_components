import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';
import 'package:example/src/models/person.dart';
import 'package:essential_rest/essential_rest.dart';
import 'package:example/src/services/person_service.dart';
import 'dart:html' as html;

import 'package:example/src/utils/highlighting_js.dart';

@Component(
    selector: 'timeline-component',
    styleUrls: ['timeline_component.css'],
    templateUrl: 'timeline_component.html',
    directives: [coreDirectives, esDynamicTabsDirectives, EssentialTimelineComponent],
    exports: [],
    providers: [EssentialTimelineComponent])
class TimelineExComponent implements OnInit {
  var rest;
  RList<Person> persons;

  String codeHtml = '''
    <es-timeline [data]="persons"></es-timeline>
  ''';

  String modelCode = '''
  @override
  TimelineModel getModel;

  Person() {
    timelineInit();
  }

  timelineInit() {
    getModel = TimelineModel();
    getModel.contentTitle = 'Aqui vai o titulo';
    getModel.contentMutedSubtitle = 'Aqui vai a idade';
    getModel.description = 'Description is Hero';
    getModel.category = 'Category to Separation';
    getModel.update = DateTime.now();
    getModel.icon = 'icon-rocket';
    getModel.color = 'success-300';
  }
  ''';
  String codeComponent = '''
    rest = RestClientGeneric<Person>(factory: {Person: (x) => Person.fromJson(x)});
    rest.port = int.tryParse(html.window.location.port);
    rest.basePath = '';
    rest.host = html.window.location.hostname;
    rest.protocol = ProtocolType.http;
    rest.getAll('/exemple_data.json').then((RestResponseGeneric resp) async {
      persons = await resp.resultListT;
    });
  ''';

  @override
  void ngOnInit() async {
    codeComponent = highlightingHtml(codeComponent);
    codeHtml = highlightingHtml(codeHtml);
    modelCode = highlightingHtml(modelCode);
    var resp = await PersonService().findAll();
    persons = resp.resultListT;
  }
}
