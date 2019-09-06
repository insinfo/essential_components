import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:essential_components/src/data_table/response_list.dart';
import 'package:http/browser_client.dart';
import 'uri_mu_proto.dart';
import 'map_serialization.dart';
import 'rest_response.dart';

class RestClientGeneric<T> {
  final Map<Type, Function> factories; // = <Type, Function>{};
  //ex: DiskCache<Agenda>(factories: {Agenda: (x) => Agenda.fromJson(x)});

  //cache duration
  Duration cacheValidDuration = Duration(minutes: 30);
  //disabilita o cache
  bool _disableAllCache = false;

  isQuotaExceeded() {
    try {
      window.localStorage["QUOTA_EXCEEDED_ERR"] = "QUOTA_EXCEEDED_ERR";
      return false;
    } catch (e) {
      print("isQuotaExceeded ${e}");
      /*if (e.code == 22) {
        //code: 1014,
        //name: 'NS_ERROR_DOM_QUOTA_REACHED',
        //message: 'Persistent storage maximum size reached',
        // Storage full, maybe notify user or do some clean-up
      }*/
      return true;
    }
  }

  fillLocalStorage({int sizeMB = 10}) {
    var i = 0;
    try {
      // Test up to 10 MB
      for (var i = 0; i <= (sizeMB * 1000); i += 250) {
        window.localStorage['test'] = List((i * 1024) + 1).join('a');
      }
    } catch (e) {
      print("fillLocalStorage ${e}");
      // localStorage.removeItem('test');
      print('size ${i != null ? i - 250 : 0}');
    }
  }

  get disableAllCache {
    return _disableAllCache;
  }

  set disableAllCache(bool disable) {
    _disableAllCache = disable;
  }

  //check if is update the cache
  bool isShouldRefresh(String key) {
    return (isInLocalStorage(key) == false ||
        _getLastFetchTime(key) == null ||
        _getLastFetchTime(key).isBefore(DateTime.now().subtract(cacheValidDuration)));
  }

  BrowserClient client;
  static UriMuProtoType protocol;
  static String host;
  static String basePath;

