//[Content_Types].xml

import 'dart:convert';

class ContentTypes {
  String toStringXml() {
    var contentTypes = '''<?xml version="1.0" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
    <Default ContentType="application/xml" Extension="xml" />
    <Default ContentType="application/vnd.openxmlformats-package.relationships+xml" Extension="rels" />
    <Override ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml" PartName="/xl/workbook.xml" />
    <Override ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml" PartName="/xl/styles.xml" />
    <Override ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml" PartName="/xl/worksheets/sheet1.xml" />
</Types>
     ''';

    return contentTypes;
  }

  List<int> toFileBytes() {
    return utf8.encode(toStringXml());
  }
}
