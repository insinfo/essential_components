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
    sheet?.sheetId = sheets.sheets.length + 1;
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
    //print(result);
    return result;
  }

  List<int> toFileBytes() {
    return utf8.encode(toStringXml());
  }
}

class Sheets {
  String tagName = 'sheets';
  List<Sheet> sheets;

  Sheets() {
    sheets = List<Sheet>();
  }

  addSheet(Sheet sheet) {
    if (sheets == null) {
      sheets = List<Sheet>();
    }
    sheet?.relationId = sheet?.relationId == null ? 'rId${sheets.length + 1}' : sheet?.relationId;
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
  int sheetId = 1;
  String relationId = 'rId3';

  Sheet(String nome, int relatId, {String state}) {
    this.state = state != null ? state : 'visible';
    this.name = nome != null ? nome : 'Sheet 2';
    this.relationId = relatId != null ? 'rId$relatId' : 'rId3';
  }

  createXmlElement(xml.XmlBuilder builder) {
    builder.element(tagName,
        attributes: {"state": state, "name": name, "sheetId": this.sheetId.toString(), "r:id": this.relationId});
  }
}
