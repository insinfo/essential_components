import 'package:essential_components/essential_components.dart';
import 'dart:html' as html;

class User implements IDataTableRender {
  int id;
  String name;
  String username;
  String email;

  static List<String> status = ['active', 'inactive', 'canceled', 'paused'];

  User.fromJson(Map<String, dynamic> json) {
    try {
      id = json.containsKey("id") ? json['id'] : -1;
      name = json.containsKey("name") ? json['name'] : "";
    } catch (e) {
      print('User.fromJson: ${e}');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = Map<String, dynamic>();
    if (this.id != null) {
      json['id'] = this.id;
    }
    json['name'] = this.name;
  }

  @override
  DataTableRow getRowDefinition() {
    var settings = DataTableRow();
    settings.addSet(DataTableColumn(
        key: "name",
        value: name,
        title: "Name",
        customRender: (html.TableCellElement cellElement) {
          if (name == "Leanne Graham") {
            cellElement?.closest('tr')?.style?.background = "#e8fbee";
            return '''<span style="font-size: .8125rem;
    padding: 5px 15px; color: #fff; font-weight: 400;    
    border-radius: 10px; background: #2fa433d9;">
              $name</span>''';
          }
          return name;
        }));

    settings.addSet(DataTableColumn(key: "username", value: username, title: "username", limit: 20));
    return settings;
  }
}
