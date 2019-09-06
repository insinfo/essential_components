import 'dart:async';
import 'dart:convert';
import 'dart:html';


enum UriMuProtoType { http, https, notDefine }

class UriMuProto {
  static String host;
  static String basePath = "";
  static UriMuProtoType protoType;

  static Uri uri(String apiEndPoint, [Map<String, String> queryParameters]) {
    if (apiEndPoint == null) {
      throw Exception("api Endpoint cannot be null or empty");
    }

    apiEndPoint = basePath + apiEndPoint;
    var proLen = window.location.protocol.length;
    var protocol = "";
    if (protoType == UriMuProtoType.notDefine) {
      protocol = window.location.protocol.substring(0, proLen - 1);
    } else if (protoType == UriMuProtoType.https) {
      protocol = "https";
    } else if (protoType == UriMuProtoType.http) {
      protocol = "http";
    }

    if (host == null) {
      host = window.location.host.contains(':') ? 'local.riodasostras.rj.gov.br' : window.location.host;
    }

    return Uri(
        scheme: protocol,
        userInfo: "",
        host: host,
        pathSegments: apiEndPoint.split("/"),
        queryParameters: queryParameters);
  }
}
