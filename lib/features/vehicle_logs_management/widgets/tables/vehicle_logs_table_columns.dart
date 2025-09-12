import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter/material.dart';
import 'package:cvms_desktop/core/widgets/table/table_column_factory.dart';

class VehicleLogsTableColumns {
  static List<GridColumn> get columns => [
    TableColumnFactory.build(name: 'index', label: '#', width: 50),
    TableColumnFactory.build(name: 'fullname', label: 'Name'),
    TableColumnFactory.build(name: 'vehicle', label: 'Vehicle'),
    TableColumnFactory.build(name: 'plateNumber', label: 'Plate Number'),
    TableColumnFactory.build(name: 'updatedBy', label: 'Updated By'),
    TableColumnFactory.build(name: 'status', label: 'Status'),
    TableColumnFactory.build(name: 'timeIn', label: 'Time In'),
    TableColumnFactory.build(name: 'timeOut', label: 'Time Out'),
    TableColumnFactory.build(name: 'duration', label: 'Duration'),
    GridColumn(
      columnName: 'actions',
      label: Container(
        alignment: Alignment.center,
        child: const Text(
          'Actions',
          style: TextStyle(
            fontFamily: 'Sora',
            fontWeight: FontWeight.w600,
            fontSize: AppFontSizes.small,
            color: AppColors.white,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      allowSorting: false,
    ),
  ];
}
