import '../models/user.dart';

class UserBuilder {
  User user;

  static UserBuilder oneUser() {
    UserBuilder ub = UserBuilder();
    ub.user = User(
      name: 'Thiago Cunha',
      email: 'thiago.cunha@riodasostras.rj.gov.br',
      password: '123123'
    );
    return ub;
  }

  UserBuilder nameIsNull() {
    user.name = null;
    return this;
  }

  UserBuilder nameIsEmpty() {
    user.name = '';
    return this;
  }

  User now() {
    return user;
  }

}