import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';
//import 'package:universal_html/html.dart' as html;
import 'package:universal_html/prefer_universal/html.dart' as html;
import '../../utils/highlighting_js.dart';

import 'package:essential_rest/essential_rest.dart';

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
 import 'package:universal_html/prefer_universal/html.dart' as html;

  
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

  RestApiExampleComponent();

  @override
  void ngOnInit() {

    codeFileUploadingExample = highlightingDart(codeFileUploadingExample);
  }

  void upload(e) async {
    var fileInput = html.querySelector('body #fileInput') as html.FileUploadInputElement;
    print('upload $fileInput');
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
}
