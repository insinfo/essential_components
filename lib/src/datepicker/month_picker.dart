import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'date_picker.dart';
import 'dart:html';
import 'package:intl/intl.dart';
import '../core/helper.dart';

/// Creates a [EsMonthPickerComponent], this will be the view showed in the [NgEsDatePicker] when user clicks
/// month header button
@Component(
    selector: "es-month-picker",
    templateUrl: 'month_picker.html',
    directives: [coreDirectives],
    providers: [EsDatePickerComponent])
class EsMonthPickerComponent {
  /// parent [EsDatePickerInnerComponent]
  EsDatePickerComponent datePicker;

  /// label that appears in the year button header
  String yearTitle;

  /// label that appears in the day button header
  String dayTitle;

  /// rows that will be displayed in the month view
  List<List<DisplayedDate>> rows = List<List<DisplayedDate>>();

  /// provides the maximum mode
  String maxMode = 'year';

  void refreshViewHandler() {
    List<DisplayedDate> months = List(12);
    DateTime initDate = datePicker.initDate;
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
