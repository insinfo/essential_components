import '../data_table/response_list.dart';

//Unauthorized
enum RestStatus { WARNING, SUCCESS, DANGER, INFO, UNAUTHORIZED }

class RestResponseGeneric<T> extends RestResponse {
  T dataTyped;
  RList<T> dataTypedList;

  RestResponseGeneric(
      {this.dataTyped,
      this.dataTypedList,
      String message,
      RestStatus status,
      dynamic data,
      int statusCode,
      int totalRecords,
      Map<String, String> headers})
      : super(
            message: message,
            status: status,
            data: data,
            statusCode: statusCode,
            totalRecords: totalRecords,
            headers: headers);
}

class RestResponse {
  String message;
  String exception;
  int statusCode;
  RestStatus status;
  dynamic data;
  int totalRecords;
  Map<String, String> headers;

  RestResponse(
      {this.message, this.exception, this.status, this.data, this.statusCode, this.totalRecords, this.headers});

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
      case RestStatus.UNAUTHORIZED:
        return 'info';
    }
    return '';
  }
}
