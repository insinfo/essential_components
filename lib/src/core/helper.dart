
/// If value is truthy return value, otherwise return defaultValue.
/// If defaultValue is a function it's result is returned.
///
/// ```dart
/// or(value, defaultValue);
///
/// //js
/// var value = value || defaultValue;
///
/// //Usage
/// var value = or(null, 1);
/// var value = or(null, () => 1);
/// ```
or(value, defaultValue) => falsey(value) ? defaultValue is Function ? defaultValue() : defaultValue : value;

/// Return true if `value` is "falsey":
/// ```dart
/// bool falsey(value) =>
///   value == null || value == false || value == '' || value == 0 || value == double.NAN;
///
/// //Usage
/// main () {
///     if (falsey('')) {
///       // ...
///     }
/// }
/// ```
bool falsey(value) => value == null || value == false || value == '' || value == 0 || value == double.nan;

/// Return true if `value` is "truthy":
/// ```dart
/// bool truthy(value) => !falsey(value);
///
/// //Usage
/// main () {
///     if (truthy('')) {
///      // ...
///     }
/// }
bool truthy(value) => !falsey(value);
