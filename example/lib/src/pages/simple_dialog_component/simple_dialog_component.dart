import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';
import 'package:example/src/utils/highlighting_js.dart';

@Component(
  selector: 'simple-dialog-component',
  styleUrls: ['simple_dialog_component.css'],
  templateUrl: 'simple_dialog_component.html',
  directives: [
    coreDirectives,
    esDynamicTabsDirectives,
    SimpleDialogComponent
  ],
  exports: [],
  providers: []
)
class ExSimpleDialogComponent implements OnInit {

  String htmlCode = '''
  <button class="btn btn-primary" (click)="showAlert()">Execute Alert</button>
''';
  String dartCode = '''
  SimpleDialogComponent dialog;

  showAlert() {
    SimpleDialogComponent.showAlert('Legal! Yes shure!', title: 'Success', detailLabel: 'Detail label', dialogColor: DialogColor.SUCCESS, subMessage: 'Estou muito orgulhoso de você!');
  }
  ''';

  SimpleDialogComponent dialog;

  showAlert() {
    SimpleDialogComponent.showAlert('Legal! Yes shure!', title: 'Success', detailLabel: 'Detail label', dialogColor: DialogColor.SUCCESS, subMessage: 'Estou muito orgulhoso de você!');
  }

  @override
  void ngOnInit() {
    dartCode = highlightingHtml(dartCode);
    htmlCode = highlightingHtml(htmlCode);
  }

}
