import 'package:xml/xml.dart' as xml;
import '../interface_xml_serializable.dart';
import 'dart:convert';

class Properties {
  Map<String, String> namespaces = {
    'http://schemas.openxmlformats.org/officeDocument/2006/extended-properties':
        '',
    'http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes':
        'vt',
  };
  String application = 'Microsoft Excel';
  int docSecurity = 0;
  bool scaleCrop = false;
  HeadingPairs headingPairs;
  TitlesOfParts titlesOfParts;
  String company = '';
  bool linksUpToDate = false;
  bool sharedDoc = false;
  bool hyperlinksChanged = false;
  String appVersion = '16.0300';
  String xmlns =
      'http://schemas.openxmlformats.org/officeDocument/2006/extended-properties';
  String xmlnsVt =
      'http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes';

  String toStringXml() {
    headingPairs = HeadingPairs();
    headingPairs.vector = Vector('variant');
    headingPairs.vector.children
        .add(Variant(children: [Lpstr(text: 'Planilhas')]));
    headingPairs.vector.children.add(Variant(children: [I4(text: '1')]));

    titlesOfParts = TitlesOfParts();
    titlesOfParts.vector = Vector('lpstr');
    titlesOfParts.vector.children.add(Lpstr(text: 'Planilha1'));

    var builder = xml.XmlBuilder();
    builder.processing(
        'xml', 'version="1.0" encoding="UTF-8" standalone="yes"');
    //Properties
    builder.element('Properties', namespaces: namespaces, nest: () {
      //Application
      builder.element('Application', nest: () {
        builder.text(application);
      });
      //docSecurity
      builder.element('DocSecurity', nest: () {
        builder.text(docSecurity);
      });
      //scaleCrop
      builder.element('ScaleCrop', nest: () {
        builder.text(scaleCrop);
      });
      //HeadingPairs
      headingPairs?.createXmlElement(builder);
      //titlesOfParts
      titlesOfParts?.createXmlElement(builder);
      //Company
      builder.element('Company', nest: () {
        builder.text(company);
      }, isSelfClosing: false);
      //linksUpToDate
      builder.element('LinksUpToDate', nest: () {
        builder.text(linksUpToDate);
      }, isSelfClosing: false);
      //SharedDoc
      builder.element('SharedDoc', nest: () {
        builder.text(sharedDoc);
      }, isSelfClosing: false);
      //HyperlinksChanged
      builder.element('HyperlinksChanged', nest: () {
        builder.text(hyperlinksChanged);
      }, isSelfClosing: false);
      //AppVersion
      builder.element('AppVersion', nest: () {
        builder.text(appVersion);
      }, isSelfClosing: false);
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

class Lpstr implements IXmlSerializable {
  String text;
  Lpstr({this.text});
  @override
  void createXmlElement(xml.XmlBuilder builder) {
    builder.element('vt:lpstr', nest: () {
      builder.text(text);
    });
  }
}

class I4 implements IXmlSerializable {
  String text;
  I4({this.text});
  @override
  void createXmlElement(xml.XmlBuilder builder) {
    builder.element('vt:i4', nest: () {
      builder.text(text);
    });
  }
}

class Variant implements IXmlSerializable {
  List<IXmlSerializable> children;
  Variant({children}) {
    if (children != null) {
      this.children = children;
    }
  }
  @override
  void createXmlElement(xml.XmlBuilder builder) {
    builder.element('vt:variant', nest: () {
      children?.forEach((child) {
        child?.createXmlElement(builder);
      });
    });
  }
}

class Vector {
  List<IXmlSerializable> children = [];
  int size;
  String baseType;

  Vector(this.baseType, {children}) {
    if (children != null) {
      this.children = children;
    }
  }

  void createXmlElement(xml.XmlBuilder builder) {
    builder.element('vt:vector', attributes: {
      'size': children?.length?.toString(),
      'baseType': baseType
    }, nest: () {
      children?.forEach((child) {
        child?.createXmlElement(builder);
      });
    });
  }
}

class HeadingPairs {
  Vector vector;
  void createXmlElement(xml.XmlBuilder builder) {
    builder.element('HeadingPairs', nest: () {
      if (vector != null) {
        vector.createXmlElement(builder);
      }
    });
  }
}

class TitlesOfParts {
  Vector vector;

  void createXmlElement(xml.XmlBuilder builder) {
    builder.element('TitlesOfParts', nest: () {
      if (vector != null) {
        vector.createXmlElement(builder);
      }
    });
  }
}
