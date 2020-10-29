import 'dart:async';
import 'dart:html' as html;
import 'package:angular/angular.dart';
import 'package:angular/core.dart';
import 'package:angular/security.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:essential_components/src/core/enums/pagination_type.dart';
import 'package:essential_components/src/core/helper.dart';
import 'package:essential_components/src/core/interfaces/datatable_render_interface.dart';
import 'package:essential_components/src/core/models/data_table_filter.dart';
import 'package:essential_components/src/core/models/pagination_item.dart';
import 'package:essential_xlsx/essential_xlsx.dart';
import 'package:intl/intl.dart';
import 'package:essential_rest/essential_rest.dart';

//utils
import 'data_table_utils.dart';

@Directive(selector: '[esdtinnerhtml]') //esdtinnerhtml
class EsDataTableInnerHtmlDirective implements AfterContentInit {
  @Input('esdtinnerhtml')
  DataTableColumn dataTableColumn;

  @Input()
  html.TableCellElement tdElement;

  final html.Element _el;

  EsDataTableInnerHtmlDirective(this._el);

  @override
  void ngAfterContentInit() {
    // String htmlContent = 'l';
    //var val = getHtmlOfCell(col, td);
    var val = DataTableUtils.formatCell(dataTableColumn, cellElement: tdElement);
    _el.setInnerHtml(val, treeSanitizer: html.NodeTreeSanitizer.trusted);
  }
}

@Component(
  selector: 'es-data-table',
  templateUrl: 'data_table.html',
  styleUrls: ['data_table.css'],
  pipes: [commonPipes],
  directives: [
    formDirectives,
    coreDirectives,
    EsDataTableInnerHtmlDirective,
  ],
)
//A Material Design Data table component for AngularDart
class EssentialDataTableComponent implements OnInit, AfterChanges, AfterViewInit {
  @ViewChild('tableElement') //HtmlElement
  html.TableElement tableElement;

  @ViewChild('divNoContent')
  html.DivElement divNoContent;

  @ViewChild('tbody')
  html.HtmlElement tbody;

  @Input()
  DataTableFilter dataTableFilter = DataTableFilter();

  @Input()
  set defaultItemsPerPage(int v) => dataTableFilter?.limit = v;

  @ViewChild('inputSearchElement')
  html.InputElement inputSearchElement;

  @ViewChild('itemsPerPageElement')
  html.SelectElement itemsPerPageElement;

  @ViewChild('paginateContainer')
  html.HtmlElement paginateContainer;

  @ViewChild('paginateDiv')
  html.HtmlElement paginateDiv;

  @ViewChild('paginatePrevBtn')
  html.HtmlElement paginatePrevBtn;

  @ViewChild('paginateNextBtn')
  html.HtmlElement paginateNextBtn;

  String _orderDir = 'asc';
  //bool _isTitlesRendered = false;

  @Input()
  bool error = false;

  @Input()
  bool isNoContent = false;

  @Input()
  String noContentMessage = 'Dados indisponiveis';

  @Input()
  String errorMessage =
      'Ocorreu um erro ao listar, verifique sua conexão de rede ou entre em contato com o suporte técnico.';

  void setErrorOccurred() {
    isLoading = false;
    error = true;
  }

  void removeErrorOccurred() {
    error = false;
  }

  @Input()
  bool showResetButtom = true;

  @Input()
  bool showActionsHeader = true;

  @Input()
  bool showActionsFooter = true;

  @Input()
  bool showTableHeader = true;

  @Input()
  bool enableOrdering = true;

  @Input()
  bool showFilter = true;

  @Input()
  bool showItemsLimit = true;

  bool showCheckBoxToSelectRow = true;

  @Input()
  set showCheckboxSelect(bool showCBSelect) {
    showCheckBoxToSelectRow = showCBSelect;
  }

  bool get showCheckboxSelect {
    return showCheckBoxToSelectRow;
  }

  @Input()
  String itensPerPageInputLabel = 'Exibir:';

  @Input()
  String searchInputLabel = 'Filtrar:';

  @Input()
  String totalRecordsLabel = 'Total:';

  @Input()
  String reloadButtonTitle = 'Recarrega o Datatable';

  @Input()
  String resetButtonTitle = 'Limpar filtros e recarregar';

  @Input()
  String exportButtonTitle = 'Exportar os dados para xlsx';

  @Input()
  String columnVisibilityButtonTitle = 'Visibilidade de colunas';

  List<DataTableRow> innerData = <DataTableRow>[];
  //RList<IDataTableRender> inputData;
  RList<IDataTableRender> selectedItems = RList<IDataTableRender>();

  @Input()
  set data(RList<IDataTableRender> data) {
    totalRecords = data.totalRecords;
    innerData = toDataTableRow(data);
  }

