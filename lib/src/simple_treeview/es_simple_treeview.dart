import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular/core.dart';
import 'package:essential_components/src/core/helper.dart';
import 'models/tree_view_base.dart';

import 'dart:html' as html;

@Component(
  selector: 'es-simple-treeview',
  styleUrls: ['es_simple_treeview.css'],
  templateUrl: 'es_simple_treeview.html',
  directives: [
    coreDirectives,
    // NgTemplateOutlet,
  ],
)
class EssentialSimpleTreeViewComponent implements OnInit, AfterChanges {
  EssentialSimpleTreeViewComponent();

  @ViewChild('treeContainer')
  html.DivElement treeContainer;

  @Input('searchPlaceholder')
  String searchPlaceholder = 'Buscar item';

  @Input('data')
  List<EssentialTreeViewNode> list;

  @Input('isMultiSelectable')
  bool isMultiSelectable = false;

  @Input('isDisableEnter')
  bool isDisableEnter = false;

  @Input('imperativeMode')
  bool imperativeMode = true;

  EssentialTreeViewNode itemSelected;

  @override
  void ngOnInit() async {}

  void searchKeydownEnter(inputsearch) {
    search(inputsearch.value);
  }

  void search(String value) {
    search2(value, list);
    if (imperativeMode) {
      updateDomTree(list);
    }
  }

  void search2(String _search_query, List<EssentialTreeViewNode> json_tree, [EssentialTreeViewNode parent]) {
    var search_query = Helper.removerAcentos(_search_query).toLowerCase();

    for (var i = 0; i < json_tree.length; i++) {
      var menu_item = json_tree[i];

      menu_item.parent = parent;

      if (search_query?.isNotEmpty == true) {
        menu_item.treeViewNodeFilter = false;
      } else {
        menu_item.treeViewNodeFilter = true;
      }

      if (menu_item.hasChilds(menu_item)) {
        search2(search_query, menu_item.treeViewNodes, menu_item);
      } else {
        /* volta do extremo para o topo da árvore */
        var item_endp = menu_item;

        while (item_endp.parent != null) {
          if (item_endp.treeViewNodeFilter == false) {
            if (item_endp.finded(search_query, item_endp)) {
              item_endp.treeViewNodeFilter = true;
              item_endp.parent.treeViewNodeFilter = true;
              item_endp.parent.treeViewNodeIsCollapse = false;
            }
          } else {
            item_endp.parent.treeViewNodeFilter = true;
            item_endp.parent.treeViewNodeIsCollapse = false;
          }

          item_endp = item_endp.parent;
        }

        if (item_endp.parent == null && item_endp.treeViewNodeFilter == false) {
          if (item_endp.finded(search_query, item_endp)) {
            item_endp.treeViewNodeFilter = true;
            item_endp.parent.treeViewNodeIsCollapse = false;
          }
        }
      }
    }

    if (search_query.isEmpty) {
      closeAllTree(json_tree);
    }
  }

  void closeAllTree(List<EssentialTreeViewNode> json_tree) {
    json_tree.forEach((element) {
      element.treeViewNodeIsCollapse = true;
      closeAllTree(element.treeViewNodes);
      /* if (element.treeViewNodeLevel == 0) {
          element.treeViewNodeIsCollapse = false;
        }*/
    });
  }

  void unselectAllTreeModel(List<EssentialTreeViewNode> json_tree) {
    json_tree.forEach((node) {
      node.treeViewNodeIsSelected = false;
      //metodos modo imperativo
      if (imperativeMode) {
        node.treeViewNodeLIElement.querySelector('.fancytree-title').classes.remove('bg-success');
      }
      unselectAllTreeModel(node.treeViewNodes);
    });
  }

  void selectAllTreeModel(List<EssentialTreeViewNode> json_tree) {
    json_tree.forEach((node) {
      node.treeViewNodeIsSelected = true;
      if (node.treeViewNodeLevel < 1) {
        node.treeViewNodeIsCollapse = false;
      }
      selectAllTreeModel(node.treeViewNodes);
    });
  }

