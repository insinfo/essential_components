import 'package:angular_router/angular_router.dart';

class RoutePaths {
  static final home = RoutePath(path: '');
  static final accordeon = RoutePath(path: 'accordeon');
  static final datapicker = RoutePath(path: 'datapicker');
  static final datatable = RoutePath(path: 'datatable');
  static final dropdown = RoutePath(path: 'dropdown');
  static final dynamicTabs = RoutePath(path: 'dynamicTabs');
  static final modal = RoutePath(path: 'modal');
  static final notification = RoutePath(path: 'notification');
  static final recaptcha = RoutePath(path: 'recaptcha');
  static final selectDialog = RoutePath(path: 'selectDialog');
  static final simpleCard = RoutePath(path: 'simpleCard');
  static final simpleDialog = RoutePath(path: 'simpleDialog');
  static final simpleLoading = RoutePath(path: 'simpleLoading');
  static final simpleSelect = RoutePath(path: 'simpleSelect');
  static final timeline = RoutePath(path: 'timeline');
  static final toast = RoutePath(path: 'toast');
  static final restApi = RoutePath(path: 'restApi');
}

int getId(Map<String, String> parameters) {
  final id = parameters['id'];
  return id == null ? null : int.tryParse(id);
}

String getParam(Map<String, String> parameters, String paramName) {
  return parameters[paramName];
}
