import '../data_table/response_list.dart';

enum RestStatus { WARNING, SUCCESS, DANGER, INFO }

class RestResponseGeneric<T> extends RestResponse {
  T dataTyped;
  RList<T> dataTypedList;

  RestResponseGeneric({this.dataTyped, this.dataTypedList,String message, RestStatus status, dynamic data, int statusCode, int totalRecords})
      : super(message: message, status: status, data: data, statusCode: statusCode, totalRecords: totalRecords);
}

class RestResponse {
  String message;
  int statusCode;
  RestStatus status;
  dynamic data;
  int totalRecords;

  RestResponse({this.message, this.status, this.data, this.statusCode, this.totalRecords});

  String get statusClass {
    switch (status) {
      case RestStatus.SUCCESS:
        return 'success';
      case RestStatus.DANGER:
        return 'danger';
      case RestStatus.WARNING:
        return 'info';
      case RestStatus.INFO:
        return 'info';
    }
    return '';
  }
}
