import 'package:xml/xml.dart' as xml;
import 'relationship.dart';
import 'dart:convert';

class Relationships {
  List<Relationship> relations;
  int id = 1;
  int sheetindex = 1;
  int themeindex = 1;
  int styleindex = 1;
  int sharedStringsindex = 1;
  int workbookindex = 1;

  Map<String, String> namespaces = {"http://schemas.openxmlformats.org/package/2006/relationships": ""};

  Relationships() {
    relations = List<Relationship>();
  }

  void addWorksheet({String sheetName}) {
    sheetName = sheetName == null ? "sheet1" : sheetName;
    relations.add(Relationship(
        id: 'rId3',
        type: "http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet",
        target: "worksheets/${sheetName}.xml"));
    id++;
    sheetindex++;
  }

  void addWorkbook() {
    relations.add(Relationship(
        id: 'rId1',
        type: "http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument",
        target: "xl/workbook.xml"));
    id++;
    workbookindex++;
  }

  void addApp() {
    relations.add(Relationship(
        id: 'rId$id',
        type: "http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties",
        target: "docProps/app.xml"));
    id++;
    workbookindex++;
  }

  void addCore() {
    relations.add(Relationship(
        id: 'rId$id',
        type: "http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties",
        target: "docProps/core.xml"));
    id++;
    workbookindex++;
  }

  void addStyle() {
    relations.add(Relationship(
        id: 'rId2',
        type: "http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles",
        target: "styles.xml"));

    id++;
    styleindex++;
  }

  void addTheme() {
    relations.add(Relationship(
        id: 'rId$id',
        type: "http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme",
        target: "theme/theme$themeindex.xml"));
    id++;
    themeindex++;
  }

  void addSharedStrings() {
    relations.add(Relationship(
        id: 'rId$id',
        type: "http://schemas.openxmlformats.org/officeDocument/2006/relationships/sharedStrings",
        target: "sharedStrings.xml"));
    id++;
    sharedStringsindex++;
  }

  String toStringXml() {
    var builder = xml.XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8" standalone="yes"');
    builder.element('Relationships', namespaces: namespaces, nest: () {
      relations?.forEach((i) {
        i.createXmlElement(builder);
      });
    });
    var relationshipsXml = builder.build();
    var result = relationshipsXml.toXmlString(pretty: true);
    print(result);
    return result;
  }

  Relationships.fromMap(Map<String, dynamic> map) {
    if (map.containsKey('Relationships')) {
      var list = map['Relationships'];
      if (list != null && list is List) {
        var l = List<Relationship>();
        list.forEach((v) {
          l.add(Relationship.fromMap(v));
        });
      }
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (relations != null) {
      map['Relationships'] = this.relations.map((r) {
        return r.toMap();
      }).toList();
    }

    return map;
  }

  List<int> toFileBytes() {
    return utf8.encode(toStringXml());
  }
}
