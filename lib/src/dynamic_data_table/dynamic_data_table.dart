import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular/security.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:essential_components/src/core/enums/pagination_type.dart';
import 'package:essential_components/src/core/helper.dart';
import 'package:essential_components/src/core/interfaces/datatable_render_interface.dart';
import 'package:essential_components/src/core/models/data_table_filter.dart';
import 'package:essential_components/src/core/models/pagination_item.dart';
import 'package:essential_components/src/data_table/data_table_utils.dart';

import 'package:essential_components/src/directives/essential_inner_html_directive.dart';

import 'package:essential_components/src/pipes/truncate_pipe.dart';
import 'package:essential_rest/essential_rest.dart';
import 'package:essential_xlsx/essential_xlsx.dart';
import 'package:intl/intl.dart';
import '../core/string_extensions.dart';

import 'dart:html' as html;

@Component(
  selector: 'es-dynamic-data-table',
  templateUrl: 'dynamic_data_table.html',
  styleUrls: [
    'dynamic_data_table.css',
  ],
  pipes: [commonPipes, TruncatePipe],
  directives: [
    formDirectives,
    coreDirectives,
    EssentialInnerHTMLDirective,
  ],
)
//A Material Design Data table component for AngularDart OnInit AfterChanges AfterViewInit
class EsDynamicDataTableComponent implements AfterChanges, AfterViewInit {
  @ViewChild('tableElement') //HtmlElement
  html.TableElement tableElement;

  @ViewChild('divNoContent')
  html.DivElement divNoContent;

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

  EsDynamicDataTableComponent(this.sanitizer);

  final DomSanitizationService sanitizer;
  //sanitiza o HTML da celula
  SafeHtml getHtmlOfCell(DataTableColumn dataTableColumn, html.TableCellElement cellElement) {
    return sanitizer.bypassSecurityTrustHtml(formatCell(dataTableColumn, cellElement: cellElement));
  }

  @Input()
  int totalRecords = 0;

  int _currentPage = 1;
  final int _btnQuantity = 5;
  String _orderDir = 'asc';
  PaginationType paginationType = PaginationType.carousel;
  List<PaginationItem> paginationItems = <PaginationItem>[];

  @Input()
  bool error = false;

  @Input()
  bool isNoContent = false;

  @Input()
  String noContentMessage = 'Dados indisponiveis';

  @Input()
  String errorMessage =
      'Ocorreu um erro ao listar, verifique sua conexão de rede ou entre em contato com o suporte técnico.';

  bool isLoading = true;
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
  List<DataTableColumn> tableHeaders = <DataTableColumn>[];

  @Input()
  List<String> hideColumns = [];

  @Input()
  int limitColumnTitleCount = 5;

  @Input()
  bool enableLimitColumnTitles = false;

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

  @Input()
  String Function(String) customTitleFormat = (String t) {
    return t?.capitalizeFirstOfEach;
  };

  final RList<DataTableRow> _data = RList<DataTableRow>();
  RList<IDataTableRender> selectedItems = RList<IDataTableRender>();

  DataTableFilter dataTableFilter = DataTableFilter();

  void handleSearchInputKeypress(e) {
    //e.preventDefault();
    e.stopPropagation();
    if (e.keyCode == html.KeyCode.ENTER) {
      onSearch();
    }
  }

  @override
  void ngAfterViewInit() {}

  @override
  void ngAfterChanges() {
    //draw();
    drawPagination();
  }

