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

  /* List<DataTableColumn> getSets() {
    return colsSets;
  }

 List<DataTableColumn> getCollsForDisplay() {
    return colsSets.where((i) => i.visible).toList();
  }

  List<DataTableColumn> getCollsForExport() {
    return colsSets.where((i) => i.export).toList();
  }*/
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
  Function customRender;
  String badgeColor;
  bool visible;
  bool visibleForPrint;
  bool export;

  void toogleVisibility() {
    visible = !visible;
  }

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
