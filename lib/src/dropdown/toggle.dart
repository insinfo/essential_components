import 'package:angular/angular.dart';
import 'dart:html';
import 'dropdown.dart';

/// Creates a component that will toggle the state of a dropdown-menu,
/// in other words when clicked will open or close the dropdown-menu
@Directive(selector: 'es-dropdown-toggle, .dropdown-toggle', exportAs: 'esdropdowntoggle')
class EsDropdownToggleDirective {
  EsDropdownDirective dropdown;

  /// Reference to this HTML element
  HtmlElement elementRef;

  EsDropdownToggleDirective(this.elementRef);

  @HostBinding('attr.aria-haspopup')
  bool ariaHaspopup = true;

  /// if `true` this component is disabled
  @Input()
  @HostBinding('class.disabled')
  bool disabled = false;

  /// if `true` the attr.aria-expanded should be `true`
  // @HostBinding('attr.aria-expanded')
  //bool get isOpen => dropdown?.isOpen ?? false;

  bool get isOpen => elementRef.getAttribute('aria-expanded') == 'true';

  /// toggles the state of the dropdown
  @HostListener('click', ['\$event'])
  void toggleDropdown(MouseEvent event) {
    event.preventDefault();
    event.stopPropagation();
    //fecha todas as instancias de dropDown aberta antes da abertura de uma nova
    document.querySelectorAll('es-dropdown.show')?.forEach((e) {
      if (elementRef.parent != e) {
        e.classes.remove('show');
        e.querySelector('es-dropdown-toggle')?.setAttribute('aria-expanded', 'false');
      }
    });

    if (!disabled) {
      if (!isOpen) {
        open();
      } else {
        close();
      }
    }
  }

  void open() {
    elementRef.setAttribute('aria-expanded', 'true');
    dropdown.open();
  }

  void close() {
    elementRef.setAttribute('aria-expanded', 'false');
    dropdown.close();
  }
}
