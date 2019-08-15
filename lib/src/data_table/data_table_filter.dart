class DataTableFilter {
  int limit;
  int offset;
  String searchString;
  String orderBy;
  String orderDir;
  Map<String, String> stringParams = {};

  DataTableFilter({this.limit = 10, this.offset = 0, this.searchString});

  clear() {
    stringParams.clear();
  }

  Map<String, String> getParams() {
    if (this.limit != null && this.limit != -1) {
      stringParams["limit"] = this.limit.toString();
    }
    if (this.offset != null && this.offset != -1) {
      stringParams["offset"] = this.offset.toString();
    }
    if (this.searchString != null) {
      stringParams["search"] = this.searchString;
    }
    if (this.orderBy != null) {
      stringParams["orderBy"] = this.orderBy;
    }
    if (this.orderDir != null) {
      stringParams["orderDir"] = this.orderDir;
    }
    return stringParams;
  }

  addParam(String paramName, String paramValue) {
    if (paramName != null && paramName.isNotEmpty) {
      stringParams[paramName] = paramValue;
    }
  }

  addParams(Map<String, String> params) {
    stringParams.addAll(params);
  }
}
