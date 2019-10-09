import 'package:xml/xml.dart' as xml;
import 'relationship.dart';


class Relationships { 
  List<Relationship> children;  

   Map<String, String> namespaces = {
    "http://schemas.openxmlformats.org/package/2006/relationships": ""   
  };

  Relationships({this.children});

  toStringXml() {
    var builder = xml.XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8" standalone="yes"');
    builder.element('Relationships', namespaces: namespaces, nest: () {
      children?.forEach((i) {
        i.createXmlElement(builder);
      });
    });
    var relationshipsXml = builder.build();
    var result = relationshipsXml.toXmlString(pretty: true);
    print(result);
    return result;
  }
 
  Relationships.fromMap(Map<String, dynamic> map) {    
    if (map.containsKey('Relationships')) {
      var list = map['Relationships'];
      if (list != null && list is List) {
        var l = List<Relationship>();
        list.forEach((v) {
          l.add(Relationship.fromMap(v));
        });
      }
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};   
    if (children != null) {
      map['Relationships'] = this.children.map((r) {
        return r.toMap();
      }).toList();
    }

    return map;
  }
}