  ///define all node of tree as treeViewNodeIsCollapse = false
  void expandAllTreeModel(List<EssentialTreeViewNode> json_tree) {
    json_tree.forEach((node) {
      node.treeViewNodeIsCollapse = false;
      expandAllTreeModel(node.treeViewNodes);
    });
  }

  ///define all node of tree as treeViewNodeIsCollapse = true
  void collapseAllTreeModel(List<EssentialTreeViewNode> json_tree) {
    json_tree.forEach((node) {
      node.treeViewNodeIsCollapse = true;
      expandAllTreeModel(node.treeViewNodes);
    });
  }

  bool isSelectAll = false;
  void selectAllToogleAction() {
    if (isSelectAll) {
      isSelectAll = false;
      unselectAllAction();
    } else {
      isSelectAll = true;
      selectAllAction();
    }
  }

  void selectAllAction() {
    selectAllTreeModel(list);
    if (imperativeMode) {
      updateDomTree(list);
    }
    selectAllStreamController.add(getAllSelected(list));
  }

  void unselectAllAction() {
    unselectAllTreeModel(list);
    if (imperativeMode) {
      updateDomTree(list);
    }
    selectAllStreamController.add([]);
  }

  bool isExpandAll = false;

  void expandAllToogleAction() {
    if (isExpandAll) {
      isExpandAll = false;
      collapseAllTreeModel(list);
    } else {
      isExpandAll = true;
      expandAllTreeModel(list);
    }

    if (imperativeMode) {
      updateDomTree(list);
    }
  }

  List<EssentialTreeViewNode> getAllSelected(List<EssentialTreeViewNode> json_tree) {
    var result = <EssentialTreeViewNode>[];
    json_tree.forEach((node) {
      if (node.treeViewNodeIsSelected) {
        result.add(node);
      }
      if (node.treeViewNodes?.isNotEmpty == true) {
        result.addAll(getAllSelected(node.treeViewNodes));
      }
    });
    return result;
  }

  StreamController<List<EssentialTreeViewNode>> selectAllStreamController =
      StreamController<List<EssentialTreeViewNode>>();

  StreamController<EssentialTreeViewNode> selectOneStreamController = StreamController<EssentialTreeViewNode>();

  @Output('selectAll')
  Stream get onSelectAll => selectAllStreamController.stream;

  @Output('selectOne')
  Stream get onSelectOne => selectOneStreamController.stream;

  void oneSelectHandle(EssentialTreeViewNode node) {
    if (!isMultiSelectable) {
      unselectAllTreeModel(list);
      node.treeViewNodeIsSelected = true;
      itemSelected = node;
      selectOneStreamController.add(itemSelected);
    }
  }

  void multiSelectHandle(EssentialTreeViewNode node) {
    if (isMultiSelectable) {
      node.treeViewNodeIsSelected = !node.treeViewNodeIsSelected;
      selectAllStreamController.add(getAllSelected(list));
    }
  }

  //metodos modo imperativo
  @override
  void ngAfterChanges() {
    if (imperativeMode) {
      if (list != null && treeContainer != null) {
        redraw();
      }
    }
  }

  ///metodos modo imperativo redraw
  void redraw() {
    treeContainer.innerHtml = '';
    treeContainer.append(_draw(list));
  }

  //metodos modo imperativo
  html.HtmlElement _draw(List<EssentialTreeViewNode> json_tree) {
    var ul = html.UListElement();
    ul.classes.addAll(['ui-fancytree', 'fancytree-container', 'fancytree-plain']);
    ul.append(_subDraw(json_tree));
    return ul;
  }

