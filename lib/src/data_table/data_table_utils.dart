import 'package:essential_components/src/core/helper.dart';
import 'package:essential_components/src/core/interfaces/datatable_render_interface.dart';
import 'dart:html' as html;

import 'package:intl/intl.dart';

class DataTableUtils {
  static String truncate(String value, int truncateAt) {
    if (value == null || truncateAt == null) {
      return value;
    }
    //int truncateAt = value.length-1;
    var elepsis = '...'; //define your variable truncation elipsis here
    var truncated = '';

    if (value.length > truncateAt) {
      truncated = value.substring(0, truncateAt - elepsis.length) + elepsis;
    } else {
      truncated = value;
    }
    return truncated;
  }

  static void addEventForChild(parent, eventName, childSelector, cb) {
    parent.addEventListener(eventName, (event) {
      var clickedElement = event.target, matchingChild = clickedElement.closest(childSelector);
      if (matchingChild) {
        cb(matchingChild);
      }
    });
  }

  static String formatCell(DataTableColumn dataTableColumn,
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
        case DataTableColumnType.html:
          tdContent = dataTableColumn.value.toString();
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
      tdContent = dataTableColumn.customRender(cellElement, tdContent);
    }

    if (stripHtml) {
      tdContent = Helper.removeAllHtmlTags(tdContent);
    }

    tdContent = tdContent == 'null' ? '-' : tdContent;
    return tdContent;
  }
}
