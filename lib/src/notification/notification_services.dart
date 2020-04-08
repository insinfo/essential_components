import 'dart:async';

import 'package:angular/angular.dart';

/// A service that manages toasts that should be displayed.
@Injectable()
class EssentialNotificationService {
  /// A list of toasts that should be displayed.
  List<Toast> toasts;

  /// Constructor.
  EssentialNotificationService() {
    toasts = [];
  }

  /// Display a toast.
  void add(String type, String title, String message, {String icon, num durationSeconds}) {
    var toast = Toast(type, title, message, icon, durationSeconds);
    toasts.insert(0, toast);
    var milliseconds = (1000 * toast.durationSeconds + 300).round();
    // How to get size of each toast?
    Timer(Duration(milliseconds: milliseconds), () {
      toast.toBeDeleted = true;
      Timer(Duration(milliseconds: 300), () {
        toasts.remove(toast);
      });
    });
  }
}

/// Data model for a toast, a.k.a. pop-up notification.
class Toast {
  /// The type (color) of this toast.
  String type;

  /// The title to display (optional).
  String title;

  /// The message to diplay.
  String message;

  /// The icon to display. If not specified, an icon is selected automatically
  /// based on `type`.
  String icon;

  /// How long to display the toast before removing it.
  num durationSeconds;

  /// Duration as a CSS property string.
  String cssDuration;

  /// Set to true before the item is deleted. This allows time to fade the
  /// item out.
  bool toBeDeleted = false;

  /// Constructor
  Toast(this.type, this.title, this.message, this.icon, this.durationSeconds) {
    durationSeconds ??= 3;

    cssDuration = '${durationSeconds}s';

    if (icon == null) {
      if (type == 'success') {
        icon = 'check';
      } else if (type == 'info') {
        icon = 'info';
      } else if (type == 'warning') {
        icon = 'exclamation';
      } else if (type == 'danger') {
        icon = 'times';
      } else {
        icon = 'bullhorn';
      }
    }
  }
}
