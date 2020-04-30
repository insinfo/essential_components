// Copyright (c) 2016, lejard_h. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@JS()
library essential_recaptcha;

import 'dart:convert';
import 'dart:html';
import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular/core.dart';
import 'package:angular_forms/angular_forms.dart';

import 'package:http/http.dart' as http;

import 'package:js/js.dart';
// import 'package:js/js_util.dart';
import 'package:dart_browser_loader/dart_browser_loader.dart' show loadScript;

import 'package:dart_browser_loader/src/utils.dart' show waitLoad;

@JS('grecaptcha.render')
external num _render(
    HtmlElement container, EssentialRecaptchaParameters parameters);

@JS('grecaptcha.reset')
external void _reset(num id);

@JS('grecaptcha.getResponse')
external dynamic _getResponse(num id); // ignore: unused_element

@JS()
@anonymous
class EssentialRecaptchaParameters {
  external String get sitekey;

  external String get theme;

  external Function get callback;

  external String get type;

  external String get size;

  external String get tabindex;

  @JS('expired-callback')
  external Function get expiredCallback;

  external factory EssentialRecaptchaParameters(
      {String sitekey,
      String theme,
      Function callback,
      String type,
      Function expiredCallback,
      String size,
      String tabindex});
}

@Component(
  selector: 'essential-recaptcha',
  styleUrls: ['essential_recaptcha.css'],
  template: 'sdfsdfsdf sdfs dsf',
)
class EssentialRecaptcha extends ValueAccessor
    implements AfterViewInit, OnDestroy {
  final _onExpireCtrl = StreamController<Null>();
  final NgModel _ngModel;
  final HtmlElement _ref;
  num _id;
  bool _autoRender = true;
  bool _isRender = false;

  dynamic get value => _ngModel?.value;

  num get id => _id;

  bool get autoRender => _autoRender;

  @Output()
  Stream<Null> get expire => _onExpireCtrl.stream;

  String _siteverifyUrl = 'https://www.google.com/recaptcha/api/siteverify';
  @Input('siteverify-url')
  set siteverifyUrl(String url) {
    _siteverifyUrl = url;
  }

  @Input('siteverify')
  bool siteverify = false;

  @Input('tabindex')
  String tabindex = '0';

  @Input('size')
  String size = 'normal';

  @Input('key')
  String key;

  @Input('secret-key')
  String secretKey;

  @Input('theme')
  String theme = 'light';

  @Input('type')
  String type = 'image';

  @Input('auto-render')
  set autoRender(val) {
    _autoRender = _parseBool(val);
  }

  EssentialRecaptcha(this._ref, @Optional() this._ngModel) {
    _ngModel?.valueAccessor = this;
  }

  void _callbackResponse(response) {
    writeValue(response);
    _verifiedStreamController.add(response);
    //print('EssentialRecaptcha@_callbackResponse $response');
    String _token = response;
    if (_token.contains('verify')) {
      _token = _token.substring(7);
    }
    // print(_token);
    if (siteverify) {
      verifyToken(_token);
    }
  }

  void _expireCallback() {
    writeValue(null);
    _onExpireCtrl.add(null);
  }

  @override
  void ngAfterViewInit() {
    if (!_isRender) {
      _isRender = true;
      if (_autoRender != false) {
        render();
      }
    }
  }

  final _verifiedStreamController = StreamController<String>();

  @Output('verify')
  Stream<String> get onVerified => _verifiedStreamController.stream;

  final _verifiedSuccessStreamController = StreamController<bool>();
  @Output()
  Stream<bool> get onVerifiedSuccessfully =>
      _verifiedSuccessStreamController.stream;

  final _verifiedErrorStreamController = StreamController<String>();
  @Output()
  Stream<String> get onVerifiedError => _verifiedErrorStreamController.stream;

  void verifyToken(String token) async {
    try {
      // ignore: omit_local_variable_types
      http.Response response = await http.post(_siteverifyUrl, body: {
        'secret': secretKey,
        'response': token,
      });

      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        dynamic json = jsonDecode(response.body);
        if (json['success']) {
          _verifiedSuccessStreamController.add(true);
        } else {
          _verifiedSuccessStreamController.add(false);
          _verifiedErrorStreamController.add(json['error-codes'].toString());
        }
      }
    } catch (e) {
      print('EssentialRecaptcha@verifyToken $e');
    }
    // hide captcha
    // controller.hide();
  }

  Future<num> render() async {
    var config = EssentialRecaptchaParameters(
        sitekey: key,
        theme: theme,
        callback: allowInterop(_callbackResponse),
        expiredCallback: allowInterop(_expireCallback),
        type: type,
        size: size,
        tabindex: tabindex);

    _id = await _safeApiCall<num>(() => _render(_ref, config));
    return _id;
  }

  void reset() {
    _safeApiCall(() => _reset(id));
  }

  @override
  void writeValue(dynamic v) {
    _ngModel?.viewToModelUpdate(v);
  }

  // this abstract method does nothing
  // it is implemented only to avoid error messages
  // from analyzer plugin
  @override
  void onDisabledChanged(bool isDisabled) {}

  @override
  void ngOnDestroy() {
    _onExpireCtrl.close();
  }
}

bool _parseBool(dynamic value) {
  if (value is bool) {
    return value;
  }
  switch (value) {
    case '':
      return true;
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      return false;
  }
}

abstract class ValueAccessor<T> implements ControlValueAccessor<T> {
  ChangeFunction<T> onModelChange = (_, {String rawValue}) {};
  TouchFunction onModelTouched = () {};

  @override
  void registerOnChange(ChangeFunction<T> fn) {
    onModelChange = fn;
  }

  @override
  void registerOnTouched(TouchFunction fn) {
    onModelTouched = fn;
  }

  void touchHandler() {
    onModelTouched();
  }
}

// ignore: prefer_generic_function_type_aliases
typedef FutureOr<T> _VoidCallback<T>();

Element _script;

FutureOr<T> _safeApiCall<T>(_VoidCallback<T> call) async {
  await loadScript('https://www.google.com/recaptcha/api.js?render=explicit',
      isAsync: true, isDefer: true, id: 'grecaptcha-jssdk');

  if (_script == null) {
    final scripts = document.querySelectorAll('script');
    // ignore: prefer_iterable_wheretype
    _script = scripts.where((s) => s is ScriptElement).firstWhere(
        //isaque corrigi o bug era a URL errada
        (s) => (s as ScriptElement)
            .src
            .startsWith('https://www.gstatic.com/recaptcha/'),
        orElse: () => null);
    if (_script == null) return null;
  }
  await waitLoad(_script);
  return await call();
}
