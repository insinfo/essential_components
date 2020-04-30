class MultiSelectTreeNode {
  String name;
  bool isRoot;
  bool showChildren;
  bool isSelected;
  bool isIndeterminate;
  bool showOtherProperties;
  List<MultiSelectTreeNode> children;

  MultiSelectTreeNode(
      String name, bool otherProperties, List<dynamic> children) {
    this.name = name;
    // ignore: prefer_collection_literals
    this.children = List<MultiSelectTreeNode>();
    showChildren = false;
    isRoot = false;
    isSelected = false;
    isIndeterminate = false;
    showOtherProperties = otherProperties;
    if (children != null) {
      for (var node in children) {
        // ignore: omit_local_variable_types
        MultiSelectTreeNode t = MultiSelectTreeNode(
            node.name, node.showOtherProperties, node.children);
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
