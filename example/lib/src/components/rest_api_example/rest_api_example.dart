import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';
import 'dart:html' as html;

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

  @ViewChild('fileInput')
  html.FileUploadInputElement fileInput;

  String codeFileUploadingExample = ''' 
 import 'package:angular/angular.dart';
  import 'package:essential_components/essential_components.dart';
  import 'dart:html' as html;

  @ViewChild('fileInput')
  html.FileUploadInputElement fileInput;

  RestClientGeneric rest = new RestClientGeneric();
   var resp = await rest.uploadFiles('/restApiEndpoint', fileInput.files, protocol: 'http', host: 'localhost', port: 8888, basePath: '');
  print(resp.data);// <= is Map<String, String>
  ''';

  RestApiExampleComponent() {

  }

  @override
  void ngOnInit() {
     codeFileUploadingExample = highlightingDart(codeFileUploadingExample);
  }

  upload(e) async {
    if (fileInput.files.isNotEmpty) {
      RestClientGeneric rest = RestClientGeneric();
      var resp =
          await rest.uploadFiles('/', fileInput.files,body: {"nome":"Isaque"}, protocol: 'http', host: 'localhost', port: 8888, basePath: '');
      print(resp.data);
    }
  }
}