  List<DataTableRow> toDataTableRow(RList<IDataTableRender> input) {
    var r = innerData = <DataTableRow>[];
    if (input != null) {
      input.forEach((element) {
        var row = element.getRowDefinition();
        row.itemInstance = element;
        innerData.add(row);
      });
    }
    return r;
  }

  RList<IDataTableRender> toIDataTableRender(List<DataTableRow> input) {
    var r = RList<IDataTableRender>();
    if (input != null) {
      input.forEach((element) {
        innerData.add(element.itemInstance);
      });
    }
    return r;
  }

  int totalRecords = 0;

  /* int get totalRecords {
    if (innerData != null) {
      return inputData.totalRecords;
    }
    return 0;
  }*/

  int _currentPage = 1;
  final int _btnQuantity = 5;
  PaginationType paginationType = PaginationType.carousel;
  List<PaginationItem> paginationItems = <PaginationItem>[];

  EssentialDataTableComponent(this.sanitizer);

  final DomSanitizationService sanitizer;
  //sanitiza o HTML da celula
  /* SafeHtml getHtmlOfCell(DataTableColumn dataTableColumn, html.TableCellElement cellElement) {
    return sanitizer.bypassSecurityTrustHtml(formatCell(dataTableColumn, cellElement: cellElement));
  }*/

  @override
  void ngOnInit() {}

  void handleSearchInputKeypress(e) {
    //e.preventDefault();
    e.stopPropagation();
    if (e.keyCode == html.KeyCode.ENTER) {
      onSearch();
    }
  }

  @override
  void ngAfterViewInit() {
    drawPagination();
  }

  @override
  void ngAfterChanges() {
    //draw();
    drawPagination();
  }

  Future<void> toXLSX() async {
    if (innerData != null) {
      if (innerData.isNotEmpty) {
        var simplexlsx = SimpleXLSX();
        simplexlsx.sheetName = 'sheet';

        //adiciona os dados
        var idx = 0;
        innerData.forEach((col) {
          if (idx == 0) {
            var collsForExport = col.colsSets.where((i) => i.export).toList();
            //adiciona os titulos
            simplexlsx.addRow(collsForExport.map((c) {
              return c.title.toString();
            }).toList());
          }
          {
            var collsForExport = col.colsSets.where((i) => i.export).toList();
            //adiciona os valores
            simplexlsx.addRow(collsForExport.map((c) {
              return DataTableUtils.formatCell(c, disableLimit: true, stripHtml: true);
            }).toList());
          }
          idx++;
        });

        simplexlsx.build();
      }
    }
  }

  List<DataTableColumn> get columnTitles {
    if (innerData != null && innerData.isNotEmpty) {
      var columnsTitles = innerData[0];
      return columnsTitles.colsSets;
    }
    return null;
  }

  void changeVisibilityOfCol(DataTableColumn col) {
    var visible = !col.visible;
    innerData.forEach((row) {
      row.colsSets.forEach((column) {
        if (column.title == col.title) {
          column.visible = visible;
        }
      });
    });
  }

  int numPages() {
    var totalPages = (totalRecords / dataTableFilter.limit).ceil();
    return totalPages;
  }

  void drawPagination() {
    if (showActionsFooter) {
      var self = this;
      //quantidade total de paginas
      var totalPages = numPages();

      //quantidade de botões de paginação exibidos
      var btnQuantity = self._btnQuantity > totalPages ? totalPages : self._btnQuantity;
      var currentPage = self._currentPage; //pagina atual
      //clear paginateContainer for new draws
      self.paginateContainer?.innerHtml = '';
      if (self.totalRecords < self.dataTableFilter.limit) {
        return;
      }

      if (btnQuantity == 1) {
        return;
      }

      if (currentPage == 1) {
        paginatePrevBtn?.classes?.remove('disabled');
        paginatePrevBtn?.classes?.add('disabled');
      }

      if (currentPage == totalPages) {
        paginateNextBtn?.classes?.remove('disabled');
        paginateNextBtn?.classes?.add('disabled');
      }

      var idx = 0;
      var loopEnd = 0;
      switch (paginationType) {
        case PaginationType.carousel:
          idx = (currentPage - (btnQuantity / 2)).toInt();
          if (idx <= 0) {
            idx = 1;
          }
          loopEnd = idx + btnQuantity;
          if (loopEnd > totalPages) {
            loopEnd = totalPages + 1;
            idx = loopEnd - btnQuantity;
          }
          while (idx < loopEnd) {
            var link = html.Element.tag('a');
            link.classes.add('paginate_button');
            if (idx == currentPage) {
              link.classes.add('current');
            }
            link.text = idx.toString();
            var liten = (event) {
              var pageBtnValue = int.tryParse(link.text);
              if (self._currentPage != pageBtnValue) {
                self._currentPage = pageBtnValue;
                self.changePage(self._currentPage);
              }
            };
            link.onClick.listen(liten);
            self.paginateContainer?.append(link);
            idx++;
          }
          break;
        case PaginationType.cube:
          var facePosition = (currentPage % btnQuantity) == 0 ? btnQuantity : currentPage % btnQuantity;
          loopEnd = btnQuantity - facePosition + currentPage;
          idx = currentPage - facePosition;
          while (idx < loopEnd) {
            idx++;
            if (idx <= totalPages) {
              var link = html.Element.tag('a');
              link.classes.add('paginate_button');
              if (idx == currentPage) {
                link.classes.add('current');
              }
              link.text = idx.toString();
              var liten = (event) {
                var pageBtnValue = int.tryParse(link.text);
                if (self._currentPage != pageBtnValue) {
                  self._currentPage = pageBtnValue;
                  self.changePage(self._currentPage);
                }
              };
              link.onClick.listen(liten);
              self.paginateContainer.append(link);
            }
          }
          break;
      }
    }
  }

