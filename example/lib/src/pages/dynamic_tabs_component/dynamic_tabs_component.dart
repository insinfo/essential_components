import 'package:angular/angular.dart';
import 'package:essential_components/essential_components.dart';
import 'package:example/src/services/person_service.dart';
import 'package:example/src/utils/highlighting_js.dart';

@Component(
  selector: 'dynamic-tabs-component',
  styleUrls: ['dynamic_tabs_component.css'],
  templateUrl: 'dynamic_tabs_component.html',
  directives: [
    coreDirectives,
    esDynamicTabsDirectives,
    EsRadioButtonDirective,
    bsDropdownDirectives
  ],
  exports: [],
  providers: []
)
class DynamicTabsComponent implements OnInit {

  String codeHtml = '''
<es-tabsx #tabs1>
    <es-tabx header="Example">
        <div class="row">
            <div class="col-12">
            </div>
        </div>
    </es-tabx>
    <es-tabx header="View">
        <div class="row">
            <div class="col-12">
            </div>
        </div>
    </es-tabx>
    <es-tabx header="Component">
        <div class="row">
            <div class="col-12">
            </div>
        </div>
    </es-tabx>
</es-tabsx>
''';


  DynamicTabsComponent();

  @override
  void ngOnInit() {
    codeHtml = highlightingHtml(codeHtml);
  }

}
