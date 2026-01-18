import 'package:cvms_desktop/core/widgets/table/table_column_factory.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class GlobalViolationHistoryTableColumns {
  static List<GridColumn> getColumns({bool istableHeaderDark = false}) {
    return [
      TableColumnFactory.build(
        hoverScale: 1,
        istableHeaderDark: istableHeaderDark,
        name: 'index',
        label: '#',
        width: 60,
      ),
      TableColumnFactory.build(
        hoverScale: 1,
        alignment: Alignment.centerLeft,
        istableHeaderDark: istableHeaderDark,
        name: 'dateTime',
        label: 'DATE TIME',
      ),
      TableColumnFactory.build(
        hoverScale: 1,
        alignment: Alignment.centerLeft,
        istableHeaderDark: istableHeaderDark,
        name: 'reportedBy',
        label: 'REPORTED BY',
      ),
      TableColumnFactory.build(
        hoverScale: 1,
        alignment: Alignment.centerLeft,
        istableHeaderDark: istableHeaderDark,
        name: 'plateNumber',
        label: 'PLATE NUMBER',
      ),
      TableColumnFactory.build(
        hoverScale: 1,
        alignment: Alignment.centerLeft,
        istableHeaderDark: istableHeaderDark,
        name: 'owner',
        label: 'OWNER',
      ),
      TableColumnFactory.build(
        hoverScale: 1,
        alignment: Alignment.centerLeft,
        istableHeaderDark: istableHeaderDark,
        name: 'violation',
        label: 'VIOLATION',
      ),
      TableColumnFactory.build(
        hoverScale: 1,
        istableHeaderDark: istableHeaderDark,
        name: 'status',
        label: 'STATUS',
      ),
    ];
  }

  // Keep the original static getter for backward compatibility
  static List<GridColumn> get columns => getColumns();
}
