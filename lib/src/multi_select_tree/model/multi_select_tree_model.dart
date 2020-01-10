class MultiSelectTreeNode {
  String name;
  bool isRoot;
  bool showChildren;
  bool isSelected;
  bool isIndeterminate;
  bool showOtherProperties;
  List<MultiSelectTreeNode> children;

  MultiSelectTreeNode(String name, bool otherProperties, List<dynamic> children) {
    this.name = name;
    this.children = List<MultiSelectTreeNode>();
    this.showChildren = false;
    this.isRoot = false;
    this.isSelected = false;
    this.isIndeterminate = false;
    this.showOtherProperties = otherProperties;
    if (children != null) {
      for (var node in children) {
        MultiSelectTreeNode t = MultiSelectTreeNode(node.name, node.showOtherProperties, node.children);
        this.children.add(t);
      }
    }
  }

  List<MultiSelectTreeNode> getChildren() {
    return children;
  }

  bool isLeafNode() {
    return children.isEmpty;
  }
}
