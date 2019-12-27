import 'package:angular/angular.dart';

@Component(
  selector: 'menu-aside',
  styleUrls: ['menu_aside_component.css'],
  templateUrl: 'menu_aside_component.html',
  directives: [
    coreDirectives,
  ],
  exports: []
)
class MenuAsideComponent implements OnInit {

  MenuAsideComponent();

  @override
  void ngOnInit() async {
  }

}