  void prevPage(html.Event event) {
    if (_currentPage == 0) {
      return;
    }
    if (_currentPage > 1) {
      _currentPage--;
      changePage(_currentPage);
    }
  }

  void nextPage(html.Event event) {
    if (_currentPage == numPages()) {
      return;
    }
    if (_currentPage < numPages()) {
      _currentPage++;
      changePage(_currentPage);
    }
  }

  void changePage(page) {
    onRequestData();
    if (page != _currentPage) {
      _currentPage = page;
    }
    selectedItems.clear();
  }

  final _rowClickRequest = StreamController<IDataTableRender>();

  @Output()
  Stream<IDataTableRender> get rowClick => _rowClickRequest.stream;

  void onRowClick(DataTableRow item) {
    _rowClickRequest.add(item.itemInstance);
  }

  final _searchRequest = StreamController<DataTableFilter>();

  @Output()
  Stream<DataTableFilter> get searchRequest => _searchRequest.stream;

  void onSearch() {
    dataTableFilter.searchString = inputSearchElement.value;
    _searchRequest.add(dataTableFilter);
    onRequestData();
  }

  final _limitChangeRequest = StreamController<DataTableFilter>();

  @Output()
  Stream<DataTableFilter> get limitChange => _limitChangeRequest.stream;

  void onLimitChange() {
    _currentPage = 1;
    dataTableFilter.limit = int.tryParse(itemsPerPageElement.value);
    _limitChangeRequest.add(dataTableFilter);
    onRequestData();
  }

  final _dataRequest = StreamController<DataTableFilter>();

  @Output()
  Stream<DataTableFilter> get dataRequest => _dataRequest.stream;

  bool isLoading = true;

  void onRequestData() {
    isLoading = true;
    var currentPage = _currentPage == 1 ? 0 : _currentPage - 1;
    dataTableFilter.offset = currentPage * dataTableFilter.limit;
    _dataRequest.add(dataTableFilter);
  }

  void reload() {
    onRequestData();
  }

  void reset() {
    itemsPerPageElement.options.firstWhere((o) => o.value == '10').selected = true;
    dataTableFilter.clear();
    onRequestData();
  }

  //quando selecionar tudos os items
  void onSelectAll(event) {
    //event.target.parent.classes.toggle('checked');
    var cbs = tableElement.querySelectorAll('input[cbselect=true]');
    if (event.target.checked) {
      for (html.CheckboxInputElement item in cbs) {
        item.checked = true;
      }
      selectedItems.clear();
      selectedItems.addAll(toIDataTableRender(innerData));
    } else {
      selectedItems.clear();
      for (html.CheckboxInputElement item in cbs) {
        item.checked = false;
      }
    }
  }

  //quando selecionar um item
  void onSelect(html.MouseEvent event, DataTableRow item) {
    event.stopPropagation();
    html.CheckboxInputElement cb = event.target;
    if (cb.checked) {
      if (selectedItems.contains(item) == false) {
        selectedItems.add(item.itemInstance);
      }
    } else {
      if (selectedItems.contains(item)) {
        selectedItems.remove(item);
      }
    }
  }

  //abre ou fecha menu do dataTable
  void toogleMenu(html.HtmlElement element) {
    element.style.display = element.style.display != 'block' ? 'block' : 'none';
  }

  void onOrder(DataTableColumn dataTableColumn, html.TableCellElement cellHeader) {
    if (enableOrdering == true) {
      if (_orderDir == 'asc') {
        _orderDir = 'desc';
      } else if (_orderDir == 'desc') {
        _orderDir = 'asc';
      }

      dataTableFilter.orderBy = dataTableColumn.key;
      dataTableFilter.orderDir = _orderDir;
      onRequestData();
    }
  }
}
