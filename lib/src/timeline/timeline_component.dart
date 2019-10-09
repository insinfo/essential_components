import 'dart:async';

import 'package:angular/angular.dart';

import '../../essential_components.dart';

import 'dart:html' as html;

class TimelineModel {
  String contentTitle;
  String description;
  String category;
  DateTime update;
}

abstract class TimelineRender {
  TimelineModel getModel();
}

@Component(
    selector: 'es-timeline',
    templateUrl: 'timeline_component.html',
    styleUrls: ['timeline_component.css'],
    pipes: [ commonPipes ],
    directives: [coreDirectives])
class EssentialTimelineComponent implements AfterContentInit, OnDestroy {

  @Input()
  RList<TimelineRender> data;

  @ViewChild('dropdown')
  html.DivElement dropdown;

  final _onUpdate = StreamController<TimelineRender>();
  final _onRemove = StreamController<TimelineRender>();

  @Output()
  Stream<TimelineRender> get onUpdate => _onUpdate.stream;
  
  @Output()
  Stream<TimelineRender> get onRemove => _onRemove.stream;

  StreamSubscription bodyOnClickSubscription;

  bodyOnClick(e) {
    e.preventDefault();
    e.stopPropagation();
    if (isDropDownOpen) {
      this.dropdown.classes.remove('show');
      isDropDownOpen = false; 
    }
  }

  EssentialTimelineComponent() {
    this.bodyOnClickSubscription = html.document.querySelector('body').onClick.listen(bodyOnClick);
  }

  remove(TimelineRender d, e) {
    e.stopPropagation();
    _onRemove.add(d);
    html.HtmlElement currentDropdown = e.target.closest('.dropdown-options');
    closeDropdown(currentDropdown);
  }

  update(TimelineRender d, e) {
    e.stopPropagation();
    _onUpdate.add(d);
    html.HtmlElement currentDropdown = e.target.closest('.dropdown-options');
    closeDropdown(currentDropdown);
  }

  @override
  ngAfterContentInit() {
  }

  @override
  void ngOnDestroy() {
    bodyOnClickSubscription?.cancel();
    bodyOnClickSubscription = null;
  }

  bool hasModels() {
    return this.data != null && this.data.isNotEmpty;
  }

  String getContentTitle(TimelineRender item) {
    return item.getModel().contentTitle;
  }

  String getDescription(TimelineRender item) {
    return item.getModel().description;
  }

  String getCategory(TimelineRender item) {
    return item.getModel().category;
  }

  DateTime getUpdate(TimelineRender item) {
    return item.getModel().update;
  }

  bool isDropDownOpen = false;

  toggleDropdownOption(e) {
    e.stopPropagation();
    html.HtmlElement element = e.target;
    var elementSelected = element.closest('.card-footer').querySelector('.dropdown-options'); 
    
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
