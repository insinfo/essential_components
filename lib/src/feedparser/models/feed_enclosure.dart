import 'package:xml/xml.dart' as xml;

class FeedEnclosure {
  final String url;

  /// Size in bytes
  final String length;

  /// MIME type
  final String type;

  FeedEnclosure(this.url, this.length, this.type);

  factory FeedEnclosure.fromXml(xml.XmlElement node, bool strict) {
    // Mandatory fields:
    var url = node.getAttribute('url');
    if (url == null) {
      if (strict) {
        throw ArgumentError('Enclosure missing mandatory url attribute');
      }
    }

    var length = node.getAttribute('length');
    if (length == null) {
      if (strict) {
        throw ArgumentError('Enclosure missing mandatory length attribute');
      }
    }

    var type = node.getAttribute('type');
    if (type == null) {
      if (strict) {
        throw ArgumentError('Enclosure missing mandatory type attribute');
      }
    }

    return FeedEnclosure(url, length, type);
  }

  @override
  String toString() {
    return '''
      url: $url
      length: $length
      type: $type
      ''';
  }
}
