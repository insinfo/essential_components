import 'package:angular/angular.dart';

/// Creates a new tab header template
@Directive(selector: 'template[bs-tabx-header]')
class BsTabxHeaderDirective {
  /// constructs a [BsTabxHeaderDirective] injecting its own [templateRef] and its parent [tab]
  BsTabxHeaderDirective(this.templateRef);

  TemplateRef templateRef;
}
