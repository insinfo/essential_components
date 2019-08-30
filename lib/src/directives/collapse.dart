import 'dart:html';
import 'package:angular/angular.dart';
import 'dart:async';

/// Collapse component allows you to toggle content on your pages with a bit of JavaScript and some
/// classes. Flexible component that utilizes a handful of classes (from the **required transitions
/// component**(*not yet implemented*)) for easy toggle behavior.
///
/// Base specifications: [bootstrap 3](http://getbootstrap.com/javascript/#collapse)
/// or [bootstrap 4](http://v4-alpha.getbootstrap.com/components/collapse/)
///
/// [demo](http://dart-league.github.io/ng_bootstrap/#collapse)
/// 
@Directive(selector: '[esCollapse]')
class EssentialCollapseDirective {
  /// Constructs an collapsible component
  EssentialCollapseDirective(this.elementRef) {
    _element = elementRef;

    esCollapseChange.listen((esCollapse) {
      if (esCollapse) {
        _hide();
      } else {
        _show();
      }
    });
  }

  /// Contains the element reference of this component
  HtmlElement elementRef;

  Element _element;

  /// provides the height style of the component in pixels
  @HostBinding('style.height')
  String height = '';

  /// if `true` the component is shown
  @HostBinding('class.show')
  @HostBinding('attr.aria-expanded')
  bool expanded = false;

  @HostBinding('class.collapse')
  @HostBinding('attr.aria-hidden')
  bool collapsed = true;

  bool _collapsing = false;

  /// provides the animation state
  @HostBinding('class.collapsing')
  bool get collapsing => _collapsing;

  set collapsing(bool collapsing) {
    _collapsing = collapsing;
    _collapsingChangeController.add(collapsing);
  }

  bool _esCollapse = false;

  /// sets and fires the collapsed state of the component
  @Input() set esCollapse(bool value) {
    _esCollapse = value ?? false;
    _esCollapseChangeController.add(_esCollapse);
  }

  String get _scrollHeight => _element.scrollHeight.toString() + 'px';

  final _esCollapseChangeController = StreamController<bool>.broadcast();

  /// Emits the Collapse state of the component
  @Output() Stream<bool> get esCollapseChange =>
      _esCollapseChangeController.stream;

  final _collapsingChangeController = StreamController<bool>.broadcast();

  Timer showTimer;

  Timer hideTimer;

  /// Emits the collapsing state of the component
  @Output() Stream<bool> get collapsingChange =>
      _collapsingChangeController.stream;

  _hide() {
    expanded = false;
    height = _scrollHeight;
    collapsing = true;
    showTimer?.cancel();
     Timer(const Duration(milliseconds: 5), () {
      height = '0';
      hideTimer = Timer(const Duration(milliseconds: 40), () {
        collapsing = false;
        collapsed = true;
        height = '';
      });
    });
  }

  _show() {
    collapsed = false;
    height = '0';
    collapsing = true;
    hideTimer?.cancel();
    Future(() {
      height = _scrollHeight;
      showTimer = Timer(const Duration(milliseconds: 40), () {
        collapsing = false;
        expanded = true;
        height = '';
      });
    });
  }
}