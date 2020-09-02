import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:essential_components/src/data_table/datatable_render_interface.dart';
import 'package:essential_components/src/directives/essential_inner_html_directive.dart';

import 'package:essential_components/src/pipes/truncate_pipe.dart';

@Component(
  selector: 'es-dynamic-data-table',
  templateUrl: 'dynamic_data_table.html',
  styleUrls: [
    'dynamic_data_table.css',
  ],
  pipes: [commonPipes, TruncatePipe],
  directives: [
    formDirectives,
    coreDirectives,
    EssentialInnerHTMLDirective,
  ],
)
//A Material Design Data table component for AngularDart
class EsDynamicDataTableComponent implements OnInit, AfterChanges, AfterViewInit {
  @Input()
  bool showActionsHeader = true;

  @Input()
  bool headersFromMap = true;

  @Input()
  bool showTableHeader = true;

  @Input()
  bool showActionsFooter = true;

  @Input()
  Iterable<String> hideColumns = [];

  @Input()
  int limitColumnTitleCount = 5;

  @Input()
  bool enableLimitColumnTitles = false;

  dynamic _data;
  @Input()
  set data(dynamic data) {
    _data = data;
  }

  dynamic get data {
    return _data;
  }

  Iterable<DataTableColumn> get columnHeaders {
    var headers = <DataTableColumn>[];
    if (data != null) {
      if (data is List<Map<String, dynamic>>) {
        if (headersFromMap) {
          var item = data[0] as Map<String, dynamic>;
          if (hideColumns?.isNotEmpty == true) {
            return item.keys.where((k) => !hideColumns.contains(k)).map((e) {
              /*if (enableLimitColumnTitles) {
                e = Helper.truncate(e, limitColumnTitleCount);
              }*/
              return DataTableColumn(title: e.toUpperCase());
            }).toList();
          }
          return item.keys.map((e) => DataTableColumn(title: e.toUpperCase())).toList();
        }
      }
    }
    return headers;
  }

  Iterable<DataTableRow> get columnRows {
    var rows = <DataTableRow>[];
    if (data != null) {
      if (data is List<Map<String, dynamic>>) {
        var list = data as List<Map<String, dynamic>>;
        for (var i = 0; i < list.length; i++) {
          var item = list[i];
          var row = DataTableRow();
          //row.colsSets = item.values.map((e) => DataTableColumn(value: e.toUpperCase())).toList();
          item.forEach((k, value) {
            row.colsSets.add(
              DataTableColumn(
                key: k,
                value: value.toUpperCase(),
                visible: !hideColumns.contains(k),
              ),
            );
          });
          rows.add(row);
        }
      }
    }
    return rows;
  }

  @override
  void ngAfterChanges() {}

  @override
  void ngAfterViewInit() {}

  @override
  void ngOnInit() {}
}
