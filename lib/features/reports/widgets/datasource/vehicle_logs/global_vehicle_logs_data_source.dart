import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/table/cell_badge.dart';
import 'package:cvms_desktop/features/reports/models/global_vehicle_logs_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class GlobalVehicleLogsDataSource extends DataGridSource {
  final List<GlobalVehicleLogsEntry> _originalEntries;
  List<DataGridRow> _globalVehicleLogsRows = [];

  GlobalVehicleLogsDataSource({
    required List<GlobalVehicleLogsEntry> globalVehicleLogsEntries,
  }) : _originalEntries = globalVehicleLogsEntries {
    _buildRows();
  }

  void _buildRows() {
    _globalVehicleLogsRows =
        _originalEntries
            .map<DataGridRow>((entry) => DataGridRow(cells: _buildCells(entry)))
            .toList();
  }

  List<DataGridCell> _buildCells(GlobalVehicleLogsEntry entry) {
    final index = _originalEntries.indexOf(entry) + 1;
    return [
      DataGridCell<int>(columnName: 'index', value: index),
      DataGridCell<String>(columnName: 'ownerName', value: entry.ownerName),
      DataGridCell<String>(columnName: 'vehicle', value: entry.vehicleModel),
      DataGridCell<String>(columnName: 'plateNumber', value: entry.plateNumber),
      DataGridCell<String>(columnName: 'updatedBy', value: entry.updatedBy),
      DataGridCell<String>(columnName: 'status', value: entry.status),
      DataGridCell<String>(
        columnName: 'timeIn',
        value: _formatDateTime(entry.timeIn),
      ),
      DataGridCell<String>(
        columnName: 'timeOut',
        value: _formatDateTime(entry.timeOut),
      ),
      DataGridCell<String>(columnName: 'duration', value: entry.duration),
    ];
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.month.toString().padLeft(2, '0')}/'
        '${dateTime.day.toString().padLeft(2, '0')}/'
        '${dateTime.year.toString().substring(2)} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  List<DataGridRow> get rows => _globalVehicleLogsRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final entryIndex = row.getCells().first.value - 1;
    final entry = _originalEntries[entryIndex];
    final bool isEven = entryIndex % 2 == 0;

    return DataGridRowAdapter(
      color:
          isEven
              ? AppColors.white
              : AppColors.dividerColor.withValues(alpha: 0.2),
      cells:
          row.getCells().map<Widget>((cell) {
            return _buildCellWidget(cell, entry);
          }).toList(),
    );
  }

  Widget _buildCellWidget(DataGridCell cell, GlobalVehicleLogsEntry entry) {
    switch (cell.columnName) {
      case 'index':
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            cell.value.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      case 'ownerName':
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            cell.value.toString(),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              fontFamily: 'Poppins',
            ),
          ),
        );
      case 'vehicle':
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            cell.value.toString(),
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      case 'plateNumber':
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            cell.value.toString(),
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      case 'updatedBy':
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            cell.value.toString(),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              fontFamily: 'Poppins',
            ),
          ),
        );
      case 'status':
        final statusStr = cell.value.toString();
        final statusLower = statusStr.toLowerCase();
        final bool isActive = statusLower == 'active';
        final bool isCompleted = statusLower == 'completed';

        final Color badgeBg =
            isActive
                ? AppColors.chartOrange.withValues(alpha: 0.3)
                : isCompleted
                ? AppColors.successLight
                : AppColors.grey.withValues(alpha: 0.2);

        final Color textColor =
            isActive
                ? AppColors.chartOrange
                : isCompleted
                ? const Color.fromARGB(255, 31, 144, 11)
                : AppColors.black;

        return CellBadge(
          horizontalPadding: 24,
          badgeBg: badgeBg,
          textColor: textColor,
          statusStr: statusStr,
        );
      case 'timeIn':
      case 'timeOut':
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            cell.value.toString(),
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              fontFamily: 'Poppins',
            ),
          ),
        );
      case 'duration':
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            cell.value.toString(),
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      default:
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            cell.value.toString(),
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              fontFamily: 'Poppins',
            ),
          ),
        );
    }
  }
}
