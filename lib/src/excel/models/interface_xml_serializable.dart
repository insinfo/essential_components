import 'package:xml/xml.dart' as xml;

abstract class IXmlSerializable {
  void createXmlElement(xml.XmlBuilder builder);
}
