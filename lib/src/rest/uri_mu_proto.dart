import 'dart:async';
import 'dart:convert';
import 'dart:html';

enum UriMuProtoType { http, https, notDefine }

class UriMuProto {
  static String host;
  static int port;
  static String basePath = "";
  static UriMuProtoType protoType;
  static String defaultHost = "local.riodasostras.rj.gov.br";

  static Uri uri(String apiEndPoint, [Map<String, String> queryParameters, String basePth, String protcol]) {
    if (apiEndPoint == null) {
      throw Exception("UriMuProto: api Endpoint cannot be null or empty");
    }
    print(basePath);
    basePth = basePth != null ? basePth : basePath;
    apiEndPoint = basePth + apiEndPoint;
    var proLen = window.location.protocol.length;
    var protocol = "";
    if (protcol != null) {
      protocol = protcol;
    } else if (protoType == UriMuProtoType.notDefine || protoType == null) {
      protocol = window.location.protocol.substring(0, proLen - 1);
    } else if (protoType == UriMuProtoType.https) {
      protocol = "https";
    } else if (protoType == UriMuProtoType.http) {
      protocol = "http";
    }

    if (host == null) {
      host = window.location.host.contains(':') ? defaultHost : window.location.host;
    }

    return Uri(
        scheme: protocol,
        userInfo: "",
        host: host,
        port: port,
        pathSegments: apiEndPoint.split("/"),
        queryParameters: queryParameters);
  }
}
