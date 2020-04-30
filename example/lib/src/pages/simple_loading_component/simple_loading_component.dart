import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';

@Component(
    selector: 'simple-loading-component',
    styleUrls: ['simple_loading_component.css'],
    templateUrl: 'simple_loading_component.html',
    directives: [
      coreDirectives,
      esDynamicTabsDirectives,
    ],
    exports: [],
    providers: [])
class SimpleLoadingComponent {}
