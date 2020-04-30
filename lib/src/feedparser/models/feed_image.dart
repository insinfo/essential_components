import 'package:xml/xml.dart' as xml;

class FeedImage {
  final String url;
  final String width;
  final String height;

  FeedImage(this.url, {this.width, this.height});

  factory FeedImage.fromXml(xml.XmlElement node) {
    // Mandatory fields:
    String url;
    try {
      url = node.findElements('url').single.text;
    } catch (e) {
      throw ArgumentError('Image missing mandatory url element');
    }

    // Optional fields:
    String width;
    try {
      width = node.findElements('width').single.text;
    } catch (e) {
      print(e);
    }

    String height;
    try {
      height = node.findElements('height').single.text;
    } catch (e) {
      print(e);
    }
    return FeedImage(url, width: width, height: height);
  }

  @override
  String toString() {
    return '''
      url: $url
      width: $width
      height: $height
      ''';
  }
}
