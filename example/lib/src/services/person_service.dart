import 'package:angular/angular.dart';
import 'package:example/src/models/person.dart';
import 'dart:html' as html;

import 'package:essential_rest/essential_rest.dart';
import 'package:essential_components/essential_components.dart';

@Injectable()
class PersonService {
  RestClientGeneric rest;

  PersonService() {
    rest = RestClientGeneric<Person>(factory: {Person: (x) => Person.fromJson(x)});
    rest.port = int.tryParse(html.window.location.port);
    rest.basePath = '';
    rest.host = html.window.location.hostname;
    rest.protocol = ProtocolType.http;
  }

  Future<RestResponseGeneric> findAll({DataTableFilter filters}) {
    return rest.getAll('/exemple_data.json', queryParameters: filters?.getParams(),encoding: 'utf8');
  }
}
