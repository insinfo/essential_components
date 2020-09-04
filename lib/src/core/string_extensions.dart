extension StringCapitalizeExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  String get allInCaps => toUpperCase();
  String get capitalizeFirstOfEach => split(RegExp(r'\s')).map((str) => str.inCaps).join(' ');
}
