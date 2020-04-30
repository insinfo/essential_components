import 'package:xml/xml.dart' as xml;

class Relationship {
  String tagName = 'Relationship';
  String id;
  String type;
  String target;

  Relationship({this.id, this.type, this.target});

  String toStringXml() {
    var builder = xml.XmlBuilder();
    builder.processing(
        'xml', 'version="1.0" encoding="UTF-8" standalone="yes"');
    builder.element('Relationship',
        attributes: {'Id': id, 'Type': type, 'Target': target});
    var relationshipXml = builder.build();
    var result = relationshipXml.toXmlString(pretty: true);
    // print(result);
    return result;
  }

  void createXmlElement(xml.XmlBuilder builder) {
    builder.element('Relationship',
        attributes: {'Id': id, 'Type': type, 'Target': target});
  }

  Relationship.fromMap(Map<String, dynamic> map) {
    id = map.containsKey('Id') ? map['Id'] : null;
    type = map.containsKey('Type') ? map['Type'] : null;
    target = map.containsKey('Target') ? map['Target'] : null;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['Id'] = id;
    map['Type'] = type;
    map['Target'] = target;
    return map;
  }
}
