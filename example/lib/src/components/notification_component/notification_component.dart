import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';

@Component(
  selector: 'notification-component',
  styleUrls: ['notification_component.css'],
  templateUrl: 'notification_component.html',
  directives: [
    coreDirectives,
    esDynamicTabsDirectives,
    EssentialModalComponent
  ],
  exports: [],
  providers: []
)
class NotificationComponent {

}
