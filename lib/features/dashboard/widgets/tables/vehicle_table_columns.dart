import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:cvms_desktop/core/widgets/table/table_column_factory.dart';

class VehicleTableColumns {
  static List<GridColumn> get columns => [
    TableColumnFactory.build(name: 'index', label: '#', width: 50),
    TableColumnFactory.build(name: 'name', label: 'Name'),
    TableColumnFactory.build(name: 'vehicle', label: 'Vehicle'),
    TableColumnFactory.build(name: 'plateNumber', label: 'Plate Number'),
    TableColumnFactory.build(name: 'duration', label: 'Duration'),
    // Custom actions column without sorting
    GridColumn(
      columnName: 'actions',
      width: 90,
      label: Container(
        alignment: Alignment.center,
        child: const Text(
          'Actions',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: AppFontSizes.small,
            color: AppColors.white,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      allowSorting: false, // This removes the sort icon
    ),
  ];
}
