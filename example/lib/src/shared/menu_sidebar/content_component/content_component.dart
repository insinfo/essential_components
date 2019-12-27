import 'package:angular/angular.dart';
import 'package:example/src/components/datatable_component/datatable_component.dart';

@Component(
  selector: 'content-component',
  styleUrls: ['content_component.css'],
  templateUrl: 'content_component.html',
  directives: [
    coreDirectives,
    DataTableComponent
  ],
  exports: []
)
class ContentComponent implements OnInit {

  ContentComponent();

  @override
  void ngOnInit() async {
  }

}
