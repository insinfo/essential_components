import 'dart:async';

import 'package:angular/angular.dart';
import 'package:essential_components/src/directives/essential_inner_html_directive.dart';

import 'dart:html' as html;
import 'package:essential_rest/essential_rest.dart';

class TimelineModel {
  String contentTitle;
  String contentMutedSubtitle;
  String description;
  String category;
  DateTime update;
  String icon;
  String color;
}

abstract class TimelineRender {
  TimelineModel getModel;
}

@Component(
    selector: 'es-timeline',
    templateUrl: 'timeline_component.html',
    styleUrls: ['timeline_component.css'],
    pipes: [commonPipes],
    directives: [coreDirectives, EssentialInnerHTMLDirective])
class EssentialTimelineComponent implements OnDestroy, OnInit {
  @Input()
  RList<TimelineRender> data = RList<TimelineRender>();

  @ViewChild('dropdown')
  html.DivElement dropdown;

  bool isDropDownOpen = false;

  final _onUpdate = StreamController<TimelineRender>();
  final _onRemove = StreamController<TimelineRender>();

  String description;

  @Input()
  bool showDropdonOptions = false;

  @Output()
  Stream<TimelineRender> get onUpdate => _onUpdate.stream;

  @Output()
  Stream<TimelineRender> get onRemove => _onRemove.stream;

  StreamSubscription bodyOnClickSubscription;

  void bodyOnClick(e) {
    e.preventDefault();
    e.stopPropagation();
    if (isDropDownOpen) {
      dropdown.classes.remove('show');
      isDropDownOpen = false;
    }
  }

  EssentialTimelineComponent();

  void remove(TimelineRender d, e) {
    e.stopPropagation();
    _onRemove.add(d);
    html.HtmlElement currentDropdown = e.target.closest('.dropdown-options');
    closeDropdown(currentDropdown);
  }

  void update(TimelineRender d, e) {
    e.stopPropagation();
    _onUpdate.add(d);
    html.HtmlElement currentDropdown = e.target.closest('.dropdown-options');
    closeDropdown(currentDropdown);
  }

  @override
  void ngOnInit() {
    //print('ngOnInit');
    // TODO : corrigir bug que atrapalha outros components
   /* bodyOnClickSubscription =
        html.document.onClick.listen(bodyOnClick);*/
  }

  @override
  void ngOnDestroy() {
  //  print('ngOnDestroy');
    bodyOnClickSubscription?.cancel();
    bodyOnClickSubscription = null;
  }

  bool hasModels() {
    return data != null && data.isNotEmpty;
  }

  String getContentTitle(TimelineRender item) {
    return item.getModel?.contentTitle;
  }

  String getDescription(TimelineRender item, html.HtmlElement element) {
    element.setInnerHtml(item?.getModel?.description,
        treeSanitizer: html.NodeTreeSanitizer.trusted);
    // description = item?.getModel?.description;
    return '';
  }

  String getCategory(TimelineRender item) {
    return item.getModel?.category;
  }

  String getContentMutedSubtitle(TimelineRender item) {
    print(item);
    return item.getModel?.contentMutedSubtitle;
  }

  String getIcon(TimelineRender item) {
    return item.getModel?.icon;
  }

  String getColor(TimelineRender item) {
    return item.getModel?.color;
  }

  DateTime getUpdate(TimelineRender item) {
    return item.getModel?.update;
  }

  void toggleDropdownOption(e) {
    e.stopPropagation();
    html.HtmlElement element = e.target;
    var elementSelected =
        element.closest('.card-footer').querySelector('.dropdown-options');

    if (!elementSelected.classes.contains('show')) {
      elementSelected.classes.add('show');
      isDropDownOpen = true;
    } else {
      closeDropdown(elementSelected);
    }
  }

  void closeDropdown(html.HtmlElement element) {
    if (element != null) {
      element.classes.remove('show');
      isDropDownOpen = false;
    }
  }
}
