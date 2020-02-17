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
class EssentialImageComponent implements AfterContentInit {
  String _url = "";
  bool loading = true;
  bool isError = false;

  @ViewChild('container')
  html.HtmlElement container;

  @Input()
  bool showUrl = false;

  @Input()
  String containerClass = "";

  @Input()
  String imgClass = "img-fluid";

  @Input()
  String containerStyle = "";

  @Input()
  String imgStyle = "";

  @Input()
  String title = "";

  @Input()
  String alt = "";

  String get url {
    return this._url;
  }

  @Input()
  set url(String u) {
    this.isError = false;
    this.loading = true;
    this._url = u;
  }

  final _onClickStreamController = StreamController<String>();

  @Output()
  Stream<String> get click => _onClickStreamController.stream;

  onClickHandle(e) {
    _onClickStreamController.add(url);
  }

  @HostListener('click')
  onClick() {
    _onClickStreamController.add(url);
  }

  onLoad() {
    //print("EssentialImageComponent@onLoad $loading url: $url");
    this.loading = false;
  }

  onError() {
    //print("EssentialImageComponent@onError $loading url: $url");
    this.loading = false;
  }

  @override
  ngAfterContentInit() {}
}
