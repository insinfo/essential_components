import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';
import 'package:example/src/utils/highlighting_js.dart';

@Component(
    selector: 'toast-ex-component',
    styleUrls: ['toast_component.css'],
    templateUrl: 'toast_component.html',
    directives: [
      coreDirectives,
      esDynamicTabsDirectives,
      EssentialToastComponent
    ],
    exports: [],
    providers: [])
class ToastExComponent implements OnInit {
  @ViewChild('toast')
  EssentialToastComponent toast;

  void execute() {
    toast.duration = Duration(seconds: 5);
    toast.showToast('Hello toast', type: ToastType.success);
  }

  String dartCode = '''
  @ViewChild('toast')
  EssentialToastComponent toast;

  execute() {
    toast.duration = Duration(seconds: 5);
    toast.showToast('Hello toast', type: ToastType.success);
  }
  ''';

  String htmlCode = '''
  '<button class="btn bg-primary" (click)="execute()">Toast Example</button>
  <es-toast #toast></es-toast>'
  ''';

  @override
  void ngOnInit() {
    dartCode = highlightingHtml(dartCode);
    htmlCode = highlightingHtml(htmlCode);
  }
}
