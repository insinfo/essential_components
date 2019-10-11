//workbook.xml
import 'package:xml/xml.dart' as xml;
import 'dart:convert';
class Workbook {
  String tagName = "workbook";
  Sheets sheets;
  String calcPr;
  Map<String, String> namespaces = {
    "http://schemas.openxmlformats.org/spreadsheetml/2006/main": "",
    "http://schemas.openxmlformats.org/officeDocument/2006/relationships": "r",
  };

  addSheet(Sheet sheet) {
    if (sheets == null) {
      sheets = Sheets();
    }
    sheets.addSheet(sheet);
  }

  toStringXml() {
    var builder = xml.XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8" standalone="yes"');
    //workbook
    builder.element(tagName,
        namespace: "http://schemas.openxmlformats.org/spreadsheetml/2006/main", namespaces: namespaces, nest: () {
      sheets?.createXmlElement(builder);
      builder.element('calcPr');
    });
    var xmlWorkbook = builder.build();
    var result = xmlWorkbook.toXmlString(pretty: true);
    print(result);
    return result;
  }

   List<int> toFileBytes() {
    return utf8.encode(toStringXml());
  }
}

class Sheets {
  String tagName = 'sheets';
  List<Sheet> sheets;

  addSheet(Sheet sheet) {
    if (sheets == null) {
      sheets = List<Sheet>();
    }
    sheet?.id = 'rId${sheets.length + 1}';
    sheet?.sheetId = sheets.length + 1;
    sheets.add(sheet);
  }

  createXmlElement(xml.XmlBuilder builder) {
    builder.element(tagName, nest: () {
      sheets?.forEach((child) {
        child?.createXmlElement(builder);
      });
    });
  }
}

class Sheet {
  String tagName = 'sheet';
  String state = 'visible';
  String name = 'Sheet 2';
  int sheetId;
  String id = 'rId3';

  Sheet({String state, String name, int sheetId, String id}) {
    this.state = state != null ? state : this.state;
    this.name = name != null ? name : this.name;
    this.sheetId = sheetId != null ? sheetId : this.sheetId;
    //this.id = id != null ? id : this.id;
  }

  createXmlElement(xml.XmlBuilder builder) {
    builder.element(tagName, attributes: {"state": state, "name": name, "sheetId": '1', "r:id": 'rId3'});
  }
}
