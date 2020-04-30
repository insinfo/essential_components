//workbook.xml
import 'package:xml/xml.dart' as xml;
import 'dart:convert';

class Workbook {
  String tagName = 'workbook';
  Sheets sheets;
  String calcPr;
  Map<String, String> namespaces = {
    'http://schemas.openxmlformats.org/spreadsheetml/2006/main': '',
    'http://schemas.openxmlformats.org/officeDocument/2006/relationships': 'r',
  };

  void addSheet(Sheet sheet) {
    sheets ??= Sheets();
    sheet?.sheetId = sheets.sheets.length + 1;
    sheets.addSheet(sheet);
  }

  String toStringXml() {
    var builder = xml.XmlBuilder();
    builder.processing(
        'xml', 'version="1.0" encoding="UTF-8" standalone="yes"');
    //workbook
    builder.element(tagName,
        namespace: 'http://schemas.openxmlformats.org/spreadsheetml/2006/main',
        namespaces: namespaces, nest: () {
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
    sheets = <Sheet>[];
  }

  void addSheet(Sheet sheet) {
    sheets ??= <Sheet>[];
    sheet?.relationId = sheet?.relationId ?? 'rId${sheets.length + 1}';
    sheet?.sheetId = sheets.length + 1;
    sheets.add(sheet);
  }

  void createXmlElement(xml.XmlBuilder builder) {
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

  Sheet(String name, int relationId, {String state}) {
    this.state = state ?? 'visible';
    this.name = name ?? 'Sheet 2';
    this.relationId = relationId != null ? 'rId$relationId' : 'rId3';
  }

  void createXmlElement(xml.XmlBuilder builder) {
    builder.element(tagName, attributes: {
      'state': state,
      'name': name,
      'sheetId': sheetId.toString(),
      'r:id': relationId,
    });
  }
}
