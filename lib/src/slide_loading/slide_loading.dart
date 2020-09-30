import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';

@Component(
    selector: 'es-slide-loading',
    templateUrl: 'slide_loading.html',
    styleUrls: ['slide_loading.css'],
    directives: [coreDirectives, formDirectives, routerDirectives])
class EssentialSlideLoadingComponent {
  @Input('show')
  bool isLoading = false;

  /*final _endRequest = StreamController<bool>();
  @Output()
  Stream<bool> get end => _endRequest.stream;*/

  void showLoading() {
    isLoading = true;
  }

  void hideLoading() {
    isLoading = false;
  }
}
