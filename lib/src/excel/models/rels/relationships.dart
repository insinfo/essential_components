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

  Map<String, String> namespaces = {
    'http://schemas.openxmlformats.org/package/2006/relationships': ''
  };

  Relationships() {
    relations = <Relationship>[];
  }

  void addWorksheet(int relationId, {String sheetName}) {
    sheetName = sheetName ?? 'sheet1';
    relations.add(Relationship(
        id: 'rId$relationId',
        type:
            'http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet',
        target: 'worksheets/${sheetName}.xml'));
    id++;
    sheetindex++;
  }

  void addWorkbook(int relationId) {
    relations.add(Relationship(
        id: 'rId$relationId',
        type:
            'http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument',
        target: 'xl/workbook.xml'));
    id++;
    workbookindex++;
  }

  void addApp(int relationId) {
    relations.add(Relationship(
        id: 'rId$relationId',
        type:
            'http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties',
        target: 'docProps/app.xml'));
    id++;
    workbookindex++;
  }

  void addCore(int relationId) {
    relations.add(Relationship(
        id: 'rId$relationId',
        type:
            'http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties',
        target: 'docProps/core.xml'));
    id++;
    workbookindex++;
  }

  void addStyle(int relationId) {
    relations.add(Relationship(
        id: 'rId$relationId',
        type:
            'http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles',
        target: 'styles.xml'));

    id++;
    styleindex++;
  }

  void addTheme(int relationId) {
    relations.add(Relationship(
        id: 'rId$relationId',
        type:
            'http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme',
        target: 'theme/theme$themeindex.xml'));
    id++;
    themeindex++;
  }

  void addSharedStrings(int relationId) {
    relations.add(Relationship(
        id: 'rId$relationId',
        type:
            'http://schemas.openxmlformats.org/officeDocument/2006/relationships/sharedStrings',
        target: 'sharedStrings.xml'));
    id++;
    sharedStringsindex++;
  }

  String toStringXml() {
    var builder = xml.XmlBuilder();
    builder.processing(
        'xml', 'version="1.0" encoding="UTF-8" standalone="yes"');
    builder.element('Relationships', namespaces: namespaces, nest: () {
      relations?.forEach((i) {
        i.createXmlElement(builder);
      });
    });
    var relationshipsXml = builder.build();
    var result = relationshipsXml.toXmlString(pretty: true);
    //print(result);
    return result;
  }

  Relationships.fromMap(Map<String, dynamic> map) {
    if (map.containsKey('Relationships')) {
      var list = map['Relationships'];
      if (list != null && list is List) {
        var l = <Relationship>[];
        list.forEach((v) {
          l.add(Relationship.fromMap(v));
        });
      }
    }
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (relations != null) {
      map['Relationships'] = relations.map((r) {
        return r.toMap();
      }).toList();
    }

    return map;
  }

  List<int> toFileBytes() {
    return utf8.encode(toStringXml());
  }
}