  Future<void> toXLSX() async {
    if (_data != null) {
      if (_data.isNotEmpty) {
        var simplexlsx = SimpleXLSX();
        simplexlsx.sheetName = 'sheet';

        //adiciona os dados
        var idx = 0;
        _data.forEach((col) {
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
              return formatCell(c, disableLimit: true, stripHtml: true);
            }).toList());
          }
          idx++;
        });

        simplexlsx.build();
      }
    }
  }

  void changeVisibilityOfCol(DataTableColumn col) {
    var visible = !col.visible;
    _data.forEach((row) {
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

  //metodo principal de entrada de dados
  @Input()
  set data(dynamic data) {
    if (data != null) {
      _data.clear();
      //quando o data Table receber um Map<String, dynamic>> JSON
      if (data is List<Map<String, dynamic>>) {
        for (var i = 0; i < data.length; i++) {
          var item = data[i];
          var row = DataTableRow();

          item.forEach((k, value) {
            var visible;
            if (hideColumns.isNotEmpty == true) {
              visible = !hideColumns.contains(k);
            }
            var col = DataTableColumn(
              key: k,
              value: value,
              visible: visible ?? true,
              title: customTitleFormat(k),
            );

            tableHeaders?.forEach((c) {
              if (c == col) {
                col.fillFromDataTableColumn(c);
              }
            });

            row.colsSets.add(col);
          });
          _data.add(row);
        }
      } else if (data is RList<IDataTableRender>) {
        totalRecords = data.totalRecords;
        for (var i = 0; i < data.length; i++) {
          var row = data[i].getRowDefinition();
          if (i == 0) {
            if (hideColumns?.isNotEmpty == true) {
              row.colsSets.forEach((cset) {
                cset.visible = !hideColumns.contains(cset);
              });
            }
            tableHeaders = row.colsSets;
          }
          _data.add(row);
        }
      }
    }
  }

  dynamic get data {
    return _data;
  }

  Iterable<DataTableColumn> get columnHeaders {
    if (_data?.isNotEmpty == true) {
      return _data.first.colsSets;
    }
    return <DataTableColumn>[];
  }

  Iterable<DataTableRow> get columnRows {
    return _data;
  }

  String formatCell(DataTableColumn dataTableColumn,
      {bool disableLimit = false, bool stripHtml = false, html.TableCellElement cellElement}) {
    var tdContent = '';
    if (dataTableColumn.customRender == null) {
      switch (dataTableColumn.type) {
        case DataTableColumnType.date:
          if (dataTableColumn.value != null) {
            var fmt = dataTableColumn.format ?? 'dd/MM/yyyy';
            var formatter = DateFormat(fmt);
            var date = DateTime.tryParse(dataTableColumn.value.toString());
            if (date != null) {
              tdContent = formatter.format(date);
            }
          }
          break;
        case DataTableColumnType.dateTime:
          if (dataTableColumn.value != null) {
            var fmt = dataTableColumn.format ?? 'dd/MM/yyyy HH:mm:ss';
            var formatter = DateFormat(fmt);
            var date = DateTime.tryParse(dataTableColumn.value.toString());
            if (date != null) {
              tdContent = formatter.format(date);
            }
          }
          break;
        case DataTableColumnType.text:
          var str = dataTableColumn.value.toString();
          if (dataTableColumn.limit != null && disableLimit == false) {
            str = DataTableUtils.truncate(str, dataTableColumn.limit);
          }
          str = str == 'null' ? '' : str;
          tdContent = str;
          break;
        case DataTableColumnType.brasilCurrency:
          var str = dataTableColumn.value.toString();
          if (str != '' && str != 'null') {
            final formatCurrency = NumberFormat.simpleCurrency(locale: 'pt_BR');
            str = formatCurrency.format(double.tryParse(str));
            tdContent = str;
          } else {
            tdContent = '';
          }
          break;
        case DataTableColumnType.boolLabel:
          var str = dataTableColumn.value.toString();
          if (stripHtml) {
            tdContent = str;
          } else {
            if (str == 'true') {
              str = '<span class="badge badge-success">Sim</span>';
            } else {
              str = '<span class="badge badge-danger">Não</span>';
            }
          }
          tdContent = str;
          break;
        case DataTableColumnType.badge:
          var str = dataTableColumn.value.toString();
          if (str != '' && str != 'null') {
            if (stripHtml) {
              tdContent = str;
            } else {
              var badgeColor = dataTableColumn.badgeColor != null
                  ? 'background:${dataTableColumn.badgeColor};'
                  : 'background:#e0e0e0;';
              str = '<span class="badge" style="font-size:.8125rem;color:#fff;font-weight:400;$badgeColor">$str</span>';
            }
          } else {
            str = '';
          }
          tdContent = str;
          break;
        case DataTableColumnType.img:
          var src = dataTableColumn.value.toString();
          if (src != 'null') {
            if (stripHtml) {
              tdContent = src;
            } else {
              var img = html.ImageElement();
              img.src = src;
              img.height = 40;
              tdContent = img.outerHtml;
            }
          } else {
            tdContent = '-';
          }
          break;
        default:
          var str = dataTableColumn.value.toString();
          if (dataTableColumn.limit != null) {
            str = DataTableUtils.truncate(str, dataTableColumn.limit);
          }
          tdContent = str;
      }
    } else {
      tdContent = dataTableColumn.customRender(cellElement, dataTableColumn.value.toString());
    }

    if (stripHtml) {
      tdContent = Helper.removeAllHtmlTags(tdContent);
    }

    tdContent = tdContent == 'null' ? '-' : tdContent;
    return tdContent;
  }

  final _rowClickRequest = StreamController<dynamic>();

  @Output()
  Stream<dynamic> get rowClick => _rowClickRequest.stream;

  void onRowClick(item) {
    _rowClickRequest.add(item);
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
    //var cbs = tableElement.querySelectorAll('input[cbselect=true]');
    /*if (event.target.checked) {
      for (html.CheckboxInputElement item in cbs) {
        item.checked = true;
      }
      selectedItems.clear();
      selectedItems.addAll(_data);
    } else {
      selectedItems.clear();
      for (html.CheckboxInputElement item in cbs) {
        item.checked = false;
      }
    }*/
  }

  //quando selecionar um item
  void onSelect(html.MouseEvent event, dynamic item) {
    event.stopPropagation();
    html.CheckboxInputElement cb = event.target;
    if (cb.checked) {
      if (selectedItems.contains(item) == false) {
        selectedItems.add(item);
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
