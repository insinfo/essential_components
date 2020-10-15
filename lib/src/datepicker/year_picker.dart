import 'package:angular/angular.dart';

import 'date_picker.dart';

/// Creates an [EsYearPickerComponent], this will be the view showed in the [NgEsDatePicker] when user clicks
/// year header button
@Component(
    selector: 'es-year-picker',
    templateUrl: 'year_picker.html',
    directives: [coreDirectives],
    providers: [EsDatePickerComponent])
class EsYearPickerComponent {
  /// container of the date-picker
  EsDatePickerComponent datePicker;

  //$event.stopPropagation(); datePicker.move(1)
  void move(event, [num dir]) {
    event.stopPropagation();
    datePicker.move(dir);
  }

  void toggleMode(event, [num dir]) {
    event.stopPropagation();
    datePicker.toggleMode(dir);
  }

  void select(event, date) {
    event.stopPropagation();
    datePicker.select(date);
  }

  @Input()
  String locale = 'pt_BR';

  /// label that appears in the day button which selects the day-picker
  String dayTitle;

  /// label that appears in the month button which selects the month-picker
  String monthTitle;

  /// rows of the years that will appears in the year-picker
  List<List<DisplayedDate>> rows = <List<DisplayedDate>>[];

  /// gets the value of the starting year of the viewed group
  int getStartingYear(num year) => ((year - 1) ~/ datePicker.yearRange) * datePicker.yearRange + 1;

  Map<String, bool> selectColor(DisplayedDate dt) =>
      {'btn-primary': dt.selected, 'btn-light': !dt.selected, 'active': dt.current, 'disabled': dt.disabled};
  bool isCurrentRowSelected(DisplayedDate dt) => dt.current && !dt.selected;

  void refreshViewHandler() {
    var years = List<DisplayedDate>(datePicker.yearRange);
    DateTime date;
    var initDate = datePicker.initDate;
    for (var i = 0, start = getStartingYear(initDate.year); i < datePicker.yearRange; i++) {
      date = DateTime(start + i, 0, 1);
      years[i] = datePicker.createDateObject(date, datePicker.formatYear);
    }
    datePicker.dateFilter(initDate, datePicker.formatDay);
    monthTitle = datePicker.dateFilter(initDate, datePicker.formatMonth);
    rows = datePicker.split(years, 5);
  }
}
