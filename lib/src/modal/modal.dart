import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';

@Component(
    selector: 'es-modal',
    templateUrl: 'modal.html',
    styleUrls: ['modal.css'],
    directives: [coreDirectives, formDirectives, routerDirectives])
class EssentialModalComponent implements AfterContentInit {
  @Input()
  bool showheader = false;

  bool showDialog = false;

  @Input()
  String title = "";

  openDialog() {
    showDialog = true;
  }

  closeDialog() {
    showDialog = false;
  }

  @override
  ngAfterContentInit() {}
}
