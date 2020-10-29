import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';
import 'dart:html' as html;

@Component(
    selector: 'es-image',
    templateUrl: 'image.html',
    styleUrls: ['image.css'],
    directives: [coreDirectives, formDirectives, routerDirectives])
class EssentialImageComponent {
  String _url = '';
  bool loading = true;
  bool isError = false;

  @ViewChild('container')
  html.HtmlElement container;

  @Input()
  bool showUrl = false;

  @Input()
  String containerClass = '';

  @Input()
  String imgClass = 'img-fluid';

  @Input()
  String containerStyle = '';

  @Input()
  String imgStyle = '';

  @Input()
  String title = '';

  @Input()
  String alt = '';

  String get url {
    return _url;
  }

  @Input()
  set url(String u) {
    isError = false;
    loading = true;
    _url = u;
  }

  final _onClickStreamController = StreamController<String>();

  @Output()
  Stream<String> get click => _onClickStreamController.stream;

  void onClickHandle(e) {
    _onClickStreamController.add(url);
  }

  @HostListener('click')
  void onClick() {
    _onClickStreamController.add(url);
  }

  void onLoad() {
    loading = false;
  }

  void onError() {
    loading = false;
  }
}
