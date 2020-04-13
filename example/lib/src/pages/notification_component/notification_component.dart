import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';
import 'package:example/app_component.dart';
import 'package:example/src/utils/highlighting_js.dart';

@Component(
  selector: 'notification-component',
  styleUrls: ['notification_component.css'],
  templateUrl: 'notification_component.html',
  directives: [
    coreDirectives,
    esDynamicTabsDirectives,
    EssentialModalComponent,
  ],
  exports: [],
  providers: [
  ]
)
class NotificationComponent implements OnInit{


  String codeHtml = '''
 <es-notification-outlet [service]='notificationService'></es-notification-outlet>
''';

  String appComponent = '''
 static EssentialNotificationService notificationService = EssentialNotificationService();
''';

  String codeDart = '''
      execute() {
        AppComponent.notificationService.add('success', 'Teste', 'Test');
      }
  ''';

  NotificationComponent();

  execute() {
    AppComponent.notificationService.add('success', 'Teste', 'Test');
  }

  @override
  void ngOnInit() {
    codeDart = highlightingDart(codeHtml);
    codeHtml = highlightingHtml(appComponent);
    codeHtml = highlightingHtml(codeDart);
  }

}