  //metodos modo imperativo para renderização
  html.HtmlElement _subDraw(List<EssentialTreeViewNode> json_tree) {
    var subUl = html.UListElement();
    json_tree.forEach((node) {
      var li = html.LIElement();
      node.treeViewNodeLIElement = li;

      var spanFancytreeNode = html.SpanElement();
      spanFancytreeNode.classes.add('fancytree-node');
      spanFancytreeNode.classes.add('fancytree-folder');

      var spanBtn = html.SpanElement();
      spanBtn.classes.add('fancytree-expander');
      spanFancytreeNode.append(spanBtn);

      var spanFancytreeCheckbox = html.SpanElement();
      spanFancytreeCheckbox.classes.add('fancytree-checkbox');
      spanFancytreeCheckbox.hidden = !isMultiSelectable;
      spanFancytreeNode.append(spanFancytreeCheckbox);
      spanFancytreeCheckbox.onClick.listen((event) {
        multiSelectHandle(node);
        updateDomTree(json_tree);
      });

      var spanFancytreeIcon = html.SpanElement();
      spanFancytreeIcon.classes.add('fancytree-icon');
      spanFancytreeNode.append(spanFancytreeIcon);

      var spanTitle = html.SpanElement();
      spanTitle.classes.add('fancytree-title');
      spanTitle.text = node.treeViewNodeLabel;
      spanTitle.onClick.listen((event) {
        oneSelectHandle(node);
        if (node.treeViewNodeIsSelected && isMultiSelectable == false) {
          spanTitle.classes.add('bg-success');
        }
      });
      spanFancytreeNode.append(spanTitle);

      li.append(spanFancytreeNode);
      if (node.treeViewNodes?.isNotEmpty == true) {
        li.append(_subDraw(node.treeViewNodes));
        if (node.treeViewNodeIsCollapse) {
          li.querySelector('ul')?.style?.display = node.treeViewNodeIsCollapse == false ? 'block' : 'none';
        }

        spanFancytreeNode.classes.add('fancytree-has-children');
        spanFancytreeNode.classes.add('fancytree-exp-c');
      } else {
        spanFancytreeNode.classes.add('fancytree-exp-n');
      }
      subUl.append(li);

      spanBtn.onClick.listen((event) {
        node.treeViewNodeIsCollapse = !node.treeViewNodeIsCollapse;
        updateDomTree(json_tree);
      });

      if (node.treeViewNodeIsCollapse == false) {
        spanFancytreeNode.classes.add('fancytree-ico-ef');
      } else {
        spanFancytreeNode.classes.add('fancytree-ico-cf');
      }
    });

    return subUl;
  }

  ///metodos modo imperativo update Dom Tree
  void updateDomTree(List<EssentialTreeViewNode> json_tree) {
    json_tree.forEach((node) {
      // var fancytreeTitle = node.treeViewNodeLIElement.querySelector('.fancytree-title');
      var spanFancytreeNode = node.treeViewNodeLIElement.querySelector('.fancytree-node');
      /*if (node.treeViewNodeIsSelected) {
        fancytreeTitle.classes.add('bg-success');
      } else {
        fancytreeTitle.classes.remove('bg-success');
      }*/

      if (node.treeViewNodeIsSelected) {
        spanFancytreeNode.classes.add('fancytree-selected');
      } else {
        spanFancytreeNode.classes.remove('fancytree-selected');
      }

      if (node.treeViewNodes?.isNotEmpty == true) {
        if (node.treeViewNodeIsCollapse == false) {
          spanFancytreeNode.classes.remove('fancytree-exp-c');
          spanFancytreeNode.classes.add('fancytree-exp-e');

          spanFancytreeNode.classes.remove('fancytree-ico-cf');
          spanFancytreeNode.classes.add('fancytree-ico-ef');
        } else {
          spanFancytreeNode.classes.remove('fancytree-exp-e');
          spanFancytreeNode.classes.add('fancytree-exp-c');

          spanFancytreeNode.classes.add('fancytree-ico-cf');
          spanFancytreeNode.classes.remove('fancytree-ico-ef');
        }
      } else {
        if (node.treeViewNodeIsCollapse == false) {
          spanFancytreeNode.classes.remove('fancytree-ico-cf');
          spanFancytreeNode.classes.add('fancytree-ico-ef');
        } else {
          spanFancytreeNode.classes.add('fancytree-ico-cf');
          spanFancytreeNode.classes.remove('fancytree-ico-ef');
        }
      }
      var childUl = node.treeViewNodeLIElement?.querySelector('ul');
      childUl?.style?.display = node.treeViewNodeIsCollapse == false ? 'block' : 'none';

      spanFancytreeNode.hidden = node.treeViewNodeFilter == false;
      updateDomTree(node.treeViewNodes);
    });
  }
}
