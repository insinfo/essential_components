import '../data_table/response_list.dart';

//Unauthorized
enum RestStatus { WARNING, SUCCESS, DANGER, INFO, UNAUTHORIZED, NOCONTENT, CONFLICT }
enum RestClientMethod { GET, HEAD, POST, PUT, DELETE, CONNECT, OPTIONS, TRACE, PATCH }

class RestResponseGeneric<T> extends RestResponse {
  T dataTyped;

  RList<T> dataTypedList;

  //alias para dataTyped
  T get resultT {
    return dataTyped;
  }

  //alias para dataTypedList
  RList<T> get resultListT {
    return dataTypedList;
  }

  // asExternalTypedData foi substituído por asTypedList
  RestResponseGeneric(
      {this.dataTyped,
      this.dataTypedList,
      String message,
      String exception,
      RestStatus status,
      dynamic data,
      dynamic rawData,
      int statusCode,
      int totalRecords,
      Map<String, String> headers})
      : super(
            message: message,
            exception: exception,
            status: status,
            data: data,
            rawData: rawData,
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
  dynamic rawData;
  int totalRecords;
  Map<String, String> headers;

  RestResponse(
      {this.message,
      this.exception,
      this.status,
      this.data,
      this.rawData,
      this.statusCode,
      this.totalRecords,
      this.headers});

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
      case RestStatus.NOCONTENT:
        return 'info';
      case RestStatus.CONFLICT:
        return 'info';
    }
    return '';
  }
}
