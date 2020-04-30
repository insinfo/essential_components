import 'package:angular/angular.dart';

@Component(
    selector: 'menu-sidebar-options',
    styleUrls: ['menu_sidebar_options_component.css'],
    templateUrl: 'menu_sidebar_options_component.html',
    directives: [
      coreDirectives,
    ],
    exports: [])
class MenuSidebarOptionsComponent implements OnInit {
  MenuSidebarOptionsComponent();

  @override
  void ngOnInit() async {}
}
