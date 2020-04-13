import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';
import 'package:example/src/models/person.dart';
import 'package:essential_rest/essential_rest.dart';
import 'dart:html' as html;

@Component(
  selector: 'timeline-component',
  styleUrls: ['timeline_component.css'],
  templateUrl: 'timeline_component.html',
  directives: [
    coreDirectives,
    esDynamicTabsDirectives,
    EssentialTimelineComponent
  ],
  exports: [],
  providers: [
    EssentialTimelineComponent
  ]
)
class TimelineExComponent {

  var rest;
  RList<Person> persons;

  TimelineExComponent() {
    rest = RestClientGeneric<Person>(factory: {Person: (x) => Person.fromJson(x)});
    rest.port = int.tryParse(html.window.location.port);
    rest.basePath = '';
    rest.host = html.window.location.hostname;
    rest.protocol = ProtocolType.http;
    rest.getAll('/exemple_data.json').then((RestResponseGeneric resp) async {
      persons = await resp.resultListT;
    });
  }

  String codeHtml =
  '''
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




}
