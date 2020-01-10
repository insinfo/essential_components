import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';
import 'package:example/src/models/person.dart';

import 'dart:html' as html;

@Injectable()
class PersonService {
  RestClientGeneric rest;

  PersonService() {
    RestClientGeneric.basePath = '';
    RestClientGeneric.host = html.window.location.hostname;
    RestClientGeneric.protocol = UriMuProtoType.http;
    RestClientGeneric.port = int.tryParse(html.window.location.port);
    rest = RestClientGeneric<Person>(factories: {Person: (x) => Person.fromJson(x)});
  }

  Future<RestResponseGeneric> findAll({DataTableFilter filters}) {
    return rest.getAll('/exemple_data.json', queryParameters: filters?.getParams());
  }
}