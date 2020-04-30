import 'package:xml/xml.dart' as xml;

import 'feed_enclosure.dart';

class FeedItem {
  final String title;
  final String link;
  final String description;
  final String author;
  final String category;
  final FeedEnclosure enclosure;
  final String guid;
  final String pubDate;
  final String comments;
  final String itunesSummary;
  final String itunesDuration;

  FeedItem({
    this.title,
    this.link,
    this.description,
    this.author,
    this.category,
    this.enclosure,
    this.guid,
    this.pubDate,
    this.comments,
    this.itunesSummary,
    this.itunesDuration,
  });

  factory FeedItem.fromXml(xml.XmlElement node, bool strict) {
    // Optional fields:
    String title;
    try {
      title = node.findElements('title').single.text;
    } catch (e) {
      print(e);
    }

    String link;
    try {
      link = node.findElements('link').single.text;
    } catch (e) {
      print(e);
    }

    String description;
    try {
      description = node.findElements('description').single.text;
    } catch (e) {
      print(e);
    }

    String author;
    try {
      author = node.findElements('author').single.text;
    } catch (e) {
      print(e);
    }

    String category;
    try {
      category = node.findElements('category').single.text;
    } catch (e) {
      print(e);
    }

    String guid;
    try {
      guid = node.findElements('guid').single.text;
    } catch (e) {
      print(e);
    }

    String pubDate;
    try {
      pubDate = node.findElements('pubDate').single.text;
    } catch (e) {
      print(e);
    }

    xml.XmlElement enclosureElement;
    try {
      enclosureElement = node.findElements('enclosure').single;
    } catch (e) {
      print(e);
    }
    FeedEnclosure enclosure;
    if (enclosureElement != null) {
      enclosure = FeedEnclosure.fromXml(enclosureElement, strict);
    }

    String comments;
    try {
      comments = node.findElements('comments').single.text;
    } catch (e) {
      print(e);
    }

    // itunes fields:
    String itunesSummary;
    try {
      itunesSummary = node.findElements('itunes:summary').single.text;
    } catch (e) {
      print(e);
    }

    String itunesDuration;
    try {
      itunesDuration = node.findElements('itunes:duration').single.text;
    } catch (e) {
      print(e);
    }

    return FeedItem(
      title: title,
      link: link,
      description: description,
      author: author,
      category: category,
      enclosure: enclosure,
      guid: guid,
      pubDate: pubDate,
      comments: comments,
      itunesSummary: itunesSummary,
      itunesDuration: itunesDuration,
    );
  }

  @override
  String toString() {
    return '''
      title: $title
      link: $link
      description: $description
      author: $author
      category: $category
      guid: $guid
      pubDate: $pubDate
      comments: $comments
      itunes:summary: $itunesSummary
      itunes:duration: $itunesDuration
      enclosure: $enclosure
      ''';
  }
}
