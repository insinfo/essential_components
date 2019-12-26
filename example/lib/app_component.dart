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
    EssentialToastComponent,
    routerDirectives,
    EssentialDataTableComponent,
    MaxlengthDirective,
    esDynamicTabsDirectives,
    EssentialSimpleSelectComponent,
    EsSimpleSelectOptionComponent,
    EsDatePickerPopupComponent,
    EsDatePickerComponent
  ],
)
class AppComponent implements OnInit {
  RList<User> users;
  User selected;
  SimpleLoadingComponent loading;
  @ViewChild('dataTable')
  EssentialDataTableComponent dataTable;
  //rest client for get JSON data from backend
  RestClientGeneric rest;

  @ViewChild('card')
  html.DivElement card;

  AppComponent() {
    loading = SimpleLoadingComponent();
    //init rest client for get JSON data from backend
    rest = RestClientGeneric<User>(factories: {User: (x) => User.fromJson(x)});
    RestClient.basePath = '/'; //example /api/v1/
  }

  @override
  void ngOnInit() async {
    //display loading animation on container div card
    loading.show(target: card);
    //loading data from server side REST API
    var resp = await rest.getAll('/user', queryParameters: DataTableFilter().getParams());
    loading.hide();
    if (resp.status == RestStatus.SUCCESS) {
      users = resp.dataTypedList;
    } else {
      print(resp.message);
      print(resp.exception);
    }
  }

  //on click in row of dataTable
  void onRowClick(User selected) {
    this.selected = selected;
  }

  Future<void> onRequestData(DataTableFilter dataTableFilter) async {
    var resp = await rest.getAll('/user', queryParameters: dataTableFilter.getParams());
    if (resp.status == RestStatus.SUCCESS) {
      this.users = resp.dataTypedList;
    } else {
      dataTable.setErrorOccurred();
    }
  }

  Future<void> reloadTableOnChange(e) async {
    dataTable.reload();
  }
}
