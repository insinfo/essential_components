import 'package:xml/xml.dart' as xml;
import 'dart:convert';

//<cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties"
class CoreProperties {
  Map<String, String> namespaces = {
    'http://schemas.openxmlformats.org/package/2006/metadata/core-properties':
        'cp',
    'http://purl.org/dc/elements/1.1/': 'dc',
    'http://purl.org/dc/terms/': 'dcterms',
    'http://purl.org/dc/dcmitype/': 'dcmitype',
    'http://www.w3.org/2001/XMLSchema-instance': 'xsi',
  };
  // <dc:creator>isaque</dc:creator>
  String creator = 'isaque';
  //<cp:lastModifiedBy>isaque</cp:lastModifiedBy>
  String lastModifiedBy = 'isaque';
  //<dcterms:created xsi:type="dcterms:W3CDTF">2019-10-07T17:24:03Z</dcterms:created>
  Created created = Created();
  //<dcterms:modified xsi:type="dcterms:W3CDTF">2019-10-07T17:24:28Z</dcterms:modified>
  Modified modified = Modified();

  CoreProperties();

  String toStringXml() {
    var builder = xml.XmlBuilder();
    builder.processing(
        'xml', 'version="1.0" encoding="UTF-8" standalone="yes"');
    //coreProperties
    builder.element('coreProperties',
        namespace:
            'http://schemas.openxmlformats.org/package/2006/metadata/core-properties',
        namespaces: namespaces, nest: () {
      //creator
      builder.element('dc:creator', nest: () {
        builder.text(creator);
      });
      //lastModifiedBy
      builder.element('cp:lastModifiedBy', nest: () {
        builder.text(lastModifiedBy);
      });
      //created
      created.createXmlElement(builder);
      //modified
      modified.createXmlElement(builder);
    });
    var relationshipsXml = builder.build();
    var result = relationshipsXml.toXmlString(pretty: true);
    print(result);
    return result;
  }

  List<int> toFileBytes() {
    return utf8.encode(toStringXml());
  }
}

//<dcterms:created xsi:type="dcterms:W3CDTF">2019-10-07T17:24:03Z</dcterms:created>
class Created {
  String tagName = 'created';
  String type = 'dcterms:W3CDTF';
  String text = '2019-10-07T17:24:03Z';
  Map<String, String> namespaces = {'http://purl.org/dc/terms/': 'dcterms'};
  Created();

  void createXmlElement(xml.XmlBuilder builder) {
    builder.element('dcterms:created', attributes: {'xsi:type': type},
        nest: () {
      builder.text(text);
    });
  }

  @override
  String toString() {
    //return super.toString();
    return type;
  }
}

//<dcterms:modified xsi:type="dcterms:W3CDTF">2019-10-07T17:24:28Z</dcterms:modified>
class Modified {
  String tagName = 'modified';
  String type = 'dcterms:W3CDTF';
  String text = '2019-10-07T17:24:28Z';
  Map<String, String> namespaces = {'http://purl.org/dc/terms/': 'dcterms'};
  Modified();

  void createXmlElement(xml.XmlBuilder builder) {
    builder.element('dcterms:modified', attributes: {'xsi:type': type},
        nest: () {
      builder.text(text);
    });
  }

  @override
  String toString() {
    //return super.toString();
    return type;
  }
}
