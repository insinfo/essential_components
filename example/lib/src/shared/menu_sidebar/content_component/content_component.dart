import 'package:angular/angular.dart';
import 'package:example/src/components/accordeon_component/accordeon_component.dart';
import 'package:example/src/components/button_component/button_component.dart';
import 'package:example/src/components/datapicker_component/datapicker_component.dart';
import 'package:example/src/components/datatable_component/datatable_component.dart';
import 'package:example/src/components/dropdown_component/dropdown_component.dart';
import 'package:example/src/components/dropdown_dialog_component/dropdown_dialog_component.dart';
import 'package:example/src/components/dynamic_tabs_component/dynamic_tabs_component.dart';
import 'package:example/src/components/modal_component/modal_component.dart';
import 'package:example/src/components/notification_component/notification_component.dart';
import 'package:example/src/components/rest_api_example/rest_api_example.dart';
import 'package:example/src/components/select_dialog_component/select_dialog_component.dart';
import 'package:example/src/components/simple_card_component/simple_card_component.dart';
import 'package:example/src/components/simple_dialog_component/simple_dialog_component.dart';
import 'package:example/src/components/simple_loading_component/simple_loading_component.dart';
import 'package:example/src/components/simple_select_component/simple_select_component.dart';
import 'package:example/src/components/simple_tabs_component/simple_tabs_component.dart';
import 'package:example/src/components/timeline_component/timeline_component.dart';
import 'package:example/src/components/toast_component/toast_component.dart';


@Component(
  selector: 'content-component',
  styleUrls: ['content_component.css'],
  templateUrl: 'content_component.html',
  directives: [
    coreDirectives,
    DataTableComponent,
    AccordeonComponent,
    ButtonComponent,
    DataPickerComponent,
    DropdownComponent,
    DropdownDialogComponent,
    DynamicTabsComponent,
    ModalComponent,
    NotificationComponent,
    RestApiExampleComponent,
    SelectDialogComponent,
    SimpleCardComponent,
    ExSimpleDialogComponent,
    SimpleLoadingComponent,
    SimpleSelectComponent,
    SimpleTabsComponent,
    TimelineExComponent,
    ToastExComponent
  ],
  exports: []
)
class ContentComponent implements OnInit {

  ContentComponent();

  @override
  void ngOnInit() async {
  }

}
