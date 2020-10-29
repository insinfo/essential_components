import 'package:angular/angular.dart';

import 'date_picker.dart';

/// Creates a [EsMonthPickerComponent], this will be the view showed in the [NgEsDatePicker] when user clicks
/// month header button
@Component(
    selector: 'es-month-picker',
    templateUrl: 'month_picker.html',
    directives: [coreDirectives],
    providers: [EsDatePickerComponent])
class EsMonthPickerComponent {
  void toggleMode(e, [num dir]) {
    e.stopPropagation();
    datePicker.toggleMode(dir);
  }

  void select(e, date) {
    e.stopPropagation();
    datePicker.select(date);
  }

  @Input()
  String locale = 'pt_BR'; //en_US

  /// parent [EsDatePickerInnerComponent]
  EsDatePickerComponent datePicker;

  /// label that appears in the year button header
  String yearTitle;

  /// label that appears in the day button header
  String dayTitle;

  /// rows that will be displayed in the month view
  List<List<DisplayedDate>> rows = <List<DisplayedDate>>[];

  /// provides the maximum mode
  String maxMode = 'year';

  bool get isDataPickerMaxMode => datePicker.datePickerMode == maxMode;
  bool isCurrentRowSelected(DisplayedDate dt) => dt.current && !dt.selected;

  Map<String, bool> selectColor(DisplayedDate dt) =>
      {'btn-primary': dt.selected, 'btn-light': !dt.selected, 'active': dt.current, 'disabled': dt.disabled};

  void refreshViewHandler() {
    var months = List<DisplayedDate>(12);
    var initDate = datePicker.initDate;
    num year = initDate.year;
    DateTime date;
    for (var i = 0; i < 12; i++) {
      date = DateTime(year, i + 1, 1);
      months[i] = datePicker.createDateObject(date, datePicker.formatMonth);
    }
    dayTitle = datePicker.dateFilter(initDate, datePicker.formatDay);
    yearTitle = datePicker.dateFilter(initDate, datePicker.formatYear);
    rows = datePicker.split(months, 3);
  }
}
