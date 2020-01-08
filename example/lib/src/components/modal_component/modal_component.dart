import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';
import 'package:example/src/services/person_service.dart';

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
  providers: [ClassProvider(PersonService)]
)
class ModalComponent implements OnInit {

  bool show = false;

  ModalComponent();

  @override
  void ngOnInit() {
  }

}
