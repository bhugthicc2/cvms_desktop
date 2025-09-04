import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';

class VehicleTableColumns {
  final AlignmentGeometry align = Alignment.center;
  static List<GridColumn> get columns => [
    GridColumn(columnName: 'index', width: 50, label: _buildHeader('#')),
    GridColumn(columnName: 'name', label: _buildHeader('Name')),
    GridColumn(columnName: 'vehicle', label: _buildHeader('Vehicle')),
    GridColumn(columnName: 'plateNumber', label: _buildHeader('Plate Number')),
    GridColumn(columnName: 'duration', label: _buildHeader('Duration')),
    GridColumn(
      columnName: 'actions',
      width: 80,
      label: _buildHeader('Actions'),
    ),
  ];

  static Widget _buildHeader(String text) => Container(
    alignment: Alignment.center,
    child: Text(
      text,
      style: const TextStyle(
        fontFamily: 'Sora',
        fontWeight: FontWeight.w600,
        fontSize: AppFontSizes.small,
        color: AppColors.white,
      ),
    ),
  );
}
