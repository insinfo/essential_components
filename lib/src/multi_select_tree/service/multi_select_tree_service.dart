import 'dart:async';
import 'package:angular/angular.dart';
import '../model/multi_select_tree_model.dart';

@Injectable()
class TreeService implements OnInit {
  StreamController<List<MultiSelectTreeNode>> streamController = StreamController<List<MultiSelectTreeNode>>();
  List<MultiSelectTreeNode> _selectedNodes = List<MultiSelectTreeNode>();
  List<MultiSelectTreeNode> getSelectedNodes() {
    return _selectedNodes;
  }

  @override
  ngOnInit() {
    // TODO: implement ngOnInit
  }
}
