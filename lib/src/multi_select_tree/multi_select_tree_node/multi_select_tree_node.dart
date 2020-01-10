import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular/core.dart';
import 'package:angular_components/angular_components.dart';

import '../model/multi_select_tree_model.dart';
import '../service/multi_select_tree_service.dart';

@Component(
  selector: 'tree-node',
  styleUrls: ['multi_select_tree_node.css'],
  templateUrl: 'multi_select_tree_node.html',
  directives: [coreDirectives, TreeNodeComponent, MaterialCheckboxComponent],
)
class TreeNodeComponent implements OnInit {
  TreeService _treeService;
  TreeNodeComponent(this._treeService);

  List<MultiSelectTreeNode> selectedNodes = List<MultiSelectTreeNode>();

  @Input('node')
  MultiSelectTreeNode node;

  @Input('parent')
  MultiSelectTreeNode parent;

  expandNode(MultiSelectTreeNode n) {
    n.showChildren = !n.showChildren;
  }

  handleIndeterminate(MultiSelectTreeNode n, MultiSelectTreeNode parent, bool isIndeterminateState) {
    n.isIndeterminate = isIndeterminateState;
    updateParentIndeterminate(parent, isIndeterminateState);
  }

  updateParentIndeterminate(MultiSelectTreeNode node, bool isIndeterminate) {
    if (node == null) return;
    node.isIndeterminate = isIndeterminate;
  }

  selectNode(MultiSelectTreeNode n, MultiSelectTreeNode parent, bool isChecked) {
    n.isSelected = isChecked;
    __updateChildren(n, isChecked);
    __updateParent(n, parent, isChecked);
    __updateSelected(n, isChecked);
  }

  __updateChildren(MultiSelectTreeNode n, bool isChecked) {
    if (!n.isIndeterminate) {
      for (MultiSelectTreeNode node in n.getChildren()) {
        node.isSelected = isChecked;
        __updateChildren(node, isChecked);
      }
    }
  }

  __updateParent(MultiSelectTreeNode n, MultiSelectTreeNode parent, bool isChecked) {
    if (parent != null) {
      List<MultiSelectTreeNode> siblings = parent.getChildren();
      bool equalSiblingState = true;
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

  __updateSelected(MultiSelectTreeNode n, bool isChecked) {
    if (isChecked) {
      this._treeService.getSelectedNodes().add(n);
    } else {
      this._treeService.getSelectedNodes().remove(n);
    }
    List<MultiSelectTreeNode> selectedNodes = this._treeService.getSelectedNodes();

    this._treeService.streamController.add(selectedNodes);
  }

  @override
  ngOnInit() {
    // TODO: implement ngOnInit
  }
}
