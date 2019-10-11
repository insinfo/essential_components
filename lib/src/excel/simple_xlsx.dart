import 'dart:convert';

import 'package:archive/archive.dart';
//import 'package:archive/archive_io.dart';
import 'dart:html';

//models
import './models/doc_props/app.dart';
import './models/doc_props/core.dart';
import './models/rels/relationship.dart';
import './models/rels/relationships.dart';
import './models/xl/theme/theme.dart';
import './models/xl/shared_string.dart';
import './models/xl/workbook.dart';
import './models/xl/worksheets/worksheet.dart';
import './models/xl/style_sheet.dart';
import './models/content_types.dart';

class SimpleXLSX {
  SimpleXLSX() {}

  build() {
    //_rels/.rels
    var rootRels = Relationships();
    rootRels.addWorkbook();

    //[Content_Types].xml
    var contentTypes = ContentTypes();

    //xl
    //xl\_rels\workbook.xml.rels
    var xlRels = Relationships();
    xlRels.addStyle();
    xlRels.addWorksheet();
    xlRels.toStringXml();

    //xl\workbook.xml
    var workbook = Workbook();
    workbook.addSheet(Sheet(name: "Sheet 2", id: "rId3"));
    workbook.toStringXml();

    //xl\worksheets\sheet1.xml
    var worksheet = Worksheet();
    worksheet.addConlSettings(Col());
    var row = Row.getNew();
    row.addCellText('teste');
    worksheet.addRow(row);
    worksheet.toStringXml();

    //xl\styles.xml
    var styleSheet = StyleSheet();
    styleSheet.toStringXml();

    //
    /*
    var file_stream = InputFileStream.file(file);
    var f = ArchiveFile.stream(
    filename == null ? path.basename(file.path) : filename,
    file.lengthSync(),
    file_stream);
    */
    //var file =File(utf8.encode("Some data"), 'teste.xml');

    var rootRelsBytes = rootRels.toFileBytes();
    var contentTypesBytes = contentTypes.toFileBytes();
    var xlRelsBytes = xlRels.toFileBytes();
    var worksheetBytes = worksheet.toFileBytes();
    var workbookBytes = workbook.toFileBytes();
    var styleSheetBytes = styleSheet.toFileBytes();
    Archive archive = Archive();
    archive.addFile(ArchiveFile('_rels/.rels', rootRelsBytes.length, rootRelsBytes));
    archive.addFile(ArchiveFile('[Content_Types].xml', contentTypesBytes.length, contentTypesBytes));
    archive.addFile(ArchiveFile('xl/_rels/workbook.xml.rels', xlRelsBytes.length, xlRelsBytes));
    archive.addFile(ArchiveFile('xl/worksheets/sheet1.xml', worksheetBytes.length, worksheetBytes));
    archive.addFile(ArchiveFile('xl/workbook.xml', workbookBytes.length, workbookBytes));
    archive.addFile(ArchiveFile('xl/styles.xml', styleSheetBytes.length, styleSheetBytes));
    List<int> encodedzipdata = ZipEncoder().encode(archive);

    //encoder.addFile(archiveFile);
    //encoder.endEncode();
    //application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
    var blob = Blob([encodedzipdata], 'application/zip');
    var downloadUrl = Url.createObjectUrlFromBlob(blob);
    //List<int> listInt = data.map((i) => i.first).toList();
    // String encodedFileContents = Base64Encoder().convert(listInt);//Uri.encodeComponent("Hello World!");

    AnchorElement(href: downloadUrl)
      ..setAttribute("download", "dados.xlsx") //xlsx
      ..click();
  }

  //_rels\.rels
  createRelsOfXLSX() {
    var relationships = Relationships();
    relationships.addWorkbook();
    relationships.toStringXml();
  }

  //xl\_rels\workbook.xml.rels
  createRelsOfXl() {
    var relationships = Relationships();
    relationships.addStyle();
    relationships.addWorksheet();
    relationships.toStringXml();
  }

  //
  createTheme() {
    var theme = Theme();
    theme.toStringXml();
  }

  //
  createSharedString() {
    var sharedString = SharedString();
    sharedString.toStringXml();
  }
}
