import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:essential_components/src/core/interfaces/datatable_render_interface.dart';
import 'package:essential_components/src/core/models/data_table_filter.dart';

import '../data_table/data_table.dart';

import '../modal/modal.dart';

import 'package:essential_rest/essential_rest.dart';

@Component(
  selector: 'es-select-dialog',
  //changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: 'select_dialog.html',
  styleUrls: [
    'select_dialog.css',
  ],
  directives: [formDirectives, coreDirectives, EssentialDataTableComponent, EssentialModalComponent],
)
class EssentialSelectDialogComponent implements ControlValueAccessor, AfterViewInit, OnDestroy {
  @ViewChild('inputEl')
  InputElement inputEl;

  void setFocus() {
    inputEl.focus();
    print('setFocus $inputText');
  }

  @ViewChild('modal')
  EssentialModalComponent modal;
  final NgControl ngControl;
  /* ChangeDetectorRef _changeDetector;
  String _hintText;
  @Input()
  set hintText(value) {
    _hintText = value;
  }*/
  @Input('showDialog')
  bool showDialog = false;

  @Input('showHeader')
  bool showHeader = false;

  @Input('titleHeader')
  String titleHeader = '';

  bool focused = false;
  bool _disabled = false;
  bool get disabled => _disabled;

  @Input('disabled')
  set disabled(bool disabled) {
    _disabled = disabled;
  }

  @Input()
  String title;

  bool _inputRequired = false;
  bool get inputRequired => _inputRequired;

  @Input('inputRequired')
  set inputRequired(bool v) {
    var prev = _inputRequired;
    _inputRequired = v;
    if (_inputRequired) {
      inputEl.attributes['required'] = v.toString();
    } else {
      inputEl.attributes.remove('required');
    }

    //print('inputRequired $_inputRequired');
    if (prev != _inputRequired && ngControl != null) {
      // Required value changed and we are using a control. Force revalidation
      // on the control.
      ngControl.control.updateValueAndValidity();
    }
  }

  @Input('placeholder')
  String placeholder = 'Select';

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
  /// {'text', 'email', 'password', 'url', 'number', 'tel', 'search'}
  String type = 'text';

  int tabIndex = 0;
  @Input('inputTabIndex')
  set inputTabIndex(int v) => tabIndex = v;
  int get inputTabIndex => disabled ? -1 : tabIndex;

  String _inputText;

  @Input('inputText')
  set inputText(String value) {
    _inputText = value;
    updateInputTextLength();
    //var el = inputEl as InputElement;
    //el.value = _inputText;
    //_changeDetector.detectChanges();
    //_changeDetector.markForCheck();
  }

  String get inputText {
    return _inputText;
  }

  String _inputStyle = '';
  @Input('inputStyle')
  set inputStyle(String value) => _inputStyle = value;

  String get inputStyle => _inputStyle;

  //contrutor
  EssentialSelectDialogComponent(@Self() @Optional() this.ngControl, ChangeDetectorRef changeDetector) {
    // _changeDetector = changeDetector;
    // Replace the provider from above with this.
    if (ngControl != null) {
      // Setting the value accessor directly (instead of using
      // the providers) to avoid running into a circular import.
      ngControl.valueAccessor = this;

      if (ngControl?.control != null) {
        //este ouvinte de evento é chamado todo vez que o modelo vinculado pelo ngModel muda
        ssControlValueChanges = ngControl.control.valueChanges.listen((value) {
          //if (value != null) {
          fillInputFromIDataTableRender(value);
          //}
          //_changeDetector.markForCheck();
        });
      }
    }
  }

  void openDialog() {
    // modal.openDialog();
    showDialog = true;
  }

  void closeDialog() {
    //modal.closeDialog();
    showDialog = false;
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
    inputChange(
      element.value,
      element.validity.valid,
      element.validationMessage,
    );
    event.stopPropagation();
  }

  void inputChange(newValue, valid, validationMessage) {
    inputText = newValue;
    _changeController.add(itemSelected);
    // onChangeControlValueAccessor((newValue == '' ? null : newValue), rawValue: newValue);
  }

  void inputKeypress(newValue, valid, validationMessage) {
    inputText = newValue;
    _keypressController.add(newValue);
    //onChangeControlValueAccessor((newValue == '' ? null : newValue), rawValue: newValue);
  }

// **************** INICIO FUNÇÔES DO NGMODEL ControlValueAccessor *********************
  @override
  void writeValue(value) {}

  @override
  void onDisabledChanged(bool isDisabled) {}
  TouchFunction onTouchedControlValueAccessor = () {};
  /*@HostListener('blur')
  void touchHandler() {  

    onTouched();
  }*/
  /// Set the function to be called when the control receives a touch event.
  @override
  void registerOnTouched(TouchFunction fn) {
    onTouchedControlValueAccessor = fn;
  }

  //função a ser chamada para notificar e modificar o modelo vinculado pelo ngmodel
  ChangeFunction<dynamic> onChangeControlValueAccessor = (dynamic _, {String rawValue}) {};

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

  //**************** DataTable Area ****************
  IDataTableRender itemSelected;
  void onRowClick(IDataTableRender selected) {
    closeDialog();

    itemSelected = selected;
    _changeController.add(itemSelected);
    //seta o ngModel
    onChangeControlValueAccessor(itemSelected, rawValue: '');

    fillInputFromIDataTableRender(selected);
  }

  void fillInputFromIDataTableRender(IDataTableRender selected) {
    if (selected != null) {
      // ignore: omit_local_variable_types
      List<DataTableColumn> cols = selected.getRowDefinition()?.colsSets;
      if (cols != null) {
        for (var element in cols) {
          if (element != null && element.primaryDisplayValue) {
            inputText = element.value;
            break;
          }
        }
      }
    } else {
      inputText = null;
    }
  }

  @Input()
  int defaultItemsPerPage = 10;

  @Input()
  bool disabledBackdropClick = true;

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
