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

@Component(
  selector: 'es-dropdown-dialog',
  //changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: 'dropdown_dialog.html',
  styleUrls: [
    'dropdown_dialog.css',
  ],
  directives: [formDirectives, coreDirectives, EssentialDataTableComponent, EssentialModalComponent],
)
class EssentialDropdownDialogComponent implements ControlValueAccessor, AfterViewInit, OnDestroy {
  @ViewChild('buttonEl')
  ButtonElement buttonEl;

  @ViewChild('modal')
  EssentialModalComponent modal;

  @ViewChild('dataTable')
  EssentialDataTableComponent dataTable;

  final NgControl ngControl;

  bool showDialog = false;

  bool _disabled = false;
  bool get disabled => _disabled;

  @Input()
  set disabled(bool disabled) {
    _disabled = disabled;
  }

  @Input()
  bool openonclick = true;

  @Input()
  String label;

  @Input()
  String title;

  @Input()
  int maxCount;

  final _changeController = StreamController<RList<IDataTableRender>>.broadcast(sync: true);

  /// Publishes events when a change event is fired. (On enter, or on blur.)
  @Output('change')
  Stream<RList<IDataTableRender>> get onChange => _changeController.stream;

  /// Type of input.
  ///
  /// It can be one of the following:
  /// {"button", "submit", "menu", "reset"}
  String type = 'button';

  //contrutor
  EssentialDropdownDialogComponent(@Self() @Optional() this.ngControl, ChangeDetectorRef changeDetector) {
    // Replace the provider from above with this.
    if (this.ngControl != null) {
      // Setting the value accessor directly (instead of using
      // the providers) to avoid running into a circular import.
      this.ngControl.valueAccessor = this;

      if (ngControl?.control != null) {
        //este ouvinte de evento é chamado todo vez que o modelo vinculado pelo ngModel muda
        ssControlValueChanges = ngControl.control.valueChanges.listen((value) {
          if (value != null) {
            // fillInputFromIDataTableRender(value);
          }
          //_changeDetector.markForCheck();
        });
      }
    }
  }

  final _beforeShowController = StreamController<dynamic>.broadcast(sync: true);

  /// Publishes events when a change event is fired. (On enter, or on blur.)
  @Output('beforeshow')
  Stream<dynamic> get onBeforeShow => _beforeShowController.stream;

  final _clickController = StreamController<dynamic>.broadcast(sync: true);

  /// Publishes events when a change event is fired. (On enter, or on blur.)
  @Output('click')
  Stream<dynamic> get onClick => _clickController.stream;

  handleClick() {
    if (openonclick) {
      modal.openDialog();
    }
    _clickController.add("click");
  }

  openDialog() {
    _beforeShowController.add('beforeshow');
    modal.openDialog();
  }

  closeDialog() {
    modal.closeDialog();
  }

// **************** INICIO FUNÇÔES DO NGMODEL ControlValueAccessor *********************
  void writeValue(value) {}
  void onDisabledChanged(bool isDisabled) {}
  TouchFunction onTouchedControlValueAccessor = () {};

  /// Set the function to be called when the control receives a touch event.
  void registerOnTouched(TouchFunction fn) {
    onTouchedControlValueAccessor = fn;
  }

  //função a ser chamada para notificar e modificar o modelo vinculado pelo ngmodel
  ChangeFunction<RList<IDataTableRender>> onChangeControlValueAccessor =
      (RList<IDataTableRender> _, {String rawValue}) {};

  /// Set the function to be called when the control receives a change event.
  void registerOnChange(ChangeFunction<RList<IDataTableRender>> fn) {
    onChangeControlValueAccessor = fn;
  }

  //**************** /FIM FUNÇÔES DO NGMODEL ControlValueAccessor ****************

  StreamSubscription ssControlValueChanges;

  @override
  void ngAfterViewInit() {}

  @override
  void ngOnDestroy() {
    ssControlValueChanges?.cancel();
    ssControlValueChanges = null;
    buttonEl = null;
  }

  //**************** DataTable Area ****************

  DataTableFilter getDataTableFilter() {
    return dataTable.dataTableFilter;
  }
  
  selectItems() {
    closeDialog();
    _changeController.add(dataTable.selectedItems);
  }

  Future<void> onRequestData(DataTableFilter dataTableFilter) async {
    _dataRequest.add(dataTableFilter);
  }

  final _dataRequest = StreamController<DataTableFilter>();

  @Output()
  Stream<DataTableFilter> get dataRequest => _dataRequest.stream;

  RList<IDataTableRender> _data;

  @Input()
  set data(RList<IDataTableRender> data) {
    _data = data;
  }

  RList<IDataTableRender> get data {
    return _data;
  }
}
