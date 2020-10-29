import 'dart:html';

import 'package:angular/angular.dart';
import 'simple_select.dart';

///options do select <es-simple-select-option>
@Component(
  selector: 'es-simple-select-option',
  templateUrl: 'simple_select_option.html',
  styleUrls: ['simple_select_option.css'],
  directives: [coreDirectives],
  //styleUrls: ['accordion.css']
)
class EsSimpleSelectOptionComponent {
  EsSimpleSelectOptionComponent();
  EssentialSimpleSelectComponent parent;
  //TemplateRef headingTemplate;

  @ViewChild('item')
  HtmlElement item;

  bool hidden = false;

  // dynamic _disable;
  String _styleClass = 'dropdown-item';

  @Input()
  set styleClass(String className) {
    _styleClass = className;
  }

  String get styleClass {
    return _styleClass;
  }

  @Input()
  set disable(dynamic ds) {
    _styleClass = 'dropdown-item disable';
  }

  String get text {
    return item?.firstChild?.text;
  }

  set text(String inputText) {
    item?.text = inputText;
  }

  String get innerHtml {
    return item?.firstChild?.text;
  }

  set innerHtml(String inputText) {
    item?.innerHtml = innerHtml;
  }

  @Input()
  dynamic value;

  void handleOnClick(Event e) {
    e.stopPropagation();
    parent.dropdownOnSelect(e, value, item?.firstChild?.text);
  }
}
