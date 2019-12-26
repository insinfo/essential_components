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
    exports: [User])
class AppComponent implements OnInit {
  RList<User> users;
  User selected;
  SimpleLoadingComponent loading;
  @ViewChild('dataTable')
  EssentialDataTableComponent dataTable;
  //rest client for get JSON data from backend
  RestClientGeneric rest;

  static EssentialNotificationService notificationService = EssentialNotificationService();

  @ViewChild('card')
  html.DivElement card;

  AppComponent() {
    loading = SimpleLoadingComponent();
    //init rest client for get JSON data from backend
    RestClientGeneric.basePath = ''; //example /api/v1/
    RestClientGeneric.host = "127.0.0.1";
    RestClientGeneric.protocol = UriMuProtoType.http;
    RestClientGeneric.port = 8080;
    rest = RestClientGeneric<User>(factories: {User: (x) => User.fromJson(x)});
  }

  @override
  void ngOnInit() async {
    //display loading animation on container div card
    loading.show(target: card);
    //loading data from server side REST API
    var resp = await rest.getAll('/mockdata.json', queryParameters: DataTableFilter().getParams());
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

  bool hasSeletedItems() {
    return dataTable.selectedItems != null && dataTable.selectedItems.isNotEmpty;
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

  onDelete() {
    SimpleDialogComponent.showConfirm("Are you sure you want to remove this item? The operation cannot be undone.",
        confirmAction: () {
      if (hasSeletedItems()) {
        AppComponent.notificationService.add('success', 'App', "Success");
      } else {
        AppComponent.notificationService.add('danger', 'App', "Select items");
      }
    });
  }
}
