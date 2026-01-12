import 'package:cvms_desktop/core/widgets/table/table_column_factory.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class VehicleLogsTableColumns {
  static List<GridColumn> getColumns({bool istableHeaderDark = false}) {
    return [
      TableColumnFactory.build(
        hoverScale: 1,
        istableHeaderDark: istableHeaderDark,
        name: 'index',
        label: '#',
        width: 50,
        alignment: Alignment.centerLeft,
      ),
      TableColumnFactory.build(
        hoverScale: 1,
        alignment: Alignment.centerLeft,
        istableHeaderDark: istableHeaderDark,
        name: 'logId',
        label: 'ID',
        width: 100,
      ),
      TableColumnFactory.build(
        hoverScale: 1,
        alignment: Alignment.centerLeft,
        istableHeaderDark: istableHeaderDark,
        name: 'timeIn',
        label: 'TIME IN',
      ),
      TableColumnFactory.build(
        hoverScale: 1,
        alignment: Alignment.centerLeft,
        istableHeaderDark: istableHeaderDark,
        name: 'timeOut',

        label: 'TIME OUT',
      ),
      TableColumnFactory.build(
        hoverScale: 1,
        alignment: Alignment.centerLeft,
        istableHeaderDark: istableHeaderDark,
        name: 'durationMinutes',
        label: 'DURATION',
        width: 140,
      ),
      TableColumnFactory.build(
        hoverScale: 1,
        istableHeaderDark: istableHeaderDark,
        name: 'status',
        label: 'STATUS',
        width: 120,
      ),
      TableColumnFactory.build(
        hoverScale: 1,
        alignment: Alignment.centerLeft,
        istableHeaderDark: istableHeaderDark,
        name: 'updatedBy',
        label: 'UPDATED BY',
      ),
    ];
  }

  // Keep the original static getter for backward compatibility
  static List<GridColumn> get columns => getColumns();
}
