import 'package:cvms_desktop/core/widgets/table/table_column_factory.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class GlobalVehicleLogsTableColumns {
  static List<GridColumn> getColumns({bool istableHeaderDark = false}) {
    return [
      TableColumnFactory.build(
        hoverScale: 1,
        istableHeaderDark: istableHeaderDark,
        name: 'index',
        label: '#',
        width: 60,
        alignment: Alignment.centerLeft,
      ),
      TableColumnFactory.build(
        hoverScale: 1,
        alignment: Alignment.centerLeft,
        istableHeaderDark: istableHeaderDark,
        name: 'ownerName',
        label: 'OWNER NAME',
      ),
      TableColumnFactory.build(
        hoverScale: 1,
        alignment: Alignment.centerLeft,
        istableHeaderDark: istableHeaderDark,
        name: 'vehicle',
        label: 'VEHICLE',
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
        name: 'updatedBy',
        label: 'UPDATED BY',
      ),
      TableColumnFactory.build(
        hoverScale: 1,
        istableHeaderDark: istableHeaderDark,
        name: 'status',
        label: 'STATUS',
        width: 150,
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
        name: 'duration',
        label: 'DURATION',
      ),
    ];
  }

  // Keep the original static getter for backward compatibility
  static List<GridColumn> get columns => getColumns();
}
