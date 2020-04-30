import 'package:angular/angular.dart';
import 'package:angular/core.dart';

import '../model/multi_select_tree_model.dart';
import '../service/multi_select_tree_service.dart';

@Component(
  selector: 'tree-node',
  styleUrls: ['multi_select_tree_node.css'],
  templateUrl: 'multi_select_tree_node.html',
  directives: [
    coreDirectives,
    TreeNodeComponent,
  ],
)
class TreeNodeComponent {
  final TreeService _treeService;
  TreeNodeComponent(this._treeService);

  // ignore: prefer_collection_literals
  List<MultiSelectTreeNode> selectedNodes = List<MultiSelectTreeNode>();

  @Input('node')
  MultiSelectTreeNode node;

  @Input('parent')
  MultiSelectTreeNode parent;

  void expandNode(MultiSelectTreeNode n) {
    n.showChildren = !n.showChildren;
  }

  void handleIndeterminate(MultiSelectTreeNode n, MultiSelectTreeNode parent,
      bool isIndeterminateState) {
    n.isIndeterminate = isIndeterminateState;
    updateParentIndeterminate(parent, isIndeterminateState);
  }

  void updateParentIndeterminate(
      MultiSelectTreeNode node, bool isIndeterminate) {
    if (node == null) return;
    node.isIndeterminate = isIndeterminate;
  }

  void selectNode(
      MultiSelectTreeNode n, MultiSelectTreeNode parent, bool isChecked) {
    n.isSelected = isChecked;
    __updateChildren(n, isChecked);
    __updateParent(n, parent, isChecked);
    __updateSelected(n, isChecked);
  }

  void __updateChildren(MultiSelectTreeNode n, bool isChecked) {
    if (!n.isIndeterminate) {
      // ignore: omit_local_variable_types
      for (MultiSelectTreeNode node in n.getChildren()) {
        node.isSelected = isChecked;
        __updateChildren(node, isChecked);
      }
    }
  }

  void __updateParent(
      MultiSelectTreeNode n, MultiSelectTreeNode parent, bool isChecked) {
    if (parent != null) {
      // ignore: omit_local_variable_types
      List<MultiSelectTreeNode> siblings = parent.getChildren();
      // ignore: omit_local_variable_types
      bool equalSiblingState = true;
      // ignore: omit_local_variable_types
      for (MultiSelectTreeNode node in siblings) {
        if (node.isSelected != isChecked) {
          equalSiblingState = false;
          break;
        }
      }
      if (equalSiblingState) {
        parent.isSelected = isChecked;
        // when all the nodes are of same state then parent state will also be the same.
        // remove the indeterminate state if already exists .
        parent.isIndeterminate = false;
      } else {
        // if all the siblings are not in same state, then parent will be in indeterminate state
        //and is not selected.
        parent.isIndeterminate = true;
        parent.isSelected = false;
      }
    }
  }

  void __updateSelected(MultiSelectTreeNode n, bool isChecked) {
    if (isChecked) {
      _treeService.getSelectedNodes().add(n);
    } else {
      _treeService.getSelectedNodes().remove(n);
    }
    // ignore: omit_local_variable_types
    List<MultiSelectTreeNode> selectedNodes = _treeService.getSelectedNodes();

    _treeService.streamController.add(selectedNodes);
  }
}
