import 'package:angular/angular.dart';

/// A component that renders a solid icon from Font Awesome.
@Component(
    selector: 'fa',
    styleUrls: ['css/all.min.css'],
    template: '''<i [ngClass]='classes'></i>''',
    directives: [coreDirectives])
class FaIcon implements OnInit {
  /// Name of icon to dislpay, e.g. "flag" or "camera-retro". (Required)

  String _name;

  @Input()
  set name(String na) {
    classes.remove('fa-$_name');
    _name = na;
    classes['fa-$_name'] = true;
  }

  String get name {
    return _name;
  }

  /// The group of icon: regular, solid, light, or brand. (Default: solid)
  @Input()
  String group = 'solid';

  static const GROUP_CLASSES = {
    'brand': 'fab',
    'regular': 'far',
    'solid': 'fas',
    'light': 'fal',
  };

  /// Size of icon: xs, sm, lg, 2x, 3x, 5x, 7x, or 10x.
  @Input()
  String size;

  /// Render with fixed width.
  @Input()
  bool fw = false;

  /// Rotate an icon: 90, 180, or 270.
  @Input()
  String rotate;

  static const ROTATE_CLASSES = {
    '90': 'fa-rotate-90',
    '180': 'fa-rotate-180',
    '270': 'fa-rotate-270',
  };

  /// Flip an icon: horizontal, vertical, or both.
  @Input()
  String flip;

  static const FLIP_CLASSES = {
    'horizontal': 'fa-flip-horizontal',
    'vertical': 'fa-flip-vertical',
    'both': 'fa-flip-both',
  };

  /// Animate a rotating icon smoothly.
  @Input()
  bool spin = false;

  /// Animate a rotating icon in 8 discrete steps.
  @Input()
  bool pulse = false;

  /// Float "left" or "right".
  @Input()
  String pull;

  static const PULL_CLASSES = {
    'left': 'fa-pull-left',
    'right': 'fa-pull-right',
  };

  /// Render with border around the icon.
  @Input()
  bool border = false;

  /// Invert color scheme. Only meaningful when the component appears inside
  /// an <fa-stack>.
  @Input()
  bool inverse = false;

  /// The stacking size, either "1x" or "2x".
  ///
  /// Only meaningful when the component appears inside an <fa-stack>.
  @Input()
  String stack;

  static const STACK_CLASSES = {
    '1x': 'fa-stack-1x',
    '2x': 'fa-stack-2x',
  };

  Map<String, bool> classes = {};

  @override
  void ngOnInit() {
    render();
  }

  void render() {
    var group = FaIcon.GROUP_CLASSES[this.group];
    classes['fa-$name'] = true;
    classes[group] = true;
    if (size != null) {
      classes['fa-$size'] = true;
    }
    classes['fa-fw'] = fw;
    if (rotate != null) {
      var rotate = FaIcon.ROTATE_CLASSES[this.rotate];
      classes[rotate] = true;
    }
    if (flip != null) {
      var flip = FaIcon.FLIP_CLASSES[this.flip];
      classes[flip] = true;
    }
    classes['fa-spin'] = spin;
    classes['fa-pulse'] = pulse;
    if (pull != null) {
      var pull = FaIcon.PULL_CLASSES[this.pull];
      classes[pull] = true;
    }
    classes['fa-border'] = border;
    classes['fa-inverse'] = inverse;
    if (stack != null) {
      var stack = FaIcon.STACK_CLASSES[this.stack];
      classes[stack] = true;
    }
  }
}
