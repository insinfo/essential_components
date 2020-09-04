import 'dart:html' as html;

import 'package:essential_components/src/core/hash.dart';

class DataTableRow {
  static DataTableRow instance;
  List<DataTableColumn> colsSets;
  DataTableRow() {
    colsSets = <DataTableColumn>[];
  }

  static DataTableRow getInstance() {
    if (instance == null) {
      return DataTableRow();
    } else {
      return instance;
    }
  }

  void addSet(DataTableColumn colSet) {
    colsSets.add(colSet);
  }
}

enum DataTableColumnType { img, text, date, dateTime, boolLabel, brasilCurrency, badge, link }

//primaryDisplayValue é o Valor de exibição principal
//a ser exibido quando não for possivel exibir mais de uma coluna
//primaryDisplayValue também é usado pelo component Select Dialog
class DataTableColumn {
  dynamic key;
  dynamic value;
  DataTableColumnType type;
  String title;
  int limit;
  String format;
  String textColor;
  String backgroundColor;
  bool primaryDisplayValue;
  dynamic Function(html.TableCellElement, dynamic) customRender;
  String badgeColor;
  bool visible;
  bool visibleForPrint;
  bool export;

  void fillFromDataTableColumn(DataTableColumn col, {ignoreValue = true}) {
    key = col.key;
    if (!ignoreValue) {
      value = col.value;
    }
    type = col.type;
    title = col.title;
    limit = col.limit;
    format = col.format;
    textColor = col.textColor;
    backgroundColor = col.backgroundColor;
    primaryDisplayValue = col.primaryDisplayValue;
    customRender = col.customRender;
    badgeColor = col.badgeColor;
    visible = col.visible;
    visibleForPrint = col.visibleForPrint;
    export = col.export;
  }

  void toogleVisibility() {
    visible = !visible;
  }

  // Define that two persons are equal if their SSNs are equal

  @override
  bool operator ==(o) => o is DataTableColumn && key == o.key;

  @override
  int get hashCode => hash2(key.hashCode, key.hashCode);

  DataTableColumn(
      {this.key,
      this.value,
      this.type = DataTableColumnType.text,
      this.title,
      this.limit,
      this.format,
      this.textColor,
      this.backgroundColor,
      this.customRender,
      this.badgeColor,
      this.primaryDisplayValue = false,
      this.visible = true,
      this.visibleForPrint = true,
      this.export = true});
}

abstract class IDataTableRender {
  DataTableRow getRowDefinition();
}
