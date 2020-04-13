import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';

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
  providers: [

  ]
)
class ToastExComponent {

  @ViewChild('toast')
  EssentialToastComponent toast;

  execute() {
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


}
