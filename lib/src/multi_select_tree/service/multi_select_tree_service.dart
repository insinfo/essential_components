import 'dart:async';
import 'package:angular/angular.dart';
import '../model/multi_select_tree_model.dart';

@Injectable()
class TreeService {
  StreamController<List<MultiSelectTreeNode>> streamController = StreamController<List<MultiSelectTreeNode>>();
  // ignore: prefer_collection_literals
  final List<MultiSelectTreeNode> _selectedNodes = <MultiSelectTreeNode>[];
  List<MultiSelectTreeNode> getSelectedNodes() {
    return _selectedNodes;
  }
}
