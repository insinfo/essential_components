import 'package:xml/xml.dart' as xml;

class SharedString {
  int count;
  int uniqueCount;
  String tagName = 'sst';
  Map<String, String> namespaces = {
    "http://schemas.openxmlformats.org/spreadsheetml/2006/main": "",
  };

  toStringXml() {
    var builder = xml.XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8" standalone="yes"');
    //sst
    builder.element(tagName,
        namespace: "http://schemas.openxmlformats.org/spreadsheetml/2006/main",
        namespaces: namespaces,
        attributes: {"count": count.toString(), "uniqueCount": uniqueCount.toString()},
        nest: () {});
    var sstXml = builder.build();
    var result = sstXml.toXmlString(pretty: true);
    print(result);
    return result;
  }
}

class SharedStringItem {
  String tagName = 'si';
}

class SSItemText {
  String tagName = 't';
}
