import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';

import 'package:angular_forms/angular_forms.dart';

import '../interface_has_ui_display_name.dart';

import '../core/replacement_accents.dart';

import '../core/style_type.dart';
import 'simple_select_option.dart';

@Component(
    selector: 'es-simple-select',
    //changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'simple_select.html',
    styleUrls: [
      'simple_select.css',
    ],
    directives: [
      formDirectives,
      coreDirectives
    ],
    exports: [
      StyleType
    ])
class EssentialSimpleSelectComponent
    implements
        ControlValueAccessor,
        AfterViewInit,
        AfterContentInit,
        OnDestroy,
        AfterChanges {
  @ViewChild('inputEl')
  ButtonElement inputEl;

  @ViewChild('dropdownMenu')
  DivElement dropdownMenu;

  @ContentChildren(EsSimpleSelectOptionComponent)
  List<EsSimpleSelectOptionComponent> childrenSimpleSelectOptions;

  @ViewChild('inputsearch')
  InputElement inputsearch;

  final NgControl ngControl;

  bool _required = false;
  bool get required => _required;
  bool focused = false;

  @Input()
  bool showsearch = false;

  bool _disabled = false;
  bool get disabled => _disabled;

  @Input()
  set disabled(bool disabled) {
    _disabled = disabled;
  }

  @Input()
  String label;

  @Input()
  StyleType color;

  String _styleClass = 'btn dropdown-toggle';

  @Input()
  set styleClass(String className) {
    _styleClass = className;
  }

  String get styleClass {
    return _styleClass;
  }

  Map<String, dynamic> get bgColor {
    var bg = '';
    switch (color) {
      case StyleType.SUCCESS:
        bg = 'bg-success';
        break;
      case StyleType.PRIMARY:
        bg = 'bg-primary';
        break;
      case StyleType.WARNING:
        bg = 'bg-warning';
        break;
      case StyleType.DANGER:
        bg = 'bg-danger';
        break;
      case StyleType.DEFAULT:
      default:
        bg = 'bg-default';
    }
    return {bg: color != null};
  }

  @Input()
  set required(bool required) {
    var prev = _required;
    _required = required;
    if (prev != _required && ngControl != null) {
      // Required value changed and we are using a control. Force revalidation
      // on the control.
      ngControl.control.updateValueAndValidity();
    }
  }

  final _changeController = StreamController<dynamic>.broadcast(sync: true);

  /// Publishes events when a change event is fired. (On enter, or on blur.)
  @Output('change')
  Stream<dynamic> get onChange => _changeController.stream;

  final _blurController = StreamController<FocusEvent>.broadcast(sync: true);

  /// Publishes events when a blur event is fired.
  @Output('blur')
  Stream<FocusEvent> get onBlur => _blurController.stream;

  /// Type of input.
  ///
  /// It can be one of the following:
  /// {"select", "button"}
  /// displaytype="button"
  String _displaytype = 'select';

  @Input('displaytype')
  set displaytype(String value) {
    _displaytype = value;
  }

  bool _disabledSelect = false;
  @Input('disabledSelect')
  set disabledSelect (bool value) {
    _disabledSelect = value;
    print('EssentialSimpleSelectComponent ${disabledSelect}');
  }

  bool get disabledSelect {
    return _disabledSelect;
  }
  


  String get displaytype {
    return _displaytype;
  }

  int get inputTabIndex => disabled ? -1 : 0;

  String _inputText = 'select';
  String _buttonText = 'select';

  @Input('buttonText')
  set buttonText(String btnText) {
    _buttonText = btnText;
    inputText = _buttonText;
  }

  set inputText(String value) {
    _inputText = value;
  }

  String get inputText {
    return _inputText;
  }

  //contrutor
  EssentialSimpleSelectComponent(@Self() @Optional() this.ngControl, ChangeDetectorRef changeDetector) {
    
    color = StyleType.DEFAULT;
    // _changeDetector = changeDetector;
    // Replace the provider from above with this.
    if (ngControl != null) {
      // Setting the value accessor directly (instead of using
      // the providers) to avoid running into a circular import.
      ngControl.valueAccessor = this;

      if (ngControl?.control != null) {
        //este ouvinte de evento é chamado todo vez que o modelo vinculado pelo ngModel muda
        ssControlValueChanges = ngControl.control.valueChanges.listen((value) {
          if (value != null) {
            itemSelected = value;
            inputText = getDisplayName(value);
          } else {
            itemSelected = value;
            setDefaultOptionText();
          }
          //_changeDetector.markForCheck();
        });
      }
    }
    //evento global de click
    streamSubscriptionBodyOnCLick =
        window.document.querySelector('body').onClick.listen(handleBodyOnCLick);
  }

  //evento global de click
  StreamSubscription streamSubscriptionBodyOnCLick;
  void handleBodyOnCLick(e) {
    /*if (isDropdownOpen) {
      toogleDrop();
    }*/
    closeAllSelect();
    isDropdownOpen = false;
  }

  void inputFocusAction(event) {
    focused = true;
  }

  void inputBlurAction(event, valid, validationMessage) {
    focused = false;
    _blurController.add(event);
  }

  ///este metodo é chamado quando clica em uma opção do select
  void dropdownOnSelect(Event event, dynamic option, [String displayText]) {
    event.stopPropagation();
    itemSelected = option;
    //
    if (displayText == null) {
      inputText = getDisplayName(itemSelected);
    } else {
      inputText = displayText;
    }

    //aciona o NgModel bind
    onChangeControlValueAccessor(itemSelected,
        rawValue: itemSelected.toString());

    ///aciona o evento change
    _changeController.add(itemSelected);
    //fecha mo dropdown
    toogleDrop();
  }

// **************** INICIO FUNÇÔES DO NGMODEL ControlValueAccessor *********************
  @override
  void writeValue(value) {}
  @override
  void onDisabledChanged(bool isDisabled) {}
  TouchFunction onTouchedControlValueAccessor = () {};
  /*@HostListener('blur')
  void touchHandler() {  
    print("touchHandler"); 
    onTouched();
  }*/
  /// Set the function to be called when the control receives a touch event.
  @override
  void registerOnTouched(TouchFunction fn) {
    onTouchedControlValueAccessor = fn;
  }

  //função a ser chamada para notificar e modificar o modelo vinculado pelo ngmodel
  ChangeFunction<dynamic> onChangeControlValueAccessor =
      (dynamic _, {String rawValue}) {
    print('onChangeControlValueAccessor $_');
  };

  /// Set the function to be called when the control receives a change event.
  @override
  void registerOnChange(ChangeFunction<dynamic> fn) {
    onChangeControlValueAccessor = fn;
  }

  //**************** /FIM FUNÇÔES DO NGMODEL ControlValueAccessor ****************

  StreamSubscription ssControlValueChanges;

  @override
  void ngAfterViewInit() {
    /* if (ngControl?.control != null) {
      //este ouvinte de evento é chamado todo vez que o modelo vinculado pelo ngModel muda
      ssControlValueChanges = ngControl.control.valueChanges.listen((value) {
        print("ngControl.control.valueChanges $value");

        //_changeDetector.markForCheck();
      });
    }*/
  }
  @override
  void ngAfterChanges() {
    //print("$_options");
  }

  String getDisplayName(dynamic val) {
    if (val is String) {
      return val;
    } else if (val is num) {
      return val.toString();
    } else if (val is IHasUIDisplayName) {
      return val.getUiDisplayName();
    } else if (val is ISimpleSelectRender) {
      return val.getDisplayName();
    } else {
      return '';
    }
  }

  @override
  void ngOnDestroy() {
    ssControlValueChanges?.cancel();
    streamSubscriptionBodyOnCLick?.cancel();
    streamSubscriptionBodyOnCLick = null;
    ssControlValueChanges = null;
    inputEl = null;
  }

  void showDropdown(Event e) {
    // var target = e.target as HtmlElement;
    //var rect = target.getBoundingClientRect();
    //print("${rect.top} ${rect.right} ${rect.bottom}, ${rect.left}");
    //var parent = getScrollParent(target, false);
    //print(parent.scrollTop);
    // var p = (rect.top + parent.scrollTop) - 145;
    //String position = "${p}px";
    //print(position);
    // dropdownMenu.style.top = position;
    e.stopPropagation();
    //var dropdownmenu = target.nextElementSibling;
    closeAllSelect(dropdownMenu);
    toogleDrop();
  }

  //fecha todos os selects menos o que for passado por parametro
  void closeAllSelect([butThisOne]) {
    dropdownMenu
        ?.closest('body')
        ?.querySelectorAll('div.dropdown-menu')
        ?.forEach((ele) {
      if (butThisOne == ele) {
        //print('igual');
      } else {
        ele.classes.remove('show');
      }
    });
  }

  Map<String, dynamic> offset(el) {
    var rect = el.getBoundingClientRect(),
        /*scrollLeft = window.pageXOffset != null || document.documentElement.scrollLeft != null,
        scrollTop = window.pageYOffset != null || document.documentElement.scrollTop != null;*/
        scrollLeft = window.pageXOffset,
        scrollTop = window.pageYOffset;
    return {'top': rect.top + scrollTop, 'left': rect.left + scrollLeft};
  }

  //melhorar esta função para ter garantia de pegar o pai que tem rolagem
  HtmlElement getScrollParent(HtmlElement element, bool includeHidden) {
    var style = element.getComputedStyle();
    var excludeStaticParent = style.position == 'absolute';
    var overflowRegex = includeHidden
        ? RegExp('(auto|scroll|hidden)')
        : RegExp('(auto|scroll)');

    if (style.position == 'fixed') return document.body;
    for (var pare = element; (pare.parent != null);) {
      pare = pare.parent;
      style = pare.getComputedStyle();
      if (excludeStaticParent && style.position == 'static') {
        continue;
      }
      if (overflowRegex.hasMatch(
          style.overflow + style.overflowY + style.overflowX)) return pare;
    }

    return document.body;
  }

  void setDefaultOptionText() {
    inputText = _buttonText;
    for (var item in childrenSimpleSelectOptions) {
      if (item.value == null) {
        inputText = item.text;
        break;
      }
    }
  }

  bool isDropdownOpen = false;
  //exibe ou esconde o Dropdown
  void toogleDrop() {
    if (dropdownMenu != null) {
      if (dropdownMenu.classes.contains('show')) {
        dropdownMenu.classes.remove('show');
        isDropdownOpen = false;
      } else {
        dropdownMenu.classes.add('show');
        isDropdownOpen = true;
      }
    }
  }

  //selectedValue selection buttonText="{{selectedValue}}"
  // [(selection)]="selectedValue"

  //**************** Data Area ****************
  var itemSelected;

  List<dynamic> _options;
  List<dynamic> _optionsBkp;

  @Input()
  Map<String, dynamic> firstOption;

  @Input()
  set options(List<dynamic> opts) {
    _options = opts;
    _optionsBkp = _options.map((f) => f).toList();
  }

  List<dynamic> get options {
    return _options;
  }

  @override
  void ngAfterContentInit() {
    childrenSimpleSelectOptions.forEach((p) => p.parent = this);
  }

  //evento de click no input de busca do select
  void handleOnClickSearchbox(e) {
    e.stopPropagation();
  }

  //evento para filtrar as lista
  String _currentSearchString;
  void handleOnInputSearchbox(e) {
    _currentSearchString = removeAccents(inputsearch?.value?.toLowerCase());
    filterOptionList();
  }

  void filterOptionList() {
    if (_currentSearchString.isNotEmpty) {
      //filtra as tags options inside select <es-simple-select-option>
      childrenSimpleSelectOptions.forEach((item) {
        var value = removeAccents(item.text);
        item.hidden = true;
        if (value.toLowerCase().contains(_currentSearchString)) {
          item.hidden = false;
        }
      });
      //filtra as options do atributo options [options]=""
      var listaFiltrada = <dynamic>[];
      for (var item in _optionsBkp) {
        var value = removeAccents(getDisplayName(item));
        if (value.toLowerCase().contains(_currentSearchString)) {
          listaFiltrada.add(item);
        }
      }
      _options = listaFiltrada;
    } else {
      childrenSimpleSelectOptions.forEach((item) {
        item.hidden = false;
      });
      _options = _optionsBkp;
    }
  }
}

abstract class ISimpleSelectRender {
  String getDisplayName();
  //String getValue();
}
