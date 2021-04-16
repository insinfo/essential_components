import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';
import 'package:example/src/services/person_service.dart';
import 'package:example/src/utils/highlighting_js.dart';

@Component(
    selector: 'modal-component',
    styleUrls: ['modal_component.css'],
    templateUrl: 'modal_component.html',
    directives: [
      coreDirectives,
      esDynamicTabsDirectives,
      EssentialModalComponent
    ],
    exports: [],
    providers: [ClassProvider(PersonService)])
class ModalComponent implements OnInit {
  bool show = false;

  String codeHtml = '''
  <button class="btn btn-primary" (click)="show = !show;">Show Modal Example</button>
  <es-modal title="Modal Example" [showheader]="true" [showDialog]="show">
      <div class="p-3">
          Lorem, ipsum dolor sit amet consectetur adipisicing elit. Blanditiis iure optio id. Odio reiciendis saepe fuga ipsa blanditiis beatae, veniam ullam architecto quisquam modi doloremque eveniet delectus facere ducimus. Voluptatem.
      </div>
  </es-modal>
  ''';

  String codeDart = '''
bool show = false;   
  ''';

  ModalComponent();

  @override
  void ngOnInit() {
    codeHtml = highlightingHtml(codeHtml);
    codeDart = highlightingHtml(codeDart);
  }

  void showModal() {
    show = !show;
  }
}
