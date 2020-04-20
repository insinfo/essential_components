import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:example/src/route_path.dart';
import 'package:example/src/routes.dart';

@Component(
  selector: 'menu-sidebar-options',
  styleUrls: ['menu_sidebar_options_component.css'],
  templateUrl: 'menu_sidebar_options_component.html',
  directives: [
    coreDirectives,
    routerDirectives
  ],
  exports: [RoutePaths]
)
class MenuSidebarOptionsComponent implements OnInit {


  MenuSidebarOptionsComponent();

  @override
  void ngOnInit() async {
  }

}
