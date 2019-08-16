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

enum DataTableColumnType { img, text, date, dateTime }

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
  bool primaryDisplayValue;
  DataTableColumn(
      {this.key,
      this.value,
      this.type = DataTableColumnType.text,
      this.title,
      this.limit,
      this.format,
      this.primaryDisplayValue = false});
}

abstract class IDataTableRender {
  DataTableRow getRowDefinition();
}
