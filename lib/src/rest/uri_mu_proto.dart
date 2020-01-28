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

  static Uri uri(String apiEndPoint,
      [Map<String, String> queryParameters, String basePath, String protocol, String hosting, int hostPort]) {
    if (apiEndPoint == null) {
      throw Exception("UriMuProto: api Endpoint cannot be null or empty");
    }

    basePath = basePath != null ? basePath : UriMuProto.basePath;

    apiEndPoint = basePath + apiEndPoint;

    var proLen = window.location.protocol.length;

    var prot = "";
    if (protocol != null) {
      prot = protocol;
    } else if (protoType == UriMuProtoType.notDefine || protoType == null) {
      prot = window.location.protocol.substring(0, proLen - 1);
    } else if (protoType == UriMuProtoType.https) {
      prot = "https";
    } else if (protoType == UriMuProtoType.http) {
      prot = "http";
    }
    var h = UriMuProto.host;

    if (h == null) {
      h = window.location.host.contains(':') ? defaultHost : window.location.host;
    }

    if (hosting != null) {
      h = hosting;
    }

    var prt = UriMuProto.port;
    if (hostPort != null) {
      prt = hostPort;
    }
    

    return Uri(
        scheme: prot,
        userInfo: "",
        host: h,
        port: prt,
        pathSegments: apiEndPoint.split("/"),
        queryParameters: queryParameters);
  }
}
