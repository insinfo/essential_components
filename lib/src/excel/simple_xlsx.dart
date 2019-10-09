import './models/doc_props/app.dart';
import './models/doc_props/core.dart';
import './models/rels/relationship.dart';
import './models/rels/relationships.dart';
import './models/xl/theme/theme.dart';
import './models/xl/sharedString.dart';

class SimpleXLSX {
  SimpleXLSX() {
    //Properties().toStringXml();
    createSharedString();
  }
  //_rels\.rels
  createRelsOfXLSX() {
    var relationships = Relationships();
    relationships.children = [
      Relationship(
          id: 'rId3',
          type: "http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties",
          target: "docProps/app.xml"),
      Relationship(
          id: 'rId2',
          type: "http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties",
          target: "docProps/core.xml"),
      Relationship(
          id: 'rId1',
          type: "http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument",
          target: "xl/workbook.xml"),
    ];
    relationships.toStringXml();
  }

  //xl\_rels\workbook.xml.rels
  createRelsOfXl() {
    var relationships = Relationships();
    relationships.children = [
      Relationship(
          id: 'rId3',
          type: "http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles",
          target: "styles.xml"),
      Relationship(
          id: 'rId2',
          type: "http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme",
          target: "theme/theme1.xml"),
      Relationship(
          id: 'rId1',
          type: "http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet",
          target: "worksheets/sheet1.xml"),
      Relationship(
          id: 'rId4',
          type: "http://schemas.openxmlformats.org/officeDocument/2006/relationships/sharedStrings",
          target: "sharedStrings.xml")
    ];
    relationships.toStringXml();
  }

  createTheme() {
    var t = Theme();
    t.toStringXml();
  }

  createSharedString() {
    var t = SharedString();
    t.toStringXml();
  }
}
