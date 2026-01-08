import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/utils/date_time_formatter.dart';
import 'package:cvms_desktop/core/widgets/table/cell_badge.dart';
import 'package:cvms_desktop/features/reports/models/vehicle_logs_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class VehicleLogsDataSource extends DataGridSource {
  final List<VehicleLogsEntry> _originalEntries;

  VehicleLogsDataSource({required List<VehicleLogsEntry> vehicleLogsEntries})
    : _originalEntries = vehicleLogsEntries {
    _buildRows();
  }

  void _buildRows() {
    _vehicleLogsEntries =
        _originalEntries
            .map<DataGridRow>((e) => DataGridRow(cells: _buildCells(e)))
            .toList();
  }

  List<DataGridCell> _buildCells(VehicleLogsEntry entry) {
    return [
      DataGridCell<int>(
        columnName: 'index',
        value: _originalEntries.indexOf(entry) + 1,
      ),
      DataGridCell<String>(columnName: 'logId', value: entry.logId),
      DataGridCell<String>(
        columnName: 'timeIn',
        value: DateTimeFormatter.formatNumeric(entry.timeIn),
      ),
      DataGridCell<String>(
        columnName: 'timeOut',
        value: DateTimeFormatter.formatNumeric(entry.timeOut),
      ),
      DataGridCell<int>(
        columnName: 'durationMinutes',
        value: entry.durationMinutes,
      ),
      DataGridCell<String>(columnName: 'status', value: entry.status),
      DataGridCell<String>(columnName: 'updatedBy', value: entry.updatedBy),
    ];
  }

  List<DataGridRow> _vehicleLogsEntries = [];

  @override
  List<DataGridRow> get rows => _vehicleLogsEntries;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final int rowIndex = _vehicleLogsEntries.indexOf(row);
    final bool isEven = rowIndex % 2 == 0;
    final VehicleLogsEntry entry = _originalEntries[rowIndex];

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

  Widget _buildCellWidget(DataGridCell cell, VehicleLogsEntry entry) {
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
            ),
          ),
        );
      case 'logId':
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

      case 'timeIn':
      case 'timeOut':
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            cell.value.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              fontFamily: 'Poppins',
            ),
          ),
        );

      case 'durationMinutes':
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            '${cell.value} min',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              fontFamily: 'Poppins',
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
                ? AppColors.successLight
                : isCompleted
                ? AppColors.neutralLight
                : AppColors.grey.withValues(alpha: 0.2);

        final Color textColor =
            isActive
                ? const Color.fromARGB(255, 31, 144, 11)
                : isCompleted
                ? AppColors.neutral
                : AppColors.black;

        return CellBadge(
          horizontalPadding: 12,
          badgeBg: badgeBg,
          textColor: textColor,
          statusStr: statusStr,
          fontSize: AppFontSizes.small,
        );

      default:
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            cell.value.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              fontFamily: 'Poppins',
            ),
          ),
        );
    }
  }
}
