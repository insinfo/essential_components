

class DataTableData {
  static DataTableData instance;
  List<DataTableColumnData> colsSets;
  DataTableSettings() {
    colsSets =  List<DataTableColumnData>();
  }

  static DataTableData getInstance() {
    if (instance == null) {
      return  DataTableData();
    } else {
      return instance;
    }
  }

  addSet(DataTableColumnData colSet) {
    colsSets.add(colSet);
  }

  getSets(){
    return colsSets;
  }
  
}

enum DataTableColumnType { img, text, date, dateTime }

//primaryDisplayValue é o Valor de exibição principal 
//a ser exibido quando não for possivel exibir mais de uma coluna
//primaryDisplayValue também é usado pelo component Select Dialog
class DataTableColumnData {
  dynamic key;
  dynamic value;
  DataTableColumnType type;
  String title;
  int limit;
  String format;
  bool primaryDisplayValue;
  DataTableColumnData({this.key,this.value, this.type=DataTableColumnType.text, this.title, this.limit, this.format,this.primaryDisplayValue=false});
}

abstract class IDataTableRender {
  DataTableData toDataTable();
}
