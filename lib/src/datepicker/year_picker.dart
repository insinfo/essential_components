import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'date_picker.dart';
import 'dart:html';
import 'package:intl/intl.dart';
import '../core/helper.dart';

/// Creates an [EsYearPickerComponent], this will be the view showed in the [NgEsDatePicker] when user clicks
/// year header button
@Component(
    selector: "es-year-picker",
    templateUrl: 'year_picker.html',
    directives: [coreDirectives],
    providers: [EsDatePickerComponent])
class EsYearPickerComponent {
  /// container of the date-picker
  EsDatePickerComponent datePicker;

  @Input()
  String locale = 'pt_BR';

  /// label that appears in the day button which selects the day-picker
  String dayTitle;

  /// label that appears in the month button which selects the month-picker
  String monthTitle;

  /// rows of the years that will appears in the year-picker
  List<List<DisplayedDate>> rows = List<List<DisplayedDate>>();

  /// gets the value of the starting year of the viewed group
  int getStartingYear(num year) => ((year - 1) ~/ datePicker.yearRange) * datePicker.yearRange + 1;

  Map<String, bool> selectColor(DisplayedDate dt) => {'btn-primary': dt.selected, 'btn-light': !dt.selected, 'active': dt.current, 'disabled': dt.disabled};
  bool get isCurrentRowSelected => dt.current && !dt.selected;

  refreshViewHandler() {
    List<DisplayedDate> years = List(datePicker.yearRange);
    DateTime date;
    DateTime initDate = datePicker.initDate;
    for (var i = 0, start = getStartingYear(initDate.year); i < datePicker.yearRange; i++) {
      date = DateTime(start + i, 0, 1);
      years[i] = datePicker.createDateObject(date, datePicker.formatYear);
    }
    datePicker.dateFilter(initDate, datePicker.formatDay); 
    monthTitle = datePicker.dateFilter(initDate, datePicker.formatMonth);
    rows = datePicker.split(years, 5);
  }
}
