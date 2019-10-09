import 'package:xml/xml.dart' as xml;

class Relationship {
  String tagName = "Relationship";
  String id;
  String type;
  String target;

  Relationship({this.id, this.type, this.target});

  toStringXml() {
    var builder = xml.XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8" standalone="yes"');
    builder.element('Relationship', attributes: {'Id': this.id, "Type": this.type, "Target": this.target});
    var relationshipXml = builder.build();
    var result = relationshipXml.toXmlString(pretty: true);
    print(result);
    return result;
  }

  createXmlElement(xml.XmlBuilder builder) {
    builder.element('Relationship', attributes: {'Id': this.id, "Type": this.type, "Target": this.target});
  }

  Relationship.fromMap(Map<String, dynamic> map) {
    this.id = map.containsKey('Id') ? map['Id'] : null;
    this.type = map.containsKey('Type') ? map['Type'] : null;
    this.target = map.containsKey('Target') ? map['Target'] : null;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['Id'] = this.id;
    map['Type'] = this.type;
    map['Target'] = this.target;
    return map;
  }
}
