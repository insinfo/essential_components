import 'package:angular_router/angular_router.dart';
import 'package:example/src/route_path.dart';

import 'pages/accordeon_example/accordeon_example.template.dart'
    as accordeon_template;
import 'pages/content_page/content_component.template.dart' as home_template;
import 'pages/datapicker_component/datapicker_component.template.dart'
    as datapicker_template;
import 'pages/datatable_component/datatable_component.template.dart'
    as datatable_template;
import 'pages/dropdown_dialog_component/dropdown_dialog_component.template.dart'
    as dropdown_template;
import 'pages/dynamic_tabs_component/dynamic_tabs_component.template.dart'
    as dynamic_tabs_template;
import 'pages/modal_component/modal_component.template.dart' as modal_template;
import 'pages/notification_component/notification_component.template.dart'
    as notification_template;
import 'pages/recaptcha_example/recaptcha_example.template.dart'
    as recaptcha_template;
import 'pages/select_dialog_component/select_dialog_component.template.dart'
    as select_dialog_template;
import 'pages/simple_card_example/simple_card_example.template.dart'
    as simple_card_template;
import 'pages/simple_dialog_component/simple_dialog_component.template.dart'
    as simple_dialog_template;
import 'pages/simple_loading_component/simple_loading_component.template.dart'
    as simple_loading_template;
import 'pages/simple_select_component/simple_select_component.template.dart'
    as simple_select_template;
import 'pages/timeline_component/timeline_component.template.dart'
    as timeline_component_template;
import 'pages/toast_component/toast_component.template.dart' as toast_template;
import 'pages/rest_api_example/rest_api_example.template.dart'
    as rest_api_template;

class Routes {
  //********************* ACOORDEON *********************
  static final accordeon = RouteDefinition(
    routePath: RoutePaths.accordeon,
    component: accordeon_template.AccordeonComponentNgFactory,
//    useAsDefault: true
  );

  //********************* ACOORDEON *********************
  static final home = RouteDefinition(
      routePath: RoutePaths.home,
      component: home_template.ContentComponentNgFactory,
      useAsDefault: true);

  //********************* DATAPICKER *********************
  static final datapicker = RouteDefinition(
      routePath: RoutePaths.datapicker,
      component: datapicker_template.DataPickerComponentNgFactory);

  //********************* DataTable *********************
  static final datatable = RouteDefinition(
      routePath: RoutePaths.datatable,
      component: datatable_template.DataTableComponentNgFactory);

  //********************* Dropdown *********************
  static final dropdown = RouteDefinition(
      routePath: RoutePaths.dropdown,
      component: dropdown_template.DropdownDialogComponentNgFactory);

  //********************* Dynamic Tabs *********************
  static final dynamicTabs = RouteDefinition(
      routePath: RoutePaths.dynamicTabs,
      component: dynamic_tabs_template.DynamicTabsComponentNgFactory);

  //********************* Modal *********************
  static final modal = RouteDefinition(
      routePath: RoutePaths.modal,
      component: modal_template.ModalComponentNgFactory);

  //********************* Notification *********************
  static final notification = RouteDefinition(
      routePath: RoutePaths.notification,
      component: notification_template.NotificationComponentNgFactory);

  //********************* Recaptcha *********************
  static final recaptcha = RouteDefinition(
      routePath: RoutePaths.recaptcha,
      component: recaptcha_template.RecaptchaExampleNgFactory);

  //********************* RestApi *********************
  static final restApi = RouteDefinition(
      routePath: RoutePaths.restApi,
      component: rest_api_template.RestApiExampleComponentNgFactory);

  //********************* Select Dialog *********************
  static final selectDialog = RouteDefinition(
      routePath: RoutePaths.selectDialog,
      component: select_dialog_template.SelectDialogComponentNgFactory);

  //********************* Simple Card *********************
  static final simpleCard = RouteDefinition(
      routePath: RoutePaths.simpleCard,
      component: simple_card_template.SimpleCardComponentNgFactory);

  //********************* Simple Dialog *********************
  static final simpleDialog = RouteDefinition(
      routePath: RoutePaths.simpleDialog,
      component: simple_dialog_template.ExSimpleDialogComponentNgFactory);

  //********************* Simple Loading *********************
  static final simpleLoading = RouteDefinition(
      routePath: RoutePaths.simpleLoading,
      component: simple_loading_template.SimpleLoadingComponentNgFactory);

  //********************* Simple Select *********************
  static final simpleSelect = RouteDefinition(
      routePath: RoutePaths.simpleSelect,
      component: simple_select_template.SimpleSelectComponentNgFactory);

  //********************* Timeline *********************
  static final timeline = RouteDefinition(
      routePath: RoutePaths.timeline,
      component: timeline_component_template.TimelineExComponentNgFactory);

  //********************* Timeline *********************
  static final toast = RouteDefinition(
      routePath: RoutePaths.toast,
      component: toast_template.ToastExComponentNgFactory);

  //********************* Timeline *********************
  static final apiRest = RouteDefinition(
      routePath: RoutePaths.restApi,
      component: rest_api_template.RestApiExampleComponentNgFactory);

  static final all = <RouteDefinition>[
    home,
    accordeon,
    datapicker,
    datatable,
    dropdown,
    dynamicTabs,
    modal,
    notification,
    recaptcha,
    selectDialog,
    simpleCard,
    simpleDialog,
    simpleLoading,
    simpleSelect,
    timeline,
    toast,
    restApi
    /*RouteDefinition.redirect(
      path: '',
      redirectTo: RoutePaths.dashboard.toUrl(),
    ),*/
  ];
}
