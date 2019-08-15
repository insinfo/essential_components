import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';

@Component(
  selector: 'es-toast',
  templateUrl: 'toast.html',
  styleUrls: [
    'toast.css',
  ],
)
//A Material Design Toast component for AngularDart
class EssentialToastComponent implements OnInit {
  @ViewChild('toastDiv')
  DivElement toastDiv;

  Timer _timer;

  @Input()
  Duration duration = Duration(milliseconds: 2500);

  @Input()
  Duration animateTime = Duration(milliseconds: 250);

  String message;
  String color;

  @override
  void ngOnInit() {
    toastDiv.classes.add('mdt--load');
  }

  String _colorForType(ToastType type) {
    switch (type) {
      case ToastType.info:
        return '#4285f4';
      case ToastType.error:
        return '#db4437';
      case ToastType.warning:
        return '#f57f17';
      case ToastType.success:
        return '#0f9d58';
      case ToastType.normal:
      default:
        return '#212121';
    }
  }

  void showToast(String message, {ToastType type = ToastType.normal, String colorOverride}) {
    this.message = message;
    var color = _colorForType(type);

    if (colorOverride != null) {
      color = colorOverride;
    }

    toastDiv.style.backgroundColor = color;
    toastDiv.classes.remove('mdt--load');

    _timer?.cancel();
    _timer = Timer(duration, () {
      toastDiv.classes.add('mdt--load');
    });
  }
}

enum ToastType { normal, info, error, warning, success }
