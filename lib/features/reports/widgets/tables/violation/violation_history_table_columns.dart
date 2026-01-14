import 'package:cvms_desktop/core/widgets/table/table_column_factory.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ViolationHistoryTableColumns {
  static List<GridColumn> getColumns({bool istableHeaderDark = false}) {
    return [
      TableColumnFactory.build(
        hoverScale: 1,
        istableHeaderDark: istableHeaderDark,
        name: 'index',
        label: '#',
        width: 50,
      ),
      TableColumnFactory.build(
        hoverScale: 1,
        alignment: Alignment.centerLeft,
        istableHeaderDark: istableHeaderDark,
        name: 'violationId',
        label: 'VIOLATION ID',
        width: 200,
      ),
      TableColumnFactory.build(
        hoverScale: 1,
        alignment: Alignment.centerLeft,
        istableHeaderDark: istableHeaderDark,
        name: 'dateTime',
        label: 'DATE/TIME',
      ),
      TableColumnFactory.build(
        hoverScale: 1,
        alignment: Alignment.centerLeft,
        istableHeaderDark: istableHeaderDark,
        name: 'violationType',
        label: 'VIOLATION TYPE',
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
        istableHeaderDark: istableHeaderDark,
        name: 'status',
        label: 'STATUS',
        width: 140,
      ),
      TableColumnFactory.build(
        hoverScale: 1,
        alignment: Alignment.centerLeft,
        istableHeaderDark: istableHeaderDark,
        name: 'createdAt',
        label: 'CREATED AT',
      ),
      TableColumnFactory.build(
        hoverScale: 1,
        alignment: Alignment.centerLeft,
        istableHeaderDark: istableHeaderDark,
        name: 'lastUpdated',
        label: 'LAST UPDATED',
      ),
    ];
  }

  // Keep the original static getter for backward compatibility
  static List<GridColumn> get columns => getColumns();
}
