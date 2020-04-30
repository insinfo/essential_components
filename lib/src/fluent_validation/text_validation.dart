import 'package:essential_components/src/handlers/exceptions/bad_request_exception.dart';

class TextValidation {
  String value;
  String messageError;
  int minLength;
  int maxLength;
  int fixedLength;

  void _withCustomMessageError() {
    if (messageError != null && messageError.isNotEmpty) {
      throw BadRequestException(messageError);
    }
  }

  static TextValidation init(
      {String value,
      String messageError,
      int minLength,
      int maxLength,
      int fixedLength}) {
    if (value != null ||
        messageError != null ||
        minLength != null ||
        maxLength != null ||
        fixedLength != null) {
      var textValidation = TextValidation();
      textValidation.value = value ?? value;
      textValidation.messageError = messageError ?? messageError;
      textValidation.minLength = minLength ?? minLength;
      textValidation.maxLength = maxLength ?? maxLength;
      textValidation.fixedLength = fixedLength ?? fixedLength;
      return textValidation;
    }
    return TextValidation();
  }

  TextValidation whereValueIs(String value) {
    this.value = value;
    return this;
  }

  TextValidation whereMessageErrorIs(String messageError) {
    this.messageError = messageError;
    return this;
  }

  TextValidation whereSizeRangeIs(int minLength, int maxLength) {
    if (minLength >= maxLength) {
      _withCustomMessageError();
      throw BadRequestException(
          'The minimum size is less than or equal to the maximum size. If it is the same, use the fixed value method.');
    }

    if (minLength < 0 || maxLength < 0) {
      throw BadRequestException(
          'The minimum size or the maximum size is less of zero.');
    }

    this.minLength = minLength;
    this.maxLength = maxLength;

    return this;
  }

  TextValidation isNull() {
    if (value == null) {
      _withCustomMessageError();
      throw BadRequestException('The value is null.');
    }
    return this;
  }

  TextValidation isEmpty() {
    if (value.isEmpty) {
      _withCustomMessageError();
      throw BadRequestException('The value is null.');
    }
    return this;
  }

  TextValidation isInvalidLength() {
    if (value.length < minLength || value.length > maxLength) {
      _withCustomMessageError();
      throw BadRequestException('The value size is invalid length');
    }
    return this;
  }

  TextValidation isNotEqualsSize() {
    if (value.length != fixedLength) {
      _withCustomMessageError();
      throw BadRequestException('Value is not valid with fixed length');
    }
    return this;
  }

  TextValidation isEqualsSize() {
    if (value.length == fixedLength) {
      _withCustomMessageError();
      throw BadRequestException('Value has equals length');
    }
    return this;
  }

  TextValidation isEqualsTo(String outherValue) {
    if (value == outherValue) {
      _withCustomMessageError();
      throw BadRequestException('The values are equals');
    }
    return this;
  }

  TextValidation isNotEqualsTo(String outherValue) {
    if (value != outherValue) {
      _withCustomMessageError();
      throw BadRequestException("The values aren't equals");
    }
    return this;
  }

  bool validate() {
    return true;
  }
}
