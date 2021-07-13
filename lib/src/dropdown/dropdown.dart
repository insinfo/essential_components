import 'package:angular/angular.dart';
import 'dart:html' as html;
import 'dart:async';
import '../core/helper.dart';

import 'toggle.dart';
import 'menu.dart';

class AutoClose {
  static const ALWAYS = 'always',
      DISABLED = 'disabled',
      OUTSIDE_CLICK = 'outsideClick';
}

@Directive(selector: 'es-dropdown, .dropdown',exportAs: 'esdropdown')
class EsDropdownDirective implements OnDestroy, OnInit, AfterContentInit {
  html.HtmlElement elementRef;

  EsDropdownDirective(this.elementRef);

  /// if `true` `dropdown-menu` content will be appended to the body. This is useful when
  /// the dropdown button is inside a div with `overflow: hidden`, and the menu would
  /// otherwise be hidden
  @Input()
  bool dropdownAppendToBody = false;

  /// behaviour vary:
  ///  * `always` - (default) automatically closes the dropdown when any of its elements is clicked
  ///  * `outsideClick` - closes the dropdown automatically only when the user clicks any element
  ///  outside the dropdown
  ///  * `disabled` - disables the auto close. You can then control the open/close status of the
  ///  dropdown manually, by using `is-open`. Please notice that the dropdown will still close
  ///  if the toggle is clicked, the `esc` key is pressed or another dropdown is open
  @Input()
  String autoClose = AutoClose.ALWAYS;

  /// if `true` will enable navigation of dropdown list elements with the arrow keys
  @Input()
  bool keyboardNav = false;

  /// index of selected element
  num selectedOption;

  /// drop menu html
  html.HtmlElement menuEl;

  /// if `true` dropdown will be opened
  // bool _isOpen = false;

  /// if `true` dropdown will be opened
  // @HostBinding('class.show')
  //bool get isOpen => elementRef.classes.contains('show');

  StreamSubscription _closeDropdownStSub;
  StreamSubscription _keybindFilterStSub;

  /// if `true` the dropdown will be visible
  /*@Input()
  set isOpen(value) {
    // _isOpen = value ?? false;

    if (value == true) {
      open();
    } else {
      close();
    }

    /*if (isOpen) {
      _focusToggleElement();
    } else {
      selectedOption = null;
    }
    _isOpenChangeCtrl.add(_isOpen);*/
  }*/

  final _isOpenChangeCtrl = StreamController<bool>.broadcast();

  /// fired when `dropdown` toggles, `$event:boolean` equals dropdown `[isOpen]` state
  @Output()
  Stream<bool> get isOpenChange => _isOpenChangeCtrl.stream;

  @ContentChild(EsDropdownToggleDirective)
  EsDropdownToggleDirective dropdownToggle;

  @override
  void ngAfterContentInit() {
    dropdownToggle.dropdown = this;
  }

  /// sets the element that will be showed by the dropdown
  set dropDownMenu(EsDropdownMenuDirective dropdownMenu) {
    // init drop down menu
    menuEl = dropdownMenu.elementRef;
    if (dropdownAppendToBody) {
      html.window.document.documentElement.children.add(menuEl);
    }
  }

  /// toggles the visibility of the dropdown-menu
  /*bool toggle([bool open]) {
    //return isOpen = open ?? !isOpen;
  }*/

  void close() {
    elementRef.classes.remove('show');
      elementRef.querySelector('es-dropdown-toggle')?.setAttribute('aria-expanded', 'false');
    _focusToggleElement();
    _isOpenChangeCtrl.add(false);
  }

  void open() {
    elementRef.classes.add('show');
    elementRef.querySelector('es-dropdown-toggle')?.setAttribute('aria-expanded', 'true');
    selectedOption = null;
    _isOpenChangeCtrl.add(true);
  }

  /// focus the specified entry of dropdown in dependence of the [keyCode]
  void focusDropdownEntry(num keyCode) {
    // If append to body is used.
    var hostEl = menuEl ?? elementRef.querySelectorAll('ul')[0];
    if (hostEl == null) {
      // todo: throw exception?
      return;
    }
    var elems = hostEl.querySelectorAll('a');
    if (elems == null || elems.isEmpty) {
      // todo: throw exception?
      return;
    }
    switch (keyCode) {
      case (html.KeyCode.DOWN):
        if (selectedOption is! num) {
          selectedOption = 0;
          break;
        }
        if (identical(selectedOption, elems.length - 1)) {
          break;
        }
        selectedOption++;
        break;
      case (html.KeyCode.UP):
        if (selectedOption is! num) {
          return;
        }
        if (identical(selectedOption, 0)) {
          // todo: return?
          break;
        }
        selectedOption--;
        break;
    }
    elems[selectedOption].focus();
  }

  /// focus toggle element
  void _focusToggleElement() {
    dropdownToggle.elementRef.focus();
  }

  void _handleKeyDown(html.KeyboardEvent event) {
    if (event.which == html.KeyCode.ESC) {
      _focusToggleElement();
      //isOpen = false;
      close();
      return;
    }
    if (keyboardNav &&
        elementRef.classes.contains('show') &&
        (event.which == html.KeyCode.UP || event.which == html.KeyCode.DOWN)) {
      event.preventDefault();
      event.stopPropagation();
      focusDropdownEntry(event.which);
    }
  }

  void _handleClick(e) {
    if (elementRef.classes.contains('show')) {
      //isOpen = false;
      close();
    }
  }

  //init events
  @override
  void ngOnInit() {
    _closeDropdownStSub = html.window.onClick.listen(_handleClick);
    _keybindFilterStSub = html.window.onKeyDown.listen(_handleKeyDown);
  }

  /// removes the dropdown from the DOM
  @override
  void ngOnDestroy() {
    if (dropdownAppendToBody && truthy(menuEl)) {
      menuEl.remove();
    }
    _closeDropdownStSub?.cancel();
    _keybindFilterStSub?.cancel();
  }
}
