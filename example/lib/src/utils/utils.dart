import 'dart:math';
import 'package:intl/intl.dart';
import 'dart:html';
import 'dart:math' as math;

class Utils {
  static String truncate(String value, int truncateAt) {
    if (value == null) {
      return value;
    }
    //int truncateAt = value.length-1;
    String elepsis = "..."; //define your variable truncation elipsis here
    String truncated = "";

    if (value.length > truncateAt) {
      truncated = value.substring(0, truncateAt - elepsis.length) + elepsis;
    } else {
      truncated = value;
    }
    return truncated;
  }

  static List<int> randomizer(int size) {
    List<int> random = new List<int>();
    for (var i = 0; i < size; i++) {
      random.add(new Random().nextInt(9));
    }
    return random;
  }

  static String gerarCPF({bool formatted = false}) {
    List<int> n = randomizer(9);
    n..add(gerarDigitoVerificador(n))..add(gerarDigitoVerificador(n));
    return formatted ? formatCPF(n) : n.join();
  }

  static int gerarDigitoVerificador(List<int> digits) {
    int baseNumber = 0;
    for (var i = 0; i < digits.length; i++) {
      baseNumber += digits[i] * ((digits.length + 1) - i);
    }
    int verificationDigit = baseNumber * 10 % 11;
    return verificationDigit >= 10 ? 0 : verificationDigit;
  }

  static bool validarCPF(String cpf) {
    if (cpf == null) {
      return false;
    } else if (cpf == "") {
      return false;
    } else if (cpf.length < 11) {
      return false;
    }

    List<int> sanitizedCPF =
        cpf.replaceAll(new RegExp(r'\.|-'), '').split('').map((String digit) => int.parse(digit)).toList();

    if (blacklistedCPF(sanitizedCPF.join())) {
      return false;
    }

    var result = sanitizedCPF[9] == gerarDigitoVerificador(sanitizedCPF.getRange(0, 9).toList()) &&
        sanitizedCPF[10] == gerarDigitoVerificador(sanitizedCPF.getRange(0, 10).toList());

    return result;
  }

  static bool blacklistedCPF(String cpf) {
    return cpf == '11111111111' ||
        cpf == '22222222222' ||
        cpf == '33333333333' ||
        cpf == '44444444444' ||
        cpf == '55555555555' ||
        cpf == '66666666666' ||
        cpf == '77777777777' ||
        cpf == '88888888888' ||
        cpf == '99999999999';
  }

  static String formatCPF(List<int> n) =>
      '${n[0]}${n[1]}${n[2]}.${n[3]}${n[4]}${n[5]}.${n[6]}${n[7]}${n[8]}-${n[9]}${n[10]}';

  static String sanitizeCPF(String val) {
    return val?.replaceAll(new RegExp('[^0-9]'), '');
  }

  static bool isDate(String str) {
    try {
      //"dd/mm/yyyy"
      //DateFormat format = new DateFormat("dd/MM/yyyy");
      //var result = format.parse(str);
      //print(result);
      //DateTime.parse(str);
      var regexPattern =
          r'^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[1,3-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$';

      RegExp regExp = new RegExp(
        regexPattern,
        caseSensitive: false,
        multiLine: false,
      );

      if (regExp.hasMatch(str)) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static bool isNotNullOrEmpty(value) {
    return value != null && value != "null" && value != "";
  }

  static bool isNotNullOrEmptyAndContain(Map<String, dynamic> json, key) {
    return json.containsKey(key) && isNotNullOrEmpty(json[key]);
  }

  static void resizeImage(File file, int maxWidth, int maxHeight, Function func,
      [ImgResizeType type = ImgResizeType.fitWidthHeight, percentage = 0]) async {
    final fileName = file.name;
    FileReader reader = new FileReader();

    reader.onLoad.listen((fileEvent) {
      ImageElement img = document.createElement('img');
      img.src = reader.result;
      img.onLoad.listen((data) {
        Size originalSize = new Size(img.width, img.height);
        Size newSize;

        switch (type) {
          case ImgResizeType.percentage:
            newSize = new Size(
                (originalSize.width * percentage / 100).round(), (originalSize.height * percentage / 100).round());
            break;
          case ImgResizeType.fitWidth:
            newSize = fitIntoDimension(originalSize, new Size(maxWidth, 0));
            break;
          case ImgResizeType.fitHeight:
            newSize = fitIntoDimension(originalSize, new Size(0, maxHeight));
            break;
          case ImgResizeType.fitWidthHeight:
            var targetSize = new Size(maxWidth, maxHeight);
            newSize = fitIntoDimension(originalSize, targetSize);
            break;
          default:
            throw Exception("Unknown type $type");
        }

        /*// calc
        var widthRatio = maxWidth / imgWidth;
        var heightRatio = maxHeight / imgHeight;
        var bestRatio = math.min(widthRatio, heightRatio);
        // output
        var newWidth = (imgWidth * bestRatio).round();
        var newHeight = (imgHeight * bestRatio).round();*/

        CanvasElement canvas = document.createElement('canvas');
        canvas.width = newSize.width;
        canvas.height = newSize.height;

        CanvasRenderingContext2D ctx = canvas.context2D;
        ctx.drawImageScaled(img, 0, 0, newSize.width, newSize.height);
        ctx.canvas.toBlob("image/jpeg", 0.7).then((blob) {
          var out = new File([blob], fileName, {"type": 'image/jpeg', "lastModified": DateTime.now()});
          func(out);
        });
      });
    });
    reader.readAsDataUrl(file);
  }

  static Size fitIntoDimension(Size originalSize, Size targetSize, [bool round = true]) {
    var width, height;
    if (targetSize.width > 0 && targetSize.height > 0) {
      width = targetSize.width;
      height = width * originalSize.height / originalSize.width;
      if (height > targetSize.height) {
        height = targetSize.height;
        width = height * originalSize.width / originalSize.height;
      }
    } else if (targetSize.width > 0) {
      width = targetSize.width;
      height = width * originalSize.height / originalSize.width;
    } else {
      height = targetSize.height;
      width = height * originalSize.width / originalSize.height;
    }
    if (round == false)
      return new Size(width, height);
    else
      return new Size(width.round(), height.round());
  }

  static double brazilianMoneyToDouble(input) {
    if(input == null){
      return 0;
    }
    var i = input
        .toString()
        .substring(2)
        .replaceAll(',', '@')
        .replaceAll('.', '#')
        .replaceAll('@', '.')
        .replaceAll('#', ',').replaceAll(',','');       
    return double.tryParse(i);
  }
}

enum ImgResizeType { percentage, fitWidth, fitHeight, fitWidthHeight }

class Size {
  int width, height;
  Size(w, h) {
    this.width = w;
    this.height = h;
  }

  @override
  String toString() {
    return "width: $width, height: $height";
  }
}
