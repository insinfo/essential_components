import 'package:angular/angular.dart';

import 'icon.dart';

/// A component that composites Font Awesome icons on top of each other.
@Component(
    selector: 'fa-stack',
    styleUrls: ['css/all.min.css'],
    template: '<span [ngClass]="classes"><ng-content></ng-content></span>',
    directives: [coreDirectives])
class FaStack implements OnInit {
  /// The stacking size: 1x, 2x, or 4x.
  @Input()
  String size;

  static const SIZE_CLASSES = {
    '1x': 'fa-1x',
    '2x': 'fa-2x',
    '4x': 'fa-4x',
  };

  Map<String, bool> classes = {};

  void ngOnInit() {
    this.classes['fa-stack'] = true;
    if (this.size != null) {
      this.classes['fa-$size'] = true;
    }
  }
}
