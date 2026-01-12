import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/table/cell_badge.dart';
import 'package:cvms_desktop/features/reports/models/global_violation_history_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class GlobalViolationHistoryDataSource extends DataGridSource {
  final List<GlobalViolationHistoryEntry> _originalEntries;
  List<DataGridRow> _globalViolationHistoryRows = [];

  GlobalViolationHistoryDataSource({
    required List<GlobalViolationHistoryEntry> globalViolationHistoryEntries,
  }) : _originalEntries = globalViolationHistoryEntries {
    _buildRows();
  }

  void _buildRows() {
    _globalViolationHistoryRows =
        _originalEntries
            .map<DataGridRow>((entry) => DataGridRow(cells: _buildCells(entry)))
            .toList();
  }

  List<DataGridCell> _buildCells(GlobalViolationHistoryEntry entry) {
    final index = _originalEntries.indexOf(entry) + 1;
    return [
      DataGridCell<int>(columnName: 'index', value: index),
      DataGridCell<String>(
        columnName: 'dateTime',
        value: entry.formattedDateTime,
      ),
      DataGridCell<String>(columnName: 'reportedBy', value: entry.reportedBy),
      DataGridCell<String>(columnName: 'plateNumber', value: entry.plateNumber),
      DataGridCell<String>(columnName: 'owner', value: entry.owner),
      DataGridCell<String>(columnName: 'violation', value: entry.violation),
      DataGridCell<String>(columnName: 'status', value: entry.status),
    ];
  }

  @override
  List<DataGridRow> get rows => _globalViolationHistoryRows;

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

  Widget _buildCellWidget(
    DataGridCell cell,
    GlobalViolationHistoryEntry entry,
  ) {
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
      case 'dateTime':
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
      case 'reportedBy':
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
      case 'owner':
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
      case 'violation':
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            cell.value.toString(),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      case 'status':
        final statusStr = cell.value.toString();
        final statusLower = statusStr.toLowerCase();
        final bool isResolved = statusLower == 'resolved';
        final bool isPending = statusLower == 'pending';

        final Color badgeBg =
            isResolved
                ? AppColors.successLight
                : isPending
                ? AppColors.chartOrange.withValues(alpha: 0.3)
                : AppColors.grey.withValues(alpha: 0.2);

        final Color textColor =
            isResolved
                ? const Color.fromARGB(255, 31, 144, 11)
                : isPending
                ? AppColors.chartOrange
                : AppColors.black;

        return CellBadge(
          horizontalPadding: 24,
          badgeBg: badgeBg,
          textColor: textColor,
          statusStr: statusStr,
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
