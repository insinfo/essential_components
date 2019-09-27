class DataTableRow {
  static DataTableRow instance;
  List<DataTableColumn> colsSets;
  DataTableRow() {
    colsSets = List<DataTableColumn>();
  }

  static DataTableRow getInstance() {
    if (instance == null) {
      return DataTableRow();
    } else {
      return instance;
    }
  }

  addSet(DataTableColumn colSet) {
    colsSets.add(colSet);
  }

  List<DataTableColumn> getSets() {
    return colsSets;
  }
}

enum DataTableColumnType { img, text, date, dateTime, boolLabel, brasilCurrency, badge }

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
      this.primaryDisplayValue = false});
}

abstract class IDataTableRender {
  DataTableRow getRowDefinition();
}
