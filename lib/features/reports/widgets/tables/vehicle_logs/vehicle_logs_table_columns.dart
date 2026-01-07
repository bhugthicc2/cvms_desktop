import 'package:cvms_desktop/core/widgets/table/table_column_factory.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class VehicleLogsTableColumns {
  static List<GridColumn> getColumns({bool istableHeaderDark = false}) {
    return [
      TableColumnFactory.build(
        istableHeaderDark: istableHeaderDark,
        name: 'index',
        label: '#',
        width: 50,
      ),
      TableColumnFactory.build(
        istableHeaderDark: istableHeaderDark,
        name: 'logId',
        label: 'Log ID',
        width: 80,
      ),
      TableColumnFactory.build(
        istableHeaderDark: istableHeaderDark,
        name: 'timeIn',
        label: 'Time In',
      ),
      TableColumnFactory.build(
        istableHeaderDark: istableHeaderDark,
        name: 'timeOut',
        label: 'Time Out',
      ),
      TableColumnFactory.build(
        istableHeaderDark: istableHeaderDark,
        name: 'durationMinutes',
        label: 'Duration (Minutes)',
        width: 140,
      ),
      TableColumnFactory.build(
        istableHeaderDark: istableHeaderDark,
        name: 'status',
        label: 'Status',
        width: 120,
      ),
      TableColumnFactory.build(
        alignment: Alignment.centerLeft,
        istableHeaderDark: istableHeaderDark,
        name: 'updatedBy',
        label: 'Updated By',
      ),
    ];
  }

  // Keep the original static getter for backward compatibility
  static List<GridColumn> get columns => getColumns();
}
