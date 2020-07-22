enum PaginationButtonType { prev, next, page }

class PaginationItem {
  Function(dynamic) action;
  String label;
  String cssClass;
  bool isActive;
  PaginationButtonType paginationButtonType;
  PaginationItem({
    this.action,
    this.label,
    this.cssClass,
    this.isActive = false,
    this.paginationButtonType = PaginationButtonType.page,
  });
}
