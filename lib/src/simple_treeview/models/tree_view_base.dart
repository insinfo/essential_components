import 'package:essential_components/src/core/helper.dart';
import 'dart:html' as html;

abstract class EssentialTreeViewNode {
  String treeViewNodeLabel;
  String treeViewNodeSubLabel;
  String treeViewNodeIconClass;
  String treeViewNodeColor;
  html.HtmlElement treeViewNodeLIElement;

  List<EssentialTreeViewNode> treeViewNodes = <EssentialTreeViewNode>[];
  int treeViewNodeLevel;
  bool treeViewNodeFilter;
  EssentialTreeViewNode parent;
  bool treeViewNodeIsCollapse = true;
  bool treeViewNodeIsSelected = false;

  EssentialTreeViewNode();

  bool hasChilds(EssentialTreeViewNode item) {
    return item.treeViewNodes?.isNotEmpty == true;
  }

  bool finded(String _search_query, EssentialTreeViewNode item) {
    var item_title = Helper.removerAcentos(item.treeViewNodeLabel).toLowerCase();
    return item_title.contains(_search_query);
  }
}