  static Map<String, String> headersDefault = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    "Authorization": "Bearer " + window.localStorage["YWNjZXNzX3Rva2Vu"].toString()
  };

  RestClientGeneric({this.factories}) {
    client = BrowserClient();
    UriMuProto.basePath = basePath;
    UriMuProto.host = host;
    UriMuProto.protoType = protocol;
  }

  Future<RestResponseGeneric<T>> getAll(String apiEndPoint,
      {bool forceRefresh = false, Map<String, String> headers, Map<String, String> queryParameters}) async {
    Uri url = UriMuProto.uri(apiEndPoint);

    try {
      if (queryParameters != null) {
        url = UriMuProto.uri(apiEndPoint, queryParameters);
      }

      if (headers == null) {
        headers = headersDefault;
      }

      //Obtem da REST API se o cache estivar vazio ou vencido
      if (isShouldRefresh(url.toString()) || forceRefresh || disableAllCache) {
        var resp = await client.get(url, headers: headers);
        var totalReH = resp.headers.containsKey('total-records') ? resp.headers['total-records'] : null;
        var totalRecords = totalReH != null ? int.tryParse(totalReH) : 0;

        if (resp.statusCode == 200) {
          //coloca no cache
          if (disableAllCache) {
            _setToLocalStorage(url.toString(), resp.body, header: totalRecords.toString());
          }

          var parsedJson = jsonDecode(resp.body);

          RList<T> list = RList<T>();
          parsedJson.forEach((item) {
            list.add(factories[T](item));
          });

          return RestResponseGeneric<T>(
              totalRecords: totalRecords,
              message: 'Sucesso',
              status: RestStatus.SUCCESS,
              dataTypedList: list,
              statusCode: resp.statusCode);
        }
      }
      Map result = _getAllFromCache(url.toString());
      RList list = result['data'];
      int totalRecords = int.tryParse(result['header']);
      list.totalRecords = totalRecords;

      return RestResponseGeneric<T>(
          totalRecords: totalRecords,
          message: 'Sucesso',
          status: RestStatus.SUCCESS,
          dataTypedList: list,
          statusCode: 200);
    } catch (e) {
      print(e);
      return RestResponseGeneric(message: 'Erro ${e}', status: RestStatus.DANGER, statusCode: 400);
    }
  }

  Future<RestResponseGeneric<T>> get(String apiEndPoint,
      {bool forceRefresh = false, Map<String, String> headers, Map<String, String> queryParameters}) async {
    Uri url = UriMuProto.uri(apiEndPoint);

    try {
      if (queryParameters != null) {
        url = UriMuProto.uri(apiEndPoint, queryParameters);
      }

      if (headers == null) {
        headers = headersDefault;
      }

      //Obtem da REST API se o cache estivar vazio ou vencido
      if (isShouldRefresh(url.toString()) || forceRefresh || disableAllCache) {
        var resp = await client.get(url, headers: headers);
        var totalReH = resp.headers.containsKey('total-records') ? resp.headers['total-records'] : null;
        var totalRecords = totalReH != null ? int.tryParse(totalReH) : 0;

        if (resp.statusCode == 200) {
          //coloca no cache
          if (disableAllCache) {
            _setToLocalStorage(url.toString(), resp.body);
          }

          var parsedJson = jsonDecode(resp.body);
          var result = factories[T](parsedJson); // Empenho.fromJson(json);

          return RestResponseGeneric<T>(
              totalRecords: totalRecords,
              message: 'Sucesso',
              status: RestStatus.SUCCESS,
              dataTyped: result,
              statusCode: resp.statusCode);
        }
      }
      return RestResponseGeneric<T>(
          totalRecords: 10,
          message: 'Sucesso',
          status: RestStatus.SUCCESS,
          dataTyped: _getFromCache(url.toString())['data'],
          statusCode: 200);
    } catch (e) {
      print(e);
      return RestResponseGeneric(message: 'Erro ${e}', status: RestStatus.DANGER, statusCode: 400);
    }
  }

  _putAllOnCache(String key, List<T> objects) {
    _setLastFetchTime(key, DateTime.now());
    if (objects != null) {
      List<Map> maps = List<Map>();
      for (T obj in objects) {
        var item = obj as MapSerialization;
        maps.add(item.toMap());
      }
      window.localStorage.addAll({key: jsonEncode(maps)});
    }
  }

  _putOnCache(String key, T object) {
    _setLastFetchTime(key, DateTime.now());
    if (object != null) {
      var item = object as MapSerialization;
      window.localStorage.addAll({key: jsonEncode(item.toMap())});
    }
  }

  _getAllFromCache(String key) {
    var obj = _getFromLocalStorage(key);
    if (obj != null) {
      List json = jsonDecode(obj['data']);
      RList<T> list = RList<T>();
      json.forEach((item) {
        list.add(factories[T](item));
      });
      //return list;
      return {"data": list, "header": obj['header']};
    } else {
      return null;
    }
  }

  _getFromCache(String key) {
    var obj = _getFromLocalStorage(key);
    if (obj != null) {
      Map map = jsonDecode(obj['data']);
      //return factories[T](map);
      return {"data": factories[T](map), "header": obj['header']};
    } else {
      return null;
    }
  }

  _getFromLocalStorage(String key) {
    if (window.localStorage.containsKey(key)) {
      var header;
      if (window.localStorage.containsKey("header" + key)) {
        header = window.localStorage["header" + key];
      }
      return {"data": window.localStorage[key], "header": header};
    } else {
      return null;
    }
  }

  bool isInLocalStorage(String key) {
    if (window.localStorage.containsKey(key)) {
      return true;
    } else {
      return false;
    }
  }

  _setToLocalStorage(String key, String value, {String header}) {
    _setLastFetchTime(key, DateTime.now());
    window.localStorage[key] = value;
    if (header != null) {
      window.localStorage["header" + key] = header;
    }
  }

  DateTime _getLastFetchTime(String key) {
    if (window.localStorage.containsKey("fetchTime" + key)) {
      return DateTime.parse(window.localStorage["fetchTime" + key]);
    } else {
      return null;
    }
  }

  _setLastFetchTime(String key, DateTime date) {
    window.localStorage["fetchTime" + key] = date.toString();
  }

  Future<RestResponseGeneric> put(String apiEndPoint,
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
      return RestResponseGeneric(
          message: 'Sucesso', status: RestStatus.SUCCESS, data: jsonDecode(resp.body), statusCode: resp.statusCode);
    }
    return RestResponseGeneric(message: '${resp.body}', status: RestStatus.DANGER, statusCode: resp.statusCode);
  }

  Future<RestResponseGeneric> post(String apiEndPoint,
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
      return RestResponseGeneric(
          message: 'Sucesso', status: RestStatus.SUCCESS, data: jsonDecode(resp.body), statusCode: resp.statusCode);
    }
    return RestResponseGeneric(message: '${resp.body}', status: RestStatus.DANGER, statusCode: resp.statusCode);
  }

  Future<RestResponseGeneric> deleteAll(String apiEndPoint,
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
      return RestResponseGeneric(
          message: 'Sucesso',
          status: RestStatus.SUCCESS,
          data: jsonDecode(request.responseText),
          statusCode: request.status);
    }
    return RestResponseGeneric(
        message: '${request.responseText}', status: RestStatus.DANGER, statusCode: request.status);
  }
}