import 'package:essential_components/src/core/helper.dart';

class Person {
  int id;
  String name;
  int age;
  String phone;
  DateTime birthday;
  String avatar;
  bool enable;
  String description;

  Person.fromJson(Map<String, dynamic> json) {
    try {
      id = Helper.isNotNullOrEmptyAndContain(json, 'id') ? json['id'] : -1;
      name = Helper.isNotNullOrEmptyAndContain(json, 'name') ? json['name'] : '';
      age = Helper.isNotNullOrEmptyAndContain(json, 'age') ? json['age'] : -1;
      phone = Helper.isNotNullOrEmptyAndContain(json, 'phone') ? json['phone'] : '';
      birthday = Helper.isNotNullOrEmptyAndContain(json, 'birthday') ? json['birthday'] : null;
      avatar = Helper.isNotNullOrEmptyAndContain(json, 'avatar') ? json['avatar'] : '';
      enable = Helper.isNotNullOrEmptyAndContain(json, 'enable') ? json['enable'] : null;
      description = Helper.isNotNullOrEmptyAndContain(json, 'description') ? json['description'] : '';
    } catch (e) {
      print('Person.fromJson: ${e}');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id != null ? id : null,
      'name': name,
      'age': age,
      'phone': phone,
      'birthday': birthday,
      'avatar': avatar,
      'enable': enable,
      'description': description
    };
  }

}