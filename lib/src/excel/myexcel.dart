/*import 'dart:convert';

import 'package:intl/intl.dart';

class MyExcel {
  List<String> borderKind = ['left', 'right', 'top', 'bottom'];
  // Not implementing diagonal borders, as they require an additonal attributes: diagonalUp diagonalDown
  List<String> horAlign = ['LEFT', 'CENTER', 'RIGHT', 'NONE'];
  List<String> vertAlign = ['TOP', 'CENTER', 'BOTTOM', 'NONE'];
  Map align = {'L': 'left', 'C': 'center', 'R': 'right', 'T': 'top', 'B': 'bottom', 'W': 'wrapText'};

  dynamic componentToHex(int c) {
    var hex = c.toRadixString(16);
    return hex.length == 1 ? '0' + hex : hex;
  }

  String rgbToHex(int r, int g, int b) {
    if (r == null || g == null || b == null) return null;
    return (componentToHex(r) + componentToHex(g) + componentToHex(b)).toUpperCase();
  }

  dynamic toExcelUTCTime(DateTime date1) {
    //javascript = new Date().getTime() = DateTime.now().millisecondsSinceEpoch
    var d2 = (date1.millisecondsSinceEpoch / 1000).floor(); // Number of seconds since JS epoch
    d2 = (d2 / 86400).floor() + 25569; // Days since epoch plus difference in days between Excel EPOCH and JS epoch
    //getUTCSeconds
    var utcSeconds = int.tryParse(DateFormat('s').format(date1));
    var utcMinutes = int.tryParse(DateFormat('m').format(date1));
    var utcHours = int.tryParse(DateFormat('H').format(date1));
    var seconds = utcSeconds + 60 * utcMinutes + 60 * 60 * utcHours; // Number of seconds of received hour
    var SECS_DAY = 60 * 60 * 24; // Number of seconds of a day
    return d2 + (seconds / SECS_DAY); // Returns a local time !!
  }

  // For styles see page 2127-2143 of the standard at
  // http://www.ecma-international.org/news/TC45_current_work/Office%20Open%20XML%20Part%204%20-%20Markup%20Language%20Reference.pdf

  List<String> BuiltInFormats = [];
  int baseFormats = 166; // Formats below this one are builtInt
  List<String> borderStyles = [
    'none',
    'thin',
    'medium',
    'dashed',
    'dotted',
    'thick',
    'double',
    'hair',
    'mediumDashed',
    'dashDot',
    'mediumDashDot',
    'dashDotDot',
    'mediumDashDotDot',
    'slantDashDot'
  ];
  var formats; //formats = BuiltInFormats
  List<String> borderStylesUpper = [];

  String reUnescapedHtml = "[&<>\"']";
  var reHasUnescapedHtml = RegExp("[&<>\"']");
  var htmlEscapes = {'&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'};

  dynamic basePropertyOf(object) {
    return (key) {
      return object == null ? null : object[key];
    };
  }

  var escapeHtmlChar;

  MyExcel() {
    escapeHtmlChar = basePropertyOf(htmlEscapes);

    for (var i = 0; i < borderStyles.length; i++) {
      borderStylesUpper.add(borderStyles[i].toUpperCase());
    }

    BuiltInFormats = List<String>.generate(166, (int index) => 's');

    BuiltInFormats[0] = 'General';
    BuiltInFormats[1] = '0';
    BuiltInFormats[2] = '0.00';
    BuiltInFormats[3] = '#,##0';
    BuiltInFormats[4] = '#,##0.00';

    BuiltInFormats[9] = '0%';
    BuiltInFormats[10] = '0.00%';
    BuiltInFormats[11] = '0.00E+00';
    BuiltInFormats[12] = '# ?/?';
    BuiltInFormats[13] = '# ??/??';
    BuiltInFormats[14] = 'mm-dd-yy';
    BuiltInFormats[15] = 'd-mmm-yy';
    BuiltInFormats[16] = 'd-mmm';
    BuiltInFormats[17] = 'mmm-yy';
    BuiltInFormats[18] = 'h:mm AM/PM';
    BuiltInFormats[19] = 'h:mm:ss AM/PM';
    BuiltInFormats[20] = 'h:mm';
    BuiltInFormats[21] = 'h:mm:ss';
    BuiltInFormats[22] = 'm/d/yy h:mm';

    BuiltInFormats[27] = '[\$-404]e/m/d';
    BuiltInFormats[30] = 'm/d/yy';
    BuiltInFormats[36] = '[\$-404]e/m/d';

    BuiltInFormats[37] = '#,##0 ;(#,##0)';
    BuiltInFormats[38] = '#,##0 ;[Red](#,##0)';
    BuiltInFormats[39] = '#,##0.00;(#,##0.00)';
    BuiltInFormats[40] = '#,##0.00;[Red](#,##0.00)';

    BuiltInFormats[44] = '_("\$"* #,##0.00_);_("\$"* \(#,##0.00\);_("\$"* "-"??_);_(@_)';
    BuiltInFormats[45] = 'mm:ss';
    BuiltInFormats[46] = '[h]:mm:ss';
    BuiltInFormats[47] = 'mmss.0';
    BuiltInFormats[48] = '##0.0E+0';
    BuiltInFormats[49] = '@';

    BuiltInFormats[50] = '[\$-404]e/m/d';
    BuiltInFormats[57] = '[\$-404]e/m/d';
    BuiltInFormats[59] = 't0';
    BuiltInFormats[60] = 't0.00';
    BuiltInFormats[61] = 't#,##0';
    BuiltInFormats[62] = 't#,##0.00';
    BuiltInFormats[67] = 't0%';
    BuiltInFormats[68] = 't0.00%';
    BuiltInFormats[69] = 't# ?/?';
    BuiltInFormats[70] = 't# ??/??';
    BuiltInFormats[165] = '*********'; // Here we start with non hardcoded formats

    formats = BuiltInFormats;
  }

  Map init() {
    var excel = {};

    var sheets = createSheets(); //  Create Excel  sheets
    var styles = createStyleSheet(); //  Create Styles   sheet
    sheets['add']('Sheet 0'); // At least we have a [Sheet 0]

    excel['addSheet'] = (String name) {
      name ??= 'Sheet ' + sheets.length;
      return sheets.add(name);
    };

    excel['addStyle'] = (a) {
      return styles.add(a);
    };

    // excel.set is the main function to generate content:
    // 		We can use parameter notation excel.set(sheetValue,columnValue,rowValue,cellValue,styleValue)
    // 		Or object notation excel.set({sheet:sheetValue,column:columnValue,row:rowValue,value:cellValue,style:styleValue })
    // 		null or 0 are used as default values for undefined entries
    excel['set'] = (s, int column, int row, value, style, colspan) {
      // If using Object form, expand it
      s ??= 0; // Use default sheet
      s = sheets['get'](s);
      // If this is a sheet operation
      /*if (!isNumeric(column) && !isNumeric(row)) {
        return s['set'](value, style);
      }*/
      //if (isNumeric(column)) {
      // If this is a column operation
      //if (isNumeric(row)) {
      var isstring = style != null && styles['getStyle'](style - 1)['isstring'];
      return setCell(s['getCell'](column, row), value, style, isstring,
          colspan); // and also a ROW operation the this is a CELL operation
      // }
      // return setColumn(s.getColumn(column), value, style); // if not we confirm than this is a COLUMN operation
      //}
      //return setRow(s.getRow(row), value, style); // If got here, thet this is a Row operation
    };

    excel['freezePane'] = (s, x, y) {
      sheets.get(s).freezePane(x, y);
    };

    excel['generate'] = (filename) {
      /*CombineStyles(sheets.sheets, styles);
            var zip =  JSZip();                                                                              // Create a ZIP file
            zip.file('_rels/.rels', sheets.toRels());                                                           // Add WorkBook RELS
            var xl = zip.folder('xl');                                                                          // Add a XL folder for sheets
            xl.file('workbook.xml', sheets.toWorkBook());                                                       // And a WorkBook
            xl.file('styles.xml', styles.toStyleSheet());                                                       // Add styles
            xl.file('_rels/workbook.xml.rels', sheets.toWorkBookRels());                                        // Add WorkBook RELs
            zip.file('[Content_Types].xml', sheets.toContentType());                                            // Add content types
            sheets.fileData(xl);                                                                                // Zip the rest
            zip.generateAsync({ type: "blob",mimeType:"application/vnd.ms-excel" }).then( (content) { saveAs(content, filename); });        // And generate !!!
            */
    };
    return excel;
  }

  var templateSheet =
      '''<?xml version="1.0" ?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" 
      xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mv="urn:schemas-microsoft-com:mac:vml" 
      xmlns:mx="http://schemas.microsoft.com/office/mac/excel/2008/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" 
      xmlns:x14="http://schemas.microsoft.com/office/spreadsheetml/2009/9/main" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac" 
      xmlns:xm="http://schemas.microsoft.com/office/excel/2006/main"> 
      {views}{columns}
      <sheetData>{rows}</sheetData>{mergeCells}</worksheet>''';

  // --------------------- BEGIN of generic UTILS

  int findOrAdd(List list, dynamic value) {
    var i = list.indexOf(value);
    if (i != -1) return i;
    list.add(value);
    return list.length - 1;
  }

  dynamic pushV(List list, dynamic value) {
    list.add(value);
    return value;
  }

  dynamic pushI(List list, dynamic value) {
    list.add(value);
    return list.length - 1;
  }

  dynamic setV(list, int index, dynamic value) {
    list[index] = value;
    return value;
  }
  // --------------------- END of generic UTILS

  // --------------------- BEGIN Handling of sheets
  String toWorkBookSheet(sheet) {
    return '<sheet state="visible" name="${sheet.name}" sheetId="${sheet.id}" r:id="${sheet.rId}"/>';
  }

  String toWorkBookRel(sheet, i) {
    return '<Relationship Id="${sheet.rId}" Target="worksheets/sheet${i}.xml" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet"/>';
  }

  String getAsXml(sheet) {
    return templateSheet
        .replaceAll('{views}', generateViews(sheet['views']))
        .replaceAll('{columns}', generateColums(sheet['columns']))
        .replaceAll('{rows}', generateRows(sheet['rows'], sheet['mergeCells']))
        .replaceAll('{mergeCells}', generateMergeCells(sheet['mergeCells']));
  }

  String name;
  List rows = [];
  List columns = [];
  List sheets = [];
  List views = [];

  // ------------------- BEGIN Sheet DATA Handling
  void setSheet(value, style, size) {
    name = value; // The only think that we can set in a sheet Is the name
  }

  dynamic getRow(y) {
    return (rows[y]
        ? rows[y]
        : setV(rows, y, {'cells': []})); // If there is a row return it, otherwise create it and return it
  }

  dynamic getColumn(x) {
    return (columns[x]
        ? columns[x]
        : setV(columns, x, {})); // If there is a column return it, otherwise create it and return it
  }

  dynamic getCell(x, y) {
    var row = getRow(y).cells; // Get the row a,d its DATA component
    return (row[x] ? row[x] : setV(row, x, {}));
  }

  void setCell(cell, value, style, isstring, colspan) {
    if (value != null) cell.v = value;
    cell.isstring = isstring;
    if (style) cell.s = style;
    if (colspan) cell.colspan = colspan;
  }

  void setColumn(column, value, style) {
    if (value != null) column.wt = value;
    if (style) column.style = style;
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    // ignore: deprecated_member_use
    return double.parse(s, (e) => null) != null;
  }

  void setRow(row, value, style) {
    if (value && isNumeric(value)) row['ht'] = value;
    if (style) row['style'] = style;
  }

  void freezePane(x, y) {
    var pane = {'topLeftCell': cellName(x, y)};
    if (x >= 0) {
      pane['xSplit'] = x;
    }
    if (y >= 0) {
      pane['ySplit'] = y - 1;
    }
    var view = {
      'panes': [pane]
    };
    view['workbookViewId'] = pushI(views, view);
  }
  // ------------------- END Sheet DATA Handling

  createSheets() {
    var oSheets = {
      'sheets': [],
      'add': (name) {
        var sheet = {
          'id': sheets.length + 1,
          'rId': 'rId' + (3 + sheets.length).toString(),
          'name': name,
          'rows': [],
          'columns': [],
          'getColumn': getColumn,
          'set': setSheet,
          'getRow': getRow,
          'getCell': getCell,
          'mergeCells': [],
          'views': [],
          'freezePane': freezePane
        };
        return pushI(sheets, sheet);
      },
      'get': (index) {
        var sheet = sheets[index];
        if (sheet == null) throw Exception('Bad sheet $index');
        return sheet;
      },
      'rows': (i) {
        if (i < 0 || i >= sheets.length) {
          throw Exception('Bad sheet number must be [0..' + (sheets.length - 1).toString() + '] and is: ' + i);
        }
        return sheets[i].rows;
      },
      'setWidth': (sheet, column, value, style) {
        // See 3.3.1.12 col (Column Width & Formatting
        if (value) sheets[sheet].colWidths[column] = !isNumeric(value) ? value.toString().toLowerCase() : value;
        if (style) sheets[sheet].colStyles[column] = style;
      },
      'toWorkBook': () {
        var s = '''<?xml version="1.0" standalone="yes"?>
            <workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
            <sheets>''';
        for (var i = 0; i < sheets.length; i++) {
          s = s + toWorkBookSheet(sheets[i]);
        }
        return s + '</sheets><calcPr/></workbook>';
      },
      'toWorkBookRels': () {
        var s =
            '<?xml version="1.0" ?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">';
        s = s +
            '<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>'; // rId2 is hardcoded and reserved for STYLES
        for (var i = 0; i < sheets.length; i++) {
          s = s + toWorkBookRel(sheets[i], i + 1);
        }
        return s + '</Relationships>';
      },
      'toRels': () {
        var s =
            '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">';
        s = s +
            '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>'; // rId1 is reserverd for WorkBook
        return s + '</Relationships>';
      },
      'toContentType': () {
        var s =
            '<?xml version="1.0" standalone="yes" ?><Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default ContentType="application/xml" Extension="xml"/>';
        s = s + '<Default ContentType="application/vnd.openxmlformats-package.relationships+xml" Extension="rels"/>';
        s = s +
            '<Override ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml" PartName="/xl/workbook.xml"/>';
        s = s +
            '<Override ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml" PartName="/xl/styles.xml" />';
        for (var i = 1; i <= sheets.length; i++) {
          s = s +
              '<Override ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml" PartName="/xl/worksheets/sheet$i.xml"/>';
        }
        return s + '</Types>';
      },
      'fileData': (xl) {
        for (var i = 0; i < sheets.length; i++) {
          xl.file('worksheets/sheet${(i + 1)}.xml', getAsXml(sheets[i]));
        }
      }
    };
    return oSheets;
  }
  // --------------------- END Handling of sheets

  // --------------------- BEGIN Handling of style
  toFontXml(String fi) {
    var f = fi.split(";");
    return '<font>' +
        (f[3].indexOf("B") > -1 ? '<b />' : '') +
        (f[3].indexOf("I") > -1 ? '<i />' : '') +
        (f[3].indexOf("U") > -1 ? '<u />' : '') +
        (f[1] != "_" ? '<sz val="' + f[1] + '" />' : '') +
        (f[2] != "_" ? '<color rgb="FF' + f[2] + '" />' : '') +
        (f[0] != null ? '<name val="' + f[0] + '" />' : '') +
        '</font>'; // <family val="2" /><scheme val="minor" />
  }

  toFillXml(f) {
    return '<fill><patternFill patternType="solid"><fgColor rgb="FF$f" /><bgColor indexed="64" /></patternFill ></fill>';
  }

  toBorderXml(String bi) {
    var s = "<border>";
    var b = bi.split(",");
    for (var i = 0; i < 4; i++) {
      var vals = b[i].split(" ");
      s = s + "<" + borderKind[i];
      if (vals[0] == "NONE")
        s = s + "/>";
      else {
        var border = borderStyles[borderStylesUpper.indexOf(vals[0])];
        if (border != null)
          s = s +
              ' style="' +
              border +
              '" >' +
              (vals[1] != "NONE" ? '<color rgb="FF' + vals[1].substring(1) + '"/>' : '');
        else
          s = s + ">";
        s = s + "</" + borderKind[i] + ">";
      }
    }
    return s + "<diagonal/></border>";
  }

  replaceAll(where, search, replacement) {
    return where.split(search).join(replacement);
  }

  replaceAllMultiple(where, search, replacement) {
    while (where.indexOf(search) != -1) where = replaceAll(where, search, replacement);
    return where;
  }

  createKey(style) {
    if (style["key"] == null) {
      style["key"] = JsonEncoder().convert(style);
    }
  }

  toStyleXml(style) {
    var alignXml = "";
    if (style.align) {
      var h = align[style.align.charAt(0)];
      var v = align[style.align.charAt(1)];
      var w = align[style.align.charAt(2)];
      if (h || v || w) {
        alignXml = "<alignment ";
        if (h) alignXml = alignXml + ' horizontal="' + h + '" ';
        if (v) alignXml = alignXml + ' vertical="' + v + '" ';
        if (w) alignXml = alignXml + ' ' + w + '="1" ';
        alignXml = alignXml + " />";
      }
    }
    var s = '<xf numFmtId="' +
        (style.format == null ? '0' : style.format).toString() +
        '" fontId="' +
        (style.font == null ? '0' : style.font).toString() +
        '" fillId="' +
        (style.fill == null ? '0' : style.fill).toString() +
        '" borderId="' +
        (style.border == null ? '0' : style.border).toString() +
        '" xfId="0" ';

    if ((style.border == null ? 0 : style.border) != 0) s = s + ' applyBorder="1" ';
    if (style.format >= baseFormats) s = s + ' applyNumberFormat="1" ';
    if ((style.fill == null ? 0 : style.fill) != 0) s = s + ' applyFill="1" ';
    if ((alignXml == null ? "" : alignXml) != "") s = s + ' applyAlignment="1" ';
    s = s + '>';
    s = s + alignXml;
    return s + "</xf>";
  }

  List<T> splice<T>(List<T> list, int index, [num howMany = 0, /*<T | List<T>>*/ elements]) {
    var endIndex = index + howMany.truncate();
    list.removeRange(index, endIndex >= list.length ? list.length : endIndex);
    if (elements != null) list.insertAll(index, elements is List<T> ? elements : <T>[elements]);
    return list;
  }

