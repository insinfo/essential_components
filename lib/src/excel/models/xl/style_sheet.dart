import 'package:xml/xml.dart' as xml;

import 'dart:convert';

class StyleSheet {
  String tagName = 'styleSheet';
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
  String ignorable = 'x14ac x16r2 xr';

  Map<String, String> namespaces = {
    'http://schemas.openxmlformats.org/spreadsheetml/2006/main': '',
    'http://schemas.openxmlformats.org/markup-compatibility/2006': 'vt',
    'http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac': 'x14ac',
    'http://schemas.microsoft.com/office/spreadsheetml/2015/02/main': 'x16r2',
    'http://schemas.microsoft.com/office/spreadsheetml/2014/revision': 'xr'
  };

  StyleSheet();

  String toStringXml() {
    var result = '''<?xml version="1.0" encoding="utf-8"?>
<styleSheet
xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" 
xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" 
mc:Ignorable="x14ac" 
xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac">
    <numFmts count="1">
        <numFmt numFmtId="166" formatCode="yyyy.mm.dd hh:mm:ss" />
    </numFmts>
    <fonts count="3" x14ac:knownFonts="1" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac">
        <font>
            <sz val="10" />
            <color rgb="FF333333" />
            <name val="Calibri Light" />
        </font>
        <font>
            <b />
            <sz val="12" />
            <color rgb="FF0000AA" />
            <name val="Calibri" />
        </font>
        <font>
            <color rgb="FF00AA00" />
        </font>
    </fonts>
    <fills count="3">
        <fill>
            <patternFill patternType="none" />
        </fill>
        <fill>
            <patternFill patternType="gray125" />
        </fill>
        <fill>
            <patternFill patternType="solid">
                <fgColor rgb="FFECECEC" />
                <bgColor indexed="64" />
            </patternFill>
        </fill>
    </fills>
    <borders count="2">
        <border>
            <left />
            <right />
            <top />
            <bottom />
            <diagonal />
        </border>
        <border>
            <left />
            <right />
            <top />
            <bottom style="thin">
                <color rgb="FF333333" />
            </bottom>
            <diagonal />
        </border>
    </borders>
    <cellStyleXfs count="1">
        <xf numFmtId="0" fontId="0" fillId="0" borderId="0" />
    </cellStyleXfs>
    <cellXfs count="18">
        <xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0" />
        <xf numFmtId="undefined" fontId="0" fillId="undefined" borderId="undefined" xfId="0" applyBorder="1" applyFill="1"></xf>
        <xf numFmtId="undefined" fontId="undefined" fillId="undefined" borderId="1" xfId="0" applyBorder="1" applyFill="1"></xf>
        <xf numFmtId="undefined" fontId="undefined" fillId="2" borderId="1" xfId="0" applyBorder="1" applyFill="1"></xf>
        <xf numFmtId="undefined" fontId="1" fillId="undefined" borderId="1" xfId="0" applyBorder="1" applyFill="1"></xf>
        <xf numFmtId="166" fontId="2" fillId="undefined" borderId="undefined" xfId="0" applyBorder="1" applyNumberFormat="1" applyFill="1" applyAlignment="1">
            <alignment horizontal="right" />
        </xf>
        <xf numFmtId="undefined" fontId="undefined" fillId="undefined" borderId="undefined" xfId="0" applyBorder="1" applyFill="1" applyAlignment="1">
            <alignment horizontal="right" />
        </xf>
        <xf numFmtId="undefined" fontId="undefined" fillId="undefined" borderId="undefined" xfId="0" applyBorder="1" applyFill="1" applyAlignment="1">
            <alignment horizontal="left" vertical="top" />
        </xf>
        <xf numFmtId="undefined" fontId="undefined" fillId="undefined" borderId="undefined" xfId="0" applyBorder="1" applyFill="1" applyAlignment="1">
            <alignment horizontal="center" vertical="center" />
        </xf>
        <xf numFmtId="undefined" fontId="undefined" fillId="undefined" borderId="undefined" xfId="0" applyBorder="1" applyFill="1" applyAlignment="1">
            <alignment horizontal="right" vertical="bottom" />
        </xf>
        <xf numFmtId="166" fontId="2" fillId="2" borderId="1" xfId="0" applyBorder="1" applyNumberFormat="1" applyFill="1" applyAlignment="1">
            <alignment horizontal="right" />
        </xf>
        <xf numFmtId="166" fontId="2" fillId="undefined" borderId="1" xfId="0" applyBorder="1" applyNumberFormat="1" applyFill="1" applyAlignment="1">
            <alignment horizontal="right" />
        </xf>
        <xf numFmtId="undefined" fontId="undefined" fillId="2" borderId="1" xfId="0" applyBorder="1" applyFill="1" applyAlignment="1">
            <alignment horizontal="left" vertical="top" />
        </xf>
        <xf numFmtId="undefined" fontId="undefined" fillId="2" borderId="1" xfId="0" applyBorder="1" applyFill="1" applyAlignment="1">
            <alignment horizontal="center" vertical="center" />
        </xf>
        <xf numFmtId="undefined" fontId="undefined" fillId="2" borderId="1" xfId="0" applyBorder="1" applyFill="1" applyAlignment="1">
            <alignment horizontal="right" vertical="bottom" />
        </xf>
        <xf numFmtId="undefined" fontId="1" fillId="undefined" borderId="1" xfId="0" applyBorder="1" applyFill="1" applyAlignment="1">
            <alignment horizontal="right" />
        </xf>
        <xf numFmtId="undefined" fontId="undefined" fillId="2" borderId="1" xfId="0" applyBorder="1" applyFill="1" applyAlignment="1">
            <alignment horizontal="right" />
        </xf>
        <xf numFmtId="undefined" fontId="undefined" fillId="undefined" borderId="1" xfId="0" applyBorder="1" applyFill="1" applyAlignment="1">
            <alignment horizontal="right" />
        </xf>
    </cellXfs>
    <cellStyles count="1">
        <cellStyle name="Normal" xfId="0" builtinId="0" />
    </cellStyles>
    <dxfs count="0" />
</styleSheet>
    ''';
    return result;
  }

  void createXmlElement(xml.XmlBuilder builder) {
    builder.element(tagName,
        namespace: 'http://schemas.openxmlformats.org/spreadsheetml/2006/main',
        namespaces: namespaces,
        attributes: {'mc:Ignorable': ignorable}, nest: () {
      fonts.createXmlElement(builder);
    });
  }

  List<int> toFileBytes() {
    return utf8.encode(toStringXml());
  }
}

class Fonts {
  String tagName = 'fonts';
  int count;
  int knownFonts;
  List<Font> children = [];

  Fonts({children}) {
    if (children != null) {
      this.children = children;
    }
  }

  void createXmlElement(xml.XmlBuilder builder) {
    builder.element(tagName, attributes: {
      'count': children?.length?.toString(),
      'knownFonts': children?.length?.toString()
    }, nest: () {
      children?.forEach((child) {
        child?.createXmlElement(builder);
      });
    });
  }
}

class Font {
  String tagName = 'font';
  int sz;
  int theme;
  String name;
  int family;
  String scheme;

  void createXmlElement(xml.XmlBuilder builder) {
    builder.element(tagName, nest: () {
      builder.element('sz', attributes: {'val': sz.toString()});
      builder.element('theme', attributes: {'val': theme.toString()});
      builder.element('name', attributes: {'val': name});
      builder.element('family', attributes: {'val': family.toString()});
      builder.element('scheme', attributes: {'val': scheme});
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
