//workbook.xml

class Workbook {
  String tagName = "workbook";
  Sheets sheets;
  String calcPr;
  Map<String, String> namespaces = {
    "http://schemas.openxmlformats.org/spreadsheetml/2006/main": "",
    "http://schemas.openxmlformats.org/officeDocument/2006/relationships": "r",
  };
}

class Sheets {
  List<Sheet> sheets;
}

class Sheet { 
  String state;
  String name; 
  String sheetId; 
  String id;
}
