import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:http/browser_client.dart';
import 'uri_mu_proto.dart';
import 'rest_response.dart';

class RestClient {
  BrowserClient client;
  static UriMuProtoType protocol;
  static String host;
  static String basePath;

  static Map<String, String> headersDefault = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    "Authorization": "Bearer " + window.localStorage["YWNjZXNzX3Rva2Vu"].toString()
  };

  RestClient() {
    client = BrowserClient();
    UriMuProto.basePath = basePath;
    UriMuProto.host = host;
    UriMuProto.protoType = protocol;
  }

  Future<RestResponse> get(String apiEndPoint,
      {Map<String, String> headers, Map<String, String> queryParameters}) async {
    Uri url = UriMuProto.uri(apiEndPoint);

    if (queryParameters != null) {
      url = UriMuProto.uri(apiEndPoint, queryParameters);
    }

    if (headers == null) {
      headers = headersDefault;
    }

    var resp = await client.get(url, headers: headers);

    var totalReH = resp.headers.containsKey('total-records') ? resp.headers['total-records'] : null;
    var totalRecords = totalReH != null ? int.tryParse(totalReH) : 0;

    if (resp.statusCode == 200) {
      return RestResponse(
          totalRecords: totalRecords,
          message: 'Sucesso',
          status: RestStatus.SUCCESS,
          data: jsonDecode(resp.body),
          statusCode: resp.statusCode);
    }

    return RestResponse(message: '${resp.body}', status: RestStatus.DANGER, statusCode: resp.statusCode);
  }

  Future<RestResponse> put(String apiEndPoint,
      {Map<String, String> headers, body, Map<String, String> queryParameters, Encoding encoding}) async {
    Uri url = UriMuProto.uri(apiEndPoint);
    if (queryParameters != null) {
      url = UriMuProto.uri(apiEndPoint, queryParameters);
    }

    if (encoding == null) {
      encoding = Utf8Codec();
    }

    if (headers == null) {
      headers = headersDefault;
    }

    var resp = await client.put(url, body: jsonEncode(body), encoding: encoding, headers: headers);

    if (resp.statusCode == 200) {
      return RestResponse(
          message: 'Sucesso', status: RestStatus.SUCCESS, data: jsonDecode(resp.body), statusCode: resp.statusCode);
    }
    return RestResponse(message: '${resp.body}', status: RestStatus.DANGER, statusCode: resp.statusCode);
  }

  Future<RestResponse> post(String apiEndPoint,
      {Map<String, String> headers, body, Map<String, String> queryParameters, Encoding encoding}) async {
    Uri url = UriMuProto.uri(apiEndPoint);
    if (queryParameters != null) {
      url = UriMuProto.uri(apiEndPoint, queryParameters);
    }

    if (headers == null) {
      headers = headersDefault;
    }

    var resp = await client.post(url, body: jsonEncode(body), encoding: Utf8Codec(), headers: headers);

    if (resp.statusCode == 200) {
      return RestResponse(
          message: 'Sucesso', status: RestStatus.SUCCESS, data: jsonDecode(resp.body), statusCode: resp.statusCode);
    }
    return RestResponse(message: '${resp.body}', status: RestStatus.DANGER, statusCode: resp.statusCode);
  }

  Future<RestResponse> deleteAll(String apiEndPoint,
      {Map<String, String> headers,
      List<Map<String, dynamic>> body,
      Map<String, String> queryParameters,
      Encoding encoding}) async {
    Uri url = UriMuProto.uri(apiEndPoint);
    if (queryParameters != null) {
      url = UriMuProto.uri(apiEndPoint, queryParameters);
    }

    if (headers == null) {
      headers = headersDefault;
    }

    HttpRequest request = HttpRequest();
    request.open("delete", url.toString());
    request.setRequestHeader('Content-Type', 'application/json');
    request.send(json.encode(body));

    await request.onLoadEnd.first;
    //await request.onReadyStateChange.first;

    if (request.status == 200) {
      return RestResponse(
          message: 'Sucesso',
          status: RestStatus.SUCCESS,
          data: jsonDecode(request.responseText),
          statusCode: request.status);
    }
    return RestResponse(message: '${request.responseText}', status: RestStatus.DANGER, statusCode: request.status);
  }
}

