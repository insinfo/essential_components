enum StatusValidator { WARNING, SUCCESS, DANGER, INFO }

class ValidatorResponse {
  String message;
  int statusCode;
  StatusValidator status;

  ValidatorResponse({this.message, this.status});

  String get styleClass {
    switch (status) {
      case StatusValidator.SUCCESS:
        return 'success';
      case StatusValidator.DANGER:
        return 'danger';
      case StatusValidator.WARNING:
        return 'info';
      case StatusValidator.INFO:
        return 'info';
    }
    return '';
  }
}
