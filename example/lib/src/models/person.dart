import 'package:essential_components/essential_components.dart';
import 'package:essential_components/src/core/helper.dart';

class Person implements IDataTableRender {
  int id;
  String name;
  int age;
  String phone;
  DateTime birthday;
  String avatar;
  bool enable;
  String description;

  Person();

  String get birthdayAsString {
    var dt = birthday != null ? birthday.toIso8601String().substring(0, 10) : "";
    return dt;
  }

  set birthdayAsString(value) {
    if (value is DateTime) {
      birthday = value;
    } else if (value is String) {
      birthday = DateTime.tryParse(value);
    }
  }


  Person.fromJson(Map<String, dynamic> json) {
    try {
      id = Helper.isNotNullOrEmptyAndContain(json, 'id') ? json['id'] : -1;
      name = Helper.isNotNullOrEmptyAndContain(json, 'name') ? json['name'] : '';
      age = Helper.isNotNullOrEmptyAndContain(json, 'age') ? json['age'] : -1;
      phone = Helper.isNotNullOrEmptyAndContain(json, 'phone') ? json['phone'] : '';
      birthdayAsString = Helper.isNotNullOrEmptyAndContain(json, 'birthday') ? json['birthday'] : null;
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

  @override
  DataTableRow getRowDefinition() {
    DataTableRow settings = DataTableRow();
    settings.addSet(DataTableColumn(
      key: 'avatar',
      value: avatar,
      title: 'Avatar',
      type: DataTableColumnType.img
    ));
    settings.addSet(DataTableColumn(
      key: 'name',
      value: name,
      title: 'Name',
      type: DataTableColumnType.text,
      primaryDisplayValue: true
    ));
    settings.addSet(DataTableColumn(
      key: 'age',
      value: age,
      title: 'Age',
      type: DataTableColumnType.text
    ));
    settings.addSet(DataTableColumn(
      key: 'phone',
      value: phone,
      title: 'Phone Number',
      type: DataTableColumnType.text
    ));
    settings.addSet(DataTableColumn(
      key: 'birthday',
      value: birthday,
      title: 'Birthday',
      type: DataTableColumnType.date
    ));
    
    settings.addSet(DataTableColumn(
      key: 'enable',
      value: enable,
      title: 'Enable',
      type: DataTableColumnType.boolLabel
    ));
    settings.addSet(DataTableColumn(
      key: 'description',
      value: description,
      title: 'Description',
      limit: 100,
      type: DataTableColumnType.text
    ));
    
    return settings;
  }

  

}