// Delete any "none" that we might have
  deleteAnyNone(list) {
    List<String> list3 = [];
    list.forEach((item) {
      if (item != "none") {
        list3.add(item);
        //print('forEach Delete any "none" that we might have');
      }
    });
    return list3;
  }

  //esta função esta revisada e ok
  //ela recebe isto "Calibri light 10 #333333"
  //e retorna isto Calibri Light;10;333333;_
  String normalizeFont(String fontDescription) {
    fontDescription = replaceAllMultiple(fontDescription, "  ", " ");
    var fNormalized = ["_", "_", "_", "_"]; //Name - Size - Color - Style (use NONE as placeholder)
    List<String> list = fontDescription.split(" "); //Split by " "
    var name = [];
    List<String> list2 = [];
    list.forEach((item) {
      if (item != null && (item != "none") && (!isNumeric(item)) && (charAt(item, 0) != "#")) {
        name.add(charAt(item, 0).toUpperCase() + item.substring(1).toLowerCase());
      } else {
        list2.add(item);
      }
    });
    list = list2;
    fNormalized[0] = name.join(" ");
    // Delete any "none" that we might have
    list = deleteAnyNone(list);
    //pega a cor #333333
    if (isNumeric(list[0])) {
      // IF we have a number then this is the font size
      fNormalized[1] = list[0];
      //list = [list.last];
      splice(list, 0, 1);
    }
    // Delete any "none" that we might have
    list = deleteAnyNone(list);
    // IF we have a 6 digits value it must be the color
    if (list[0] != null && list[0].length == 7 && charAt(list[0], 0) == "#") {
      fNormalized[2] = list[0].substring(1).toUpperCase();
      splice(list, 0, 1);
    }
    // Delete any "none" that we might have
    list = deleteAnyNone(list);
    if (list.isNotEmpty && list[0] != null && list[0].length < 4) {
      fNormalized[3] = list[0].toUpperCase();
      // Finally get the STYLE
    }
    var result = fNormalized.join(";");
    return result;
    //return "Calibri Light;10;333333;_";
  }

  normalizeAlign(ai) {
    if (ai == null) return "---";
    var a = replaceAllMultiple(ai.toString() + " - - -", "  ", " ").trim().toUpperCase().split(" ");
    return a[0].charAt(0) + a[1].charAt(0) + a[2].charAt(0);
  }

  normalizeBorders(b) {
    b = replaceAllMultiple(b, "  ", " ").trim();
    var l = (b + ",NONE,NONE,NONE,NONE").split(",");
    var p = "";
    for (var i = 0; i < 4; i++) {
      l[i] = l[i].trim().toUpperCase();
      l[i] = ((l[i].substring(0, 4) == "NONE" ? "NONE" : l[i]).trim() + " NONE NONE NONE").trim();
      var st = l[i].split(" ");
      if (st[0].charAt(0) == "#") {
        st[2] = st[0];
        st[0] = st[1];
        st[1] = st[2];
      }
      p = p + st[0] + " " + st[1] + ",";
    }
    return p;
  }

  createStyleSheet([String defaultFont = "Calibri light 10 #333333"]) {
    var styles = [], fonts = [];
    var formats = splice(BuiltInFormats, 0);
    var borders = [], fills = [];

    var oStyles = {
      "add": (a) {
        var style = {"isstring": a["isstring"]};
        if (a["fill"] != null && charAt(a["fill"], 0) == "#")
          style["fill"] = 2 +
              findOrAdd(
                  fills,
                  a["fill"]
                      .toString()
                      .substring(1)
                      .toUpperCase()); // If there is a fill color add it, with a gap of 2, because of the TWO DEFAULT HARDCODED fills
        if (a["font"] != null) style["font"] = findOrAdd(fonts, normalizeFont(a["font"].toString().trim()));
        if (a["format"] != null) style["format"] = findOrAdd(formats, a["format"]);
        if (a["align"] != null) style["align"] = normalizeAlign(a["align"]);
        if (a["border"] != null)
          style["border"] =
              1 + findOrAdd(borders, normalizeBorders(a["border"].toString().trim())); // There is a HARDCODED border

        createKey(style);
        for (var i = styles.length - 1; i >= 0; i--) {
          if (styles[i]["key"] == style["key"]) return 1 + i;
        }
        return 1 + pushI(styles, style); // Add the style and return INDEX+1 because of the DEFAULT HARDCODED style
      }
    };

    if (defaultFont == null) {
      defaultFont = "Calibri Light 12 0000EE";
    }
    oStyles["add"]({"font": defaultFont});

    oStyles["register"] = (thisOne) {
      createKey(thisOne);

      for (var i = styles.length - 1; i >= 0; i--) {
        if (styles[i].key == thisOne.key) return i;
      }
      return pushI(styles, thisOne);
    };

    oStyles["getStyle"] = (a) {
      return styles[a];
    };

    oStyles["toStyleSheet"] = ([ss]) {
      return toStyleSheet(fonts, fills, borders, styles);
    };

    return oStyles;
  }

  toStyleSheet(fonts, fills, borders, styles) {
    var s = '<?xml version="1.0" encoding="utf-8"?><styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" ' +
        'xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac">';

    s = s + '<numFmts count="' + (formats.length - baseFormats).toString() + '">';
    for (var i = baseFormats; i < formats.length; i++)
      s = s + '<numFmt numFmtId="' + (i.toString()) + '" formatCode="' + formats[i] + '"/>';
    s = s + '</numFmts>';

    s = s +
        '<fonts count="' +
        (fonts.length).toString() +
        '" x14ac:knownFonts="1" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac">';
    for (var i = 0; i < fonts.length; i++)
      s = s +
          toFontXml(
              fonts[i]); //'<font><sz val="8" /><name val="Calibri" /><family val="2" /><scheme val="minor" /></font>' +
    s = s + '</fonts>';

    s = s +
        '<fills count="' +
        (2 + fills.length).toString() +
        '"><fill><patternFill patternType="none"/></fill><fill><patternFill patternType="gray125"/></fill>';
    for (var i = 0; i < fills.length; i++) s = s + toFillXml(fills[i]);
    s = s + '</fills>';

    s = s +
        '<borders count="' +
        (1 + borders.length).toString() +
        '"><border><left /><right /><top /><bottom /><diagonal /></border>';
    for (var i = 0; i < borders.length; i++) s = s + toBorderXml(borders[i]);
    s = s + '</borders>';

    s = s + '<cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>';

    s = s +
        '<cellXfs count="' +
        (1 + styles.length).toString() +
        '"><xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0" />';
    for (var i = 0; i < styles.length; i++) {
      s = s + toStyleXml(styles[i]);
    }
    s = s + '</cellXfs>';

    s = s + '<cellStyles count="1"><cellStyle name="Normal" xfId="0" builtinId="0"/></cellStyles>';
    s = s + '<dxfs count="0"/>';
    s = s + '</styleSheet>';
    return s;
  }

  // --------------------- END Handling of styles
  escape(string) {
    if (!string is String) string = null ? '' : (string + '');

    return (string && reHasUnescapedHtml.hasMatch(string)) ? string.replace(reUnescapedHtml, escapeHtmlChar) : string;
  }

  charAt(String value, int index) {
    if ((index < 0) || (index >= value.length)) {
      throw Exception("StringIndexOutOfBoundsException $index");
    }
    return value[index];
  }

  cellNameH(i) {
    var rest = (i / 26).floor - 1;
    var s = (rest > -1 ? cellNameH(rest) : '');
    return s + charAt("ABCDEFGHIJKLMNOPQRSTUVWXYZ", (i % 26));
  }

  cellName(colIndex, rowIndex) {
    return cellNameH(colIndex) + rowIndex;
  }

  generateCell(cell, column, row, mergeCells) {
    if (cell["colspan"] > 1) {
      var m = {"from": cellName(column, row), "to": cellName(column + cell["colspan"] - 1, row)};
      mergeCells["add"](m);
    }
    var s = '<c r="' + cellName(column, row) + '"';
    if (cell["s"]) s = s + ' s="' + cell["s"] + '" ';

    var value = cell["v"];
    if (cell["isstring"] != null || !isNumeric(value)) {
      if (cell["isstring"] != null || charAt(value, 0) != '=')
        return s + ' t="inlineStr" ><is><t>' + escape(value) + '</t></is></c>';
      return s + ' ><f>' + value.substring(1) + '</f></c>';
    }
    return s + '><v>' + value + '</v></c>';
  }

  generateRow(row, index, mergeCells) {
    var rowIndex = index + 1;
    var oCells = [];
    for (var i = 0; i < row.cells.length; i++) {
      if (row.cells[i]) oCells.add(generateCell(row.cells[i], i, rowIndex, mergeCells));
    }
    var s = '<row r="' + rowIndex + '" ';
    if (row.ht) s = s + ' ht="' + row.ht + '" customHeight="1" ';
    if (row.style) s = s + 's="' + row.style + '" customFormat="1"';
    return s + ' >' + oCells.join('') + '</row>';
  }

  generateMergeCells(mergeCells) {
    if (mergeCells.length == 0) return null;

    var s = '<mergeCells count="' + mergeCells.length + '">';
    for (var i = 0; i < mergeCells.length; i++) {
      var m = mergeCells[i];
      if (m) {
        s = s + '<mergeCell ref="' + m.from + ':' + m.to + '" />';
      }
    }
    return s + "</mergeCells>";
  }

  generateRows(rows, mergeCells) {
    var oRows = [];
    for (var index = 0; index < rows.length; index++) {
      if (rows[index]) {
        oRows.add(generateRow(rows[index], index, mergeCells));
      }
    }
    return oRows.join('');
  }

  generateColums(columns) {
    if (columns.length == 0) return null;

    var s = '<cols>';
    for (var i = 0; i < columns.length; i++) {
      var c = columns[i];
      if (c) {
        s = s + '<col min="${(i + 1)}" max="${(i + 1)}" ';
        if (c.wt == "auto")
          s = s + ' width="18" bestFit="1" customWidth="1" ';
        else if (c.wt) s = s + ' width="' + c.wt + '" customWidth="1" ';
        if (c.style) s = s + ' style="' + c.style + '"';
        s = s + "/>";
      }
    }
    return s + "</cols>";
  }

  generateViews(views) {
    if (views.length == 0) return null;
    var s = '<sheetViews>';
    for (var i = 0; i < views.length; i++) {
      var c = views[i];
      if (c && c.panes && c.panes.length) {
        s += '<sheetView workbookViewId="${(c.workbookViewId == null ? i : c.workbookViewId)}">';
        for (var p = 0; p < c.panes.length; p++) {
          var pane = c.panes[p];
          s += '<pane state="frozen" topLeftCell="' + pane.topLeftCell + '"';
          if (pane.xSplit) {
            s += ' xSplit="' + pane.xSplit + '"';
          }
          if (pane.ySplit) {
            s += ' ySplit="' + pane.ySplit + '"';
          }
          s += '/>';
        }
        s += '</sheetView>';
      }
    }
    s += "</sheetViews>";
    return s;
  }

  /*isObject(v) {
        return (v != null && typeof v == 'object');
    }*/

  //  Loops all rows & columns in sheets.
  //  If a row has a style it tries to apply the style componenets to all cells in the row (provided that the cell has not defined is not own style component)

  CombineStyles(sheets, styles) {
    // First lets do the sheets
    for (var i = 0; i < sheets.length; i++) {
      // First let's do the rows
      for (var j = 0; j < sheets[i].rows.length; j++) {
        var row = sheets[i].rows[j];
        if (row && row.style) {
          for (var k = 0; k < row.cells.length; k++) {
            if (row.cells[k]) AddStyleToCell(row.cells[k], styles, row.style);
          }
        }
      }

      // Second let's do the cols
      for (var c = 0; c < sheets[i].columns.length; c++) {
        if (sheets[i].columns[c] && sheets[i].columns[c].style) {
          var cstyle = sheets[i].columns[c].style;
          for (var j = 0; j < sheets[i].rows.length; j++) {
            var row = sheets[i].rows[j];
            if (row)
              for (var k = 0; k < row.cells.length; k++)
                if (row.cells[k] && k == c) AddStyleToCell(row.cells[k], styles, cstyle);
          }
        }
      }
    }
  }

  AddStyleToCell(cell, styles, toAdd) {
    if (!cell) return; // If no cell then return
    if (!cell.s) {
      // If cell has no style, use toAdd
      cell.s = toAdd;
      return;
    }
    var cs = styles.getStyle(cell.s - 1);
    var os = styles.getStyle(toAdd - 1);
    var ns = {}, b = false;
    for (var x in cs) ns[x] = cs[x]; // Clone cell style
    for (var x in os) {
      if (!ns[x]) {
        ns[x] = os[x];
        b = true;
      }
    }
    if (!b) return; // If the toAdd style does NOT add anything new
    //delete ns.key; // the key should be recalculated, remove the key from any of the origin objects
    cell.s = 1 + styles.register(ns);
  }

  //metodo principal construtor
  construc(defaultFont) {
    var excel = {};

    var sheets = createSheets(); //  Create Excel  sheets
    var styles = createStyleSheet(defaultFont); //  Create Styles   sheet
    sheets["add"]("Sheet 0"); // At least we have a [Sheet 0]

    excel["addSheet"] = (String name) {
      if (name == null) name = "Sheet " + sheets.length;
      return sheets.add(name);
    };

    excel["addStyle"] = (a) {
      return styles.add(a);
    };

    // excel.set is the main function to generate content:
    // 		We can use parameter notation excel.set(sheetValue,columnValue,rowValue,cellValue,styleValue)
    // 		Or object notation excel.set({sheet:sheetValue,column:columnValue,row:rowValue,value:cellValue,style:styleValue })
    // 		null or 0 are used as default values for undefined entries
    excel["set"] = (s, column, row, value, style, colspan) {
      if (s is Map) {
        return excel["set"](s["sheet"], s["column"], s["row"], s["value"], s["style"]);
      } // If using Object form, expand it
      if (!s) s = 0; // Use default sheet
      s = sheets.get(s);
      if (!isNumeric(column) && !isNumeric(row)) return s.set(value, style); // If this is a sheet operation
      if (isNumeric(column)) {
        // If this is a column operation
        if (isNumeric(row)) {
          var isstring = style && styles.getStyle(style - 1)["isstring"];
          return setCell(s.getCell(column, row), value, style, isstring,
              colspan); // and also a ROW operation the this is a CELL operation
        }
        return setColumn(s.getColumn(column), value, style); // if not we confirm than this is a COLUMN operation
      }
      return setRow(s.getRow(row), value, style); // If got here, thet this is a Row operation
    };

    excel["freezePane"] = (s, x, y) {
      sheets.get(s).freezePane(x, y);
    };

    excel["generate"] = (filename) {
      /*CombineStyles(sheets.sheets, styles);
            var zip =  JSZip();                                                                              // Create a ZIP file
            zip.file('_rels/.rels', sheets.toRels());                                                           // Add WorkBook RELS
            var xl = zip.folder('xl');                                                                          // Add a XL folder for sheets
            xl.file('workbook.xml', sheets.toWorkBook());                                                       // And a WorkBook
            xl.file('styles.xml', styles.toStyleSheet());                                                       // Add styles
            xl.file('_rels/workbook.xml.rels', sheets.toWorkBookRels());                                        // Add WorkBook RELs
            zip.file('[Content_Types].xml', sheets.toContentType());                                            // Add content types
            sheets.fileData(xl);                                                                                // Zip the rest
            zip.generateAsync({ type: "blob",mimeType:"application/vnd.ms-excel" }).then( (content) { saveAs(content, filename); });        // And generate !!!
            */
    };
    return excel;
  }
}
*/
