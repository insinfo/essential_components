import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular/core.dart';

import 'service/multi_select_tree_service.dart';
import 'model/multi_select_tree_model.dart';
import 'multi_select_tree_node/multi_select_tree_node.dart';

@Component(
    selector: 'multi-select-tree',
    styleUrls: ['multi_select_tree.css'],
    templateUrl: 'multi_select_tree.html',
    directives: [coreDirectives, TreeNodeComponent],
    providers: [TreeService])
class MultiSelectTreeComponent implements OnInit, OnDestroy {
  final TreeService _treeService;
  MultiSelectTreeComponent(this._treeService);

  // ignore: prefer_collection_literals
  List<MultiSelectTreeNode> rootNodeList = <MultiSelectTreeNode>[];
  StreamController<List<MultiSelectTreeNode>> propagateController = StreamController<List<MultiSelectTreeNode>>();

  @Input('data')
  dynamic treeRootNodes;

  @Output('selectedNodes')
  Stream get init => propagateController.stream;

  @override
  void ngOnInit() {
    for (var node in treeRootNodes) {
      MultiSelectTreeNode treeNode;
      treeNode = MultiSelectTreeNode(node.name, node.showOtherProperties, node.children);
      treeNode.isRoot = true;
      rootNodeList.add(treeNode);
    }
    _treeService.streamController.stream.listen((List<MultiSelectTreeNode> n) {
      propagateController.add(n);
    });
  }

  @override
  void ngOnDestroy() {
    propagateController.close();
  }
}
