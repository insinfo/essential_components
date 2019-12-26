import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

//components

import 'package:example/src/components/menu_sidebar/menu_aside_component/menu_aside_component.dart';
import 'package:example/src/components/menu_sidebar/menu_sidebar_options_component/menu_sidebar_options_component.dart';

@Component(
    selector: 'my-app',
    styleUrls: ['app_component.css'],
    templateUrl: 'app_component.html',
    directives: [
      formDirectives,
      coreDirectives,
      routerDirectives,
      MenuAsideComponent,
      MenuSidebarOptionsComponent
    ],
    exports: [])
class AppComponent {

  AppComponent();

}
