//helpers.dart

class Helpers {
  String reUnescapedHtml = "[&<>\"']";
  var reHasUnescapedHtml = RegExp("[&<>\"']");
  var htmlEscapes = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#39;'
  };
  var escapeHtmlChar;

  static Helpers getInstance() {
    return Helpers();
  }

  String escape(string) {
    if (!string is String) string = null ? '' : (string + '');
    return (string && reHasUnescapedHtml.hasMatch(string))
        ? string.replace(reUnescapedHtml, escapeHtmlChar)
        : string;
  }

  String cellName(int colIndex, int rowIndex) {
    var r = cellNameH(colIndex) + rowIndex.toString();
    return r;
  }

  String cellNameH(int i) {
    var rest = (i / 26).floor() - 1;
    var s = (rest > -1 ? cellNameH(rest) : '');
    return s + charAt('ABCDEFGHIJKLMNOPQRSTUVWXYZ', (i % 26));
  }

  String charAt(String value, int index) {
    if ((index < 0) || (index >= value.length)) {
      throw Exception('StringIndexOutOfBoundsException $index');
    }
    return value[index];
  }
}
