import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_forms/angular_forms.dart';

import '../data_table/data_table.dart';
import '../data_table/datatable_render_interface.dart';
import '../data_table/response_list.dart';

import '../data_table/data_table_filter.dart';
import '../modal/modal.dart';

import '../interface_has_ui_display_name.dart';

@Component(
  selector: 'es-simple-select',
  //changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: 'simple_select.html',
  styleUrls: [
    'simple_select.css',
  ],
  directives: [formDirectives, coreDirectives],
)
class EssentialSimpleSelectComponent
    implements ControlValueAccessor, AfterViewInit, AfterContentInit, OnDestroy, AfterChanges {
  @ViewChild('inputEl')
  ButtonElement inputEl;

  @ViewChild('dropdownMenu')
  DivElement dropdownMenu;

  @ContentChildren(EsSimpleSelectOptionComponent)
  List<EsSimpleSelectOptionComponent> childrenSimpleSelectOptions;

  final NgControl ngControl;

  bool _required = false;
  bool get required => _required;
  bool focused = false;

  bool _disabled = false;
  bool get disabled => _disabled;

  @Input()
  set disabled(bool disabled) {
    _disabled = disabled;
  }

  @Input()
  String label;

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
  String _displaytype = "select";

  @Input('displaytype')
  set displaytype(String value) {
    _displaytype = value;
  }

  get displaytype {
    return _displaytype;
  }

  int get inputTabIndex => disabled ? -1 : 0;

  String _inputText = '';

  @Input('buttonText')
  set inputText(String value) {
    _inputText = value;
  }

  get inputText {
    return _inputText;
  }

  //contrutor
  EssentialSimpleSelectComponent(@Self() @Optional() this.ngControl, ChangeDetectorRef changeDetector) {
    // _changeDetector = changeDetector;
    // Replace the provider from above with this.
    if (this.ngControl != null) {
      // Setting the value accessor directly (instead of using
      // the providers) to avoid running into a circular import.
      this.ngControl.valueAccessor = this;

      if (ngControl?.control != null) {
        //este ouvinte de evento é chamado todo vez que o modelo vinculado pelo ngModel muda
        ssControlValueChanges = ngControl.control.valueChanges.listen((value) {
          if (value != null) {
            itemSelected = value;
            inputText = getDisplayName(value);
          }
          //_changeDetector.markForCheck();
        });
      }
    }
    //evento global de click
    streamSubscriptionBodyOnCLick = window.document.querySelector('body').onClick.listen(handleBodyOnCLick);
  }

  //evento global de click
  StreamSubscription streamSubscriptionBodyOnCLick;
  void handleBodyOnCLick(e) {
    if (isDropdownOpen) {
      toogleDrop();
    }
  }

  void inputFocusAction(event) {
    focused = true;
  }

  void inputBlurAction(event, valid, validationMessage) {
    focused = false;
    _blurController.add(event);
  }

  ///este metodo é chamado quando clica em uma opção do select
  dropdownOnSelect(Event event, dynamic option, [String displayText]) {
    event.stopPropagation();
    itemSelected = option;
    //
    if (displayText == null) {
      inputText = getDisplayName(itemSelected);
    } else {
      inputText = displayText;
    }

   
    //aciona o NgModel bind
    onChangeControlValueAccessor(itemSelected, rawValue: itemSelected.toString());
     ///aciona o evento change
    _changeController.add(itemSelected);
    //fecha mo dropdown
    toogleDrop();
  }

// **************** INICIO FUNÇÔES DO NGMODEL ControlValueAccessor *********************
  void writeValue(value) {}
  void onDisabledChanged(bool isDisabled) {}
  TouchFunction onTouchedControlValueAccessor = () {};
  /*@HostListener('blur')
  void touchHandler() {  
    print("touchHandler"); 
    onTouched();
  }*/
  /// Set the function to be called when the control receives a touch event.
  void registerOnTouched(TouchFunction fn) {
    onTouchedControlValueAccessor = fn;
  }

  //função a ser chamada para notificar e modificar o modelo vinculado pelo ngmodel
  ChangeFunction<dynamic> onChangeControlValueAccessor = (dynamic _, {String rawValue}) {
    print("onChangeControlValueAccessor $_");
  };

  /// Set the function to be called when the control receives a change event.
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

  getDisplayName(dynamic val) {
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

  showDropdown(Event e) {
    HtmlElement target = e.target;
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
    toogleDrop();
  }

  offset(el) {
    var rect = el.getBoundingClientRect(),
        /*scrollLeft = window.pageXOffset != null || document.documentElement.scrollLeft != null,
        scrollTop = window.pageYOffset != null || document.documentElement.scrollTop != null;*/
        scrollLeft = window.pageXOffset,
        scrollTop = window.pageYOffset;
    return {"top": rect.top + scrollTop, "left": rect.left + scrollLeft};
  }

  //melhorar esta função para ter garantia de pegar o pai que tem rolagem
  HtmlElement getScrollParent(HtmlElement element, bool includeHidden) {
    var style = element.getComputedStyle();
    var excludeStaticParent = style.position == "absolute";
    var overflowRegex = includeHidden ? RegExp("(auto|scroll|hidden)") : RegExp("(auto|scroll)");

    if (style.position == "fixed") return document.body;
    for (var pare = element; (pare.parent != null);) {
      pare = pare.parent;
      style = pare.getComputedStyle();
      if (excludeStaticParent && style.position == "static") {
        continue;
      }
      if (overflowRegex.hasMatch(style.overflow + style.overflowY + style.overflowX)) return pare;
    }

    return document.body;
  }

  bool isDropdownOpen = false;
  //exibe ou esconde o Dropdown
  toogleDrop() {
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

  @Input()
  Map<String, dynamic> firstOption;

  @Input()
  set options(List<dynamic> opts) {
    _options = opts;
  }

  List<dynamic> get options {
    return _options;
  }

  @override
  void ngAfterContentInit() {
    childrenSimpleSelectOptions.forEach((p) => p.parent = this);
  }
}

abstract class ISimpleSelectRender {
  String getDisplayName();
  //String getValue();
}

///options do select <es-simple-select-option>
@Component(
  selector: 'es-simple-select-option',
  templateUrl: 'simple_select_option.html',
  styleUrls: ['simple_select_option.css'],
  directives: [coreDirectives],
  //styleUrls: ['accordion.css']
)
class EsSimpleSelectOptionComponent implements OnInit {
  EsSimpleSelectOptionComponent();
  EssentialSimpleSelectComponent parent;
  //TemplateRef headingTemplate;

  @ViewChild('item')
  HtmlElement item;

  get text {
    return item?.firstChild?.text;
  }

  set text(String inputText) {
    item?.text = inputText;
  }

  get innerHtml {
    return item?.firstChild?.text;
  }

  set innerHtml(String inputText) {
    item?.innerHtml = innerHtml;
  }

  @Input()
  dynamic value;

  handleOnClick(Event e) {
    e.stopPropagation();
    parent.dropdownOnSelect(e, value, item?.firstChild?.text);
  }

  /// initialize the default values of the attributes
  @override
  ngOnInit() {}
}
