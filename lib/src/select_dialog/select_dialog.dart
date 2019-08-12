import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_forms/angular_forms.dart';

import '../data_table/data_table.dart';
import '../data_table/datatable_render_interface.dart';
import '../data_table/response_list.dart';

import '../data_table/data_table_filter.dart';

@Component(
  selector: 'select-dialog',
  //changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: 'select_dialog.html',
  styleUrls: [
    'select_dialog.css',
  ],
  directives: [formDirectives, coreDirectives, DataTable],
)
class SelectDialog implements ControlValueAccessor, AfterViewInit, OnDestroy {
  @ViewChild('inputEl')
  ElementRef inputEl;

  final NgControl ngControl;
  ChangeDetectorRef _changeDetector;
  String _hintText;
  bool showDialog = false;

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
  set hintText(value) {
    _hintText = value;
  }

  @Input()
  int maxCount;

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

  int _inputTextLength = 0;
  int get inputTextLength => _inputTextLength;

  void updateInputTextLength() {
    if (_inputText == null) {
      _inputTextLength = 0;
    } else {
      _inputTextLength = _inputText.length;
    }
  }

  final _keypressController = StreamController<String>.broadcast(sync: true);

  /// Publishes events whenever input text changes (each keypress).
  @Output('inputKeyPress')
  Stream<String> get onKeypress => _keypressController.stream;

  final _changeController = StreamController<String>.broadcast(sync: true);

  /// Publishes events when a change event is fired. (On enter, or on blur.)
  @Output('change')
  Stream<String> get onChange => _changeController.stream;

  final _blurController = StreamController<FocusEvent>.broadcast(sync: true);

  /// Publishes events when a blur event is fired.
  @Output('blur')
  Stream<FocusEvent> get onBlur => _blurController.stream;

  /// Type of input.
  ///
  /// It can be one of the following:
  /// {"text", "email", "password", "url", "number", "tel", "search"}
  String type = "text";

  int get inputTabIndex => disabled ? -1 : 0;

  String _inputText = '';

  set inputText(String value) {
    _inputText = value;
    updateInputTextLength();
    //var el = inputEl as InputElement;
    //el.value = _inputText;
    //_changeDetector.detectChanges();
    //_changeDetector.markForCheck();
  }

  get inputText {
    return _inputText;
  }

  //contrutor
  SelectDialog(@Self() @Optional() this.ngControl, ChangeDetectorRef changeDetector) {
    _changeDetector = changeDetector;
    // Replace the provider from above with this.
    if (this.ngControl != null) {
      // Setting the value accessor directly (instead of using
      // the providers) to avoid running into a circular import.
      this.ngControl.valueAccessor = this;

      if (ngControl?.control != null) {
        //este ouvinte de evento é chamado todo vez que o modelo vinculado pelo ngModel muda
        ssControlValueChanges = ngControl.control.valueChanges.listen((value) {          
          if (value != null) {
            fillInputFromIDataTableRender(value);
          }
          //_changeDetector.markForCheck();
        });
      }
    }
  }

  toogleDialog() {
    showDialog = !showDialog;
  }

  void inputFocusAction(event) {
    focused = true;
  }

  void inputBlurAction(event, valid, validationMessage) {
    focused = false;
    _blurController.add(event);
  }

  //@HostListener('change', ['\$event.target.value'])
  @visibleForTemplate
  void handleChange(Event event, InputElement element) {
    //print("handleChange: ${element.value}");
    inputChange(
      element.value,
      element.validity.valid,
      element.validationMessage,
    );
    event.stopPropagation();
  }

  void inputChange(newValue, valid, validationMessage) {
    inputText = newValue;
    _changeController.add(newValue);
    // onChangeControlValueAccessor((newValue == '' ? null : newValue), rawValue: newValue);
  }

  void inputKeypress(newValue, valid, validationMessage) {
    inputText = newValue;
    _keypressController.add(newValue);
    //print("inputKeypress: ${inputText}");
    //onChangeControlValueAccessor((newValue == '' ? null : newValue), rawValue: newValue);
  }

/**************** INICIO FUNÇÔES DO NGMODEL ControlValueAccessor *********************/
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

  /**************** /FIM FUNÇÔES DO NGMODEL ControlValueAccessor ****************/

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
  void ngOnDestroy() {
    ssControlValueChanges?.cancel();
    ssControlValueChanges = null;
    inputEl = null;
  }

  /**************** DataTable Area ****************/
  IDataTableRender itemSelected;
  void onRowClick(IDataTableRender selected) {
    itemSelected = selected;

    //seta o ngModel
    onChangeControlValueAccessor(itemSelected, rawValue: "");

    toogleDialog();
    fillInputFromIDataTableRender(selected);
  }

  fillInputFromIDataTableRender(IDataTableRender selected) {
    if (selected != null) {
      List<DataTableColSet> cols = selected.toDataTable()?.colsSets;
      cols.forEach((DataTableColSet element) {
        if (element != null && element.primaryDisplayValue) {
          inputText = element.value;
          return;
        }
      });
    }
  }

  Future<void> onRequestData(DataTableFilter dataTableFilter) async {
    _dataRequest.add(dataTableFilter);
  }

  final _dataRequest = StreamController<DataTableFilter>();

  @Output()
  Stream<DataTableFilter> get dataRequest => _dataRequest.stream;

  RList<IDataTableRender> _data;
  //RList<IDataTableRender> selectedItems = new RList<IDataTableRender>();

  @Input()
  set data(RList<IDataTableRender> data) {
    _data = data;
  }

  RList<IDataTableRender> get data {
    return _data;
  }
}
