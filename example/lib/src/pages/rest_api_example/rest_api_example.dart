import 'dart:convert';

import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';
import 'package:essential_rest/essential_rest.dart';

import 'dart:html' as html;

//import 'package:universal_html/prefer_universal/html.dart' if (dart.library.js) 'package:universal_html/html.dart'
import 'package:universal_html/prefer_universal/html.dart' as uhtml;
import '../../utils/highlighting_js.dart';

@Component(
    selector: 'rest-api-example',
    styleUrls: ['rest_api_example.css'],
    templateUrl: 'rest_api_example.html',
    directives: [
      coreDirectives,
      esDynamicTabsDirectives,
    ],
    exports: [],
    providers: [])
class RestApiExampleComponent implements OnInit {
  //@ViewChild('fileInput')
  //html.FileUploadInputElement fileInput;

  String codeFileUploadingExample = ''' 
  import 'package:angular/angular.dart';
  import 'package:essential_components/essential_components.dart';
  import 'package:universal_html/prefer_universal/html.dart' as uhtml;

  
  void upload(e) async {
      var fileInput = html.querySelector('body #fileInput') as html.FileUploadInputElement;
      print('upload \$fileInput');
      if (fileInput != null && fileInput.files.isNotEmpty) {
        var rest = RestClientGeneric();
        var resp = await rest.uploadFiles(
          '/',
          fileInput.files,
          body: {'nome': 'Isaque'},
          protocol: 'http',
          hosting: 'localhost',
          hostPort: 8888,
          basePath: '',
        );
        print(resp.data);
      }
    }
  ''';
  String restRaw = ''' 
Future<void> findAll({String action}) async {
  try {
    var rest = RestClientGeneric();
    var dataToSend = {
      'action': action
    };
    var resp = await rest.raw('http://google.com', 'GET',
        headers: {
          'authorization': 'Bearer You Token'
        }, body: jsonEncode(dataToSend));
    print(resp.data);
  } catch (e) {
    print('findAll({String action}) ' + e.toString());
    return null;
  }
}
  ''';

  RestApiExampleComponent();

  @override
  void ngOnInit() {
    codeFileUploadingExample = highlightingDart(codeFileUploadingExample);
    restRaw = highlightingDart(restRaw);
  }

  void upload(e) async {
    var fileInput = html.querySelector('body #fileInput') as html.FileUploadInputElement;
    print('upload $fileInput');
    if (fileInput != null && fileInput.files.isNotEmpty) {
      var rest = RestClientGeneric();
      var resp = await rest.uploadFiles(
        '/',
        fileInput.files as List<uhtml.File>,
        body: {'nome': 'Isaque'},
        protocol: 'http',
        hosting: 'localhost',
        hostPort: 8888,
        basePath: '',
      );
      print(resp.data);
    }
  }

  Future<void> findAll({String action}) async {
    try {
      var rest = RestClientGeneric();
      var dataToSend = {'action': action};
      var resp = await rest.raw('http://google.com', 'GET',
          headers: {'authorization': 'Bearer You Token'}, body: jsonEncode(dataToSend));
      print(resp.data);
    } catch (e) {
      print('findAll({String action}) ' + e.toString());
      return null;
    }
  }
}
