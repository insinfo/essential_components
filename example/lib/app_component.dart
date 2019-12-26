import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

//components
import 'package:essential_components/essential_components.dart';

//models
import 'src/models/user.dart';

import 'dart:html' as html;

@Component(
    selector: 'my-app',
    styleUrls: ['app_component.css'],
    templateUrl: 'app_component.html',
    directives: [
      formDirectives,
      coreDirectives,
      routerDirectives,
    ],
    exports: [])
class AppComponent {

  AppComponent();

}
