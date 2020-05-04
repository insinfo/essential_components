import 'package:angular/angular.dart';

import 'package:example/src/pages/recaptcha_example/recaptcha_example.dart';
import 'package:example/src/route_path.dart';
import 'package:example/src/routes.dart';

import '../accordeon_example/accordeon_example.dart';
import '../datapicker_component/datapicker_component.dart';
import '../datatable_component/datatable_component.dart';
import '../dropdown_dialog_component/dropdown_dialog_component.dart';
import '../dynamic_tabs_component/dynamic_tabs_component.dart';
import '../modal_component/modal_component.dart';
import '../notification_component/notification_component.dart';
import '../rest_api_example/rest_api_example.dart';
import '../select_dialog_component/select_dialog_component.dart';
import '../simple_card_example/simple_card_example.dart';
import '../simple_dialog_component/simple_dialog_component.dart';
import '../simple_select_component/simple_select_component.dart';
import '../timeline_component/timeline_component.dart';
import '../toast_component/toast_component.dart';
import '../recaptcha_example/recaptcha_example.dart';

@Component(
    selector: 'content-component',
    styleUrls: ['content_component.css'],
    templateUrl: 'content_component.html',
    directives: [
      coreDirectives,
      DataTableComponent,
      AccordeonComponent,
      DataPickerComponent,
      DropdownDialogComponent,
      DynamicTabsComponent,
      ModalComponent,
      NotificationComponent,
      RestApiExampleComponent,
      SelectDialogComponent,
      SimpleCardComponent,
      ExSimpleDialogComponent,
      SimpleSelectComponent,
      TimelineExComponent,
      ToastExComponent,
      RecaptchaExample
    ],
    exports: [Routes, RoutePaths])
class ContentComponent implements OnInit {
  ContentComponent();

  @override
  void ngOnInit() async {}
}
