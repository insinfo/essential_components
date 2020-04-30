import 'dart:html';

abstract class AppConfig {
  static Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization':
        'Bearer ' + window.localStorage['YWNjZXNzX3Rva2Vu'].toString()
  };

  //static UriMuProtoType PROTOCOL_REST_API = UriMuProtoType.http;
  static String PROTOTOCOL_HOST_REST_API = 'http://';
  static String HOST_REST_API = 'local.riodasostras.rj.gov.br';
  static String BASE_PATH_REST_API = '/siscec2server/api';
  static String CONTRATO_API_ENDPOINT = '/contratos';
}
