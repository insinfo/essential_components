import 'package:angular/angular.dart';
import 'package:ng_fontawesome/ng_fontawesome.dart';

import 'notification_services.dart';

/// Top navigation component.
@Component(
  selector: 'es-notification-outlet', 
  templateUrl: 'notification.html', 
  styleUrls: [
  'notification.css',
],
   /* styles: [
      ''' 
        @keyframes toast-fade-in {
        from {opacity: 0;}
        to {opacity: 1;}
        }

        @keyframes toast-fade-out {
        from {opacity: 1;}
        to {opacity: 0;}
        }

        @keyframes timer {
        from {width: 0%;}
        to {width: 100%;}
        }
   '''
    ],*/
    directives: [
      coreDirectives,
      fontAwesomeDirectives
    ] //FA_DIRECTIVES FaIcon
    )
class EssentialNotificationComponent {
  @Input()
  EssentialNotificationService service;

  /// Produce a CSS style for the `top` property.
  String styleTop(int i) {
    return (i * 110).toString() + "px";
  }
}
