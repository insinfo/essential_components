//worksheet.xml
import 'package:xml/xml.dart' as xml;
import 'dart:convert';

import '../../../helpers.dart';

//<worksheet mc:Ignorable="x14ac xr xr2 xr3"
class Worksheet {
  String tagName = 'worksheet';
  Cols cols;
  SheetData sheetData;
  String ignorable = 'x14ac xr xr2 xr3';

  Worksheet() {
    cols = Cols();
    sheetData = SheetData();
  }

  void addConlSettings(Col col) {
    cols?.cols?.add(col);
  }

  void addRow(Row row) {
    sheetData?.rows?.add(row);
  }

  Map<String, String> namespaces = {
    'http://schemas.openxmlformats.org/spreadsheetml/2006/main': '',
    'http://schemas.openxmlformats.org/markup-compatibility/2006': 'mc',
    'urn:schemas-microsoft-com:mac:vml': 'mv',
    'http://schemas.microsoft.com/office/mac/excel/2008/main': 'mx',
    'http://schemas.openxmlformats.org/officeDocument/2006/relationships': 'r',
    'http://schemas.microsoft.com/office/spreadsheetml/2009/9/main': 'x14',
    'http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac': 'x14ac',
    'http://schemas.microsoft.com/office/excel/2006/main': 'xm',
  };

  String toStringXml() {
    var builder = xml.XmlBuilder();
    builder.processing(
        'xml', 'version="1.0" encoding="UTF-8" standalone="yes"');
    //Worksheet
    builder.element(tagName,
        namespace: 'http://schemas.openxmlformats.org/spreadsheetml/2006/main',
        namespaces: namespaces,
        /*attributes: {"mc:Ignorable": ignorable},*/ nest: () {
      sheetData?.createXmlElement(builder);
      //builder.element('calcPr');
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

class SheetData {
  String tagName = 'sheetData';
  List<Row> rows;

  SheetData() {
    rows = <Row>[];
  }

  void createXmlElement(xml.XmlBuilder builder) {
    builder.element(tagName, nest: () {
      rows?.forEach((child) {
        child?.createXmlElement(builder);
      });
    });
  }
}

//<row r="2" s="3" customFormat="1">
class Row {
  String tagName = 'row';
  List<Cell> cells;
  int s; //s="3"
  int customFormat;
  int ht; //Height
  int customHeight;
  int rowIndex = 0;
  int colIndex = 0;

  Row(this.rowIndex) {
    cells = <Cell>[];
  }

  Row.getNew() {
    cells = <Cell>[];
    rowIndex++;
  }

  void addCellText(String text, {int cellIndex, int styleId}) {
    var cindex = colIndex;
    if (cellIndex != null) {
      cindex = cellIndex;
    }
    var col = Cell(Helpers.getInstance().cellName(cindex, rowIndex),
        inlineStr: InlineStr(text), styleId: styleId);
    //col.s = '4';
    addCell(col);
    colIndex++;
  }

  void addCell(Cell col) {
    cells.add(col);
    colIndex++;
  }

  Map<String, String> get attributes {
    var attribs = <String, String>{};

    attribs['r'] = rowIndex?.toString();

    if (s != null) {
      attribs['s'] = s.toString();
    }
    if (customFormat != null) {
      attribs['customFormat'] = customFormat.toString();
    }
    if (ht != null) {
      attribs['ht'] = ht.toString();
    }
    if (customHeight != null) {
      attribs['customHeight'] = customHeight.toString();
    }
    return attribs;
  }

  void createXmlElement(xml.XmlBuilder builder) {
    builder.element(tagName, attributes: attributes, nest: () {
      cells.forEach((child) {
        child.createXmlElement(builder);
      });
    });
  }
}

class InlineStr {
  String tagName = 'is';
  String text;

  InlineStr(this.text);

  void createXmlElement(xml.XmlBuilder builder) {
    builder.element(tagName, nest: () {
      builder.element('t', nest: () {
        builder.text(text);
      });
    });
  }
}

// <c r="B1" s="4" t="inlineStr">

///cell
class Cell {
  String tagName = 'c';
  InlineStr inlineStr;
  String cellName; //A1
  int style;
  String type = 'inlineStr';
  String value;

  Cell(this.cellName, {String type, InlineStr inlineStr, int styleId}) {
    if (type != null) {
      this.type = type;
    }
    if (inlineStr != null) {
      this.inlineStr = inlineStr;
    }
    if (styleId != null) {
      style = styleId;
    }
  }

  Map<String, String> get attributes {
    var attribs = <String, String>{};

    attribs['r'] = cellName.toString();
    if (type != null) {
      attribs['t'] = type.toString();
    }

    if (style != null) {
      attribs['s'] = style.toString();
    }
    if (value != null) {
      attribs['v'] = value.toString();
    }
    return attribs;
  }

  void createXmlElement(xml.XmlBuilder builder) {
    builder.element(tagName, attributes: attributes, nest: () {
      inlineStr?.createXmlElement(builder);
    });
  }
}

//esta class serve para definir configurações globais de uma coluna
//<col min="1" max="1" width="18" bestFit="1" customWidth="1" />
class Col {
  String tagName = 'col';
  int min = 1;
  int max = 1;
  int width = 18;
  int bestFit = 1;
  int customWidth = 1;
  int style;

  Map<String, String> get attributes {
    var attribs = <String, String>{};
    if (min != null) {
      attribs['min'] = min.toString();
    }
    if (max != null) {
      attribs['max'] = max.toString();
    }
    if (width != null) {
      attribs['width'] = width.toString();
    }
    if (bestFit != null) {
      attribs['bestFit'] = bestFit.toString();
    }
    if (style != null) {
      attribs['style'] = style.toString();
    }
    return attribs;
  }

  void createXmlElement(xml.XmlBuilder builder) {
    builder.element(tagName, attributes: attributes);
  }
}

//esta class é uma lista de Col a class que defini confirações
class Cols {
  String tagName = 'cols';
  List<Col> cols;
  void createXmlElement(xml.XmlBuilder builder) {
    builder.element(tagName, nest: () {
      cols?.forEach((child) {
        child?.createXmlElement(builder);
      });
    });
  }
}
