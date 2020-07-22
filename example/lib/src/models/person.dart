import 'package:essential_components/essential_components.dart';
import 'package:essential_components/src/core/helper.dart';

class Person implements IDataTableRender, ISimpleSelectRender, TimelineRender {
  int id;
  String name;
  int age;
  String phone;
  DateTime birthday;
  String avatar;
  bool enable;
  String description;
  DataTableRow dataTableRowSettings;

  @override
  TimelineModel getModel;

  Person() {
    dataTableInit();
    timelineInit();
  }
  void dataTableInit() {
    dataTableRowSettings = DataTableRow();
    dataTableRowSettings.addSet(
      DataTableColumn(
        key: 'avatar',
        value: avatar,
        title: 'Avatar',
        type: DataTableColumnType.img,
      ),
    );

    dataTableRowSettings.addSet(
      DataTableColumn(
        key: 'name',
        value: name,
        title: 'Name',
        type: DataTableColumnType.text,
        primaryDisplayValue: true,
      ),
    );

    dataTableRowSettings.addSet(DataTableColumn(key: 'age', value: age, title: 'Age', type: DataTableColumnType.text));
    dataTableRowSettings
        .addSet(DataTableColumn(key: 'phone', value: phone, title: 'Phone', type: DataTableColumnType.text));
    dataTableRowSettings
        .addSet(DataTableColumn(key: 'birthday', value: birthday, title: 'Birthday', type: DataTableColumnType.date));

    dataTableRowSettings
        .addSet(DataTableColumn(key: 'enable', value: enable, title: 'Enable', type: DataTableColumnType.boolLabel));
    dataTableRowSettings.addSet(DataTableColumn(
        key: 'description', value: description, title: 'Description', limit: 20, type: DataTableColumnType.text));
  }

  void timelineInit() {
    getModel = TimelineModel();
    getModel.contentTitle = name;
    getModel.contentMutedSubtitle = 'Age: ${age}';
    getModel.description = 'Description is Hero';
    getModel.category = 'Category to Separation';
    getModel.update = DateTime.now();
    getModel.icon = 'icon-rocket';
    getModel.color = 'success-300';
  }

  String get birthdayAsString {
    var dt = birthday != null ? birthday.toIso8601String().substring(0, 10) : '';
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

    dataTableInit();
    timelineInit();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
    return dataTableRowSettings;
  }

  @override
  String getDisplayName() {
    return name;
  }
}
