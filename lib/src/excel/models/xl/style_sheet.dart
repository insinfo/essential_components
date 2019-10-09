import 'package:xml/xml.dart' as xml;
import '../interface_xml_serializable.dart';

class StyleSheet {
  String tagName = "styleSheet";
  Fonts fonts;
  Fills fills;
  Borders borders;
  CellStyleXfs cellStyleXfs;
  CellXfs cellXfs;
  CellStyles cellStyles;
  Dxfs dxfs;
  TableStyles tableStyles;
  ExtLst extLst;
  String xmlns;
  String mc;
  String ignorable = "x14ac x16r2 xr";

  Map<String, String> namespaces = {
    "http://schemas.openxmlformats.org/spreadsheetml/2006/main": "",
    "http://schemas.openxmlformats.org/markup-compatibility/2006": "vt",
    "http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac": "x14ac",
    "http://schemas.microsoft.com/office/spreadsheetml/2015/02/main": "x16r2",
    "http://schemas.microsoft.com/office/spreadsheetml/2014/revision": "xr"
  };

  StyleSheet();

  createXmlElement(xml.XmlBuilder builder) {
    builder.element(tagName,
        namespace: "http://schemas.openxmlformats.org/spreadsheetml/2006/main",
        namespaces: namespaces,
        attributes: {"mc:Ignorable": ignorable}, nest: () {
      fonts.createXmlElement(builder);
    });
  }
}

class Fonts {
  String tagName = "fonts";
  int count;
  int knownFonts;
  List<Font> children = [];

  Fonts({children}) {
    if (children != null) {
      this.children = children;
    }
  }

  createXmlElement(xml.XmlBuilder builder) {
    builder.element(tagName,
        attributes: {"count": children?.length?.toString(), "knownFonts": children?.length?.toString()}, nest: () {
      children?.forEach((child) {
        child?.createXmlElement(builder);
      });
    });
  }
}

class Font {
  String tagName = "font";
  int sz;
  int theme;
  String name;
  int family;
  String scheme;

  createXmlElement(xml.XmlBuilder builder) {
    builder.element(tagName, nest: () {
      builder.element('sz', attributes: {"val": sz.toString()});
      builder.element('theme', attributes: {"val": theme.toString()});
      builder.element('name', attributes: {"val": name});
      builder.element('family', attributes: {"val": family.toString()});
      builder.element('scheme', attributes: {"val": scheme});
    });
  }
}

class PatternFill {
  String patternType;
}

class Fill {
  PatternFill patternFill;
}

class Fills {
  List<Fill> fill;
  String count;
}

class Border {
  String left;
  String right;
  String top;
  String bottom;
  String diagonal;
}

class Borders {
  Border border;
  String count;
}

class Xf {
  String numFmtId;
  String fontId;
  String fillId;
  String borderId;
  String xfId;
}

class CellStyleXfs {
  Xf xf;
  String count;
}

class CellXfs {
  Xf xf;
  String count;
}

class CellStyle {
  String name;

  String xfId;

  String builtinId;
}

class CellStyles {
  CellStyle cellStyle;

  String Count;
}

class Dxfs {
  String count;
}

class TableStyles {
  String count;
  String defaultTableStyle;
  String defaultPivotStyle;
}

class SlicerStyles {
  String defaultSlicerStyle;
}

class Ext {
  SlicerStyles slicerStyles;
  String Uri;
  String X14;
  TimelineStyles timelineStyles;
  String X15;
}

class TimelineStyles {
  String defaultTimelineStyle;
}

class ExtLst {
  List<Ext> sxt;
}
