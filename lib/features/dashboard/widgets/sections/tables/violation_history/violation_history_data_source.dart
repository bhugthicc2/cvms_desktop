import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/utils/date_time_formatter.dart';
import 'package:cvms_desktop/core/widgets/table/cell_badge.dart';
import 'package:cvms_desktop/features/dashboard/models/dashboard/violation_history_entry.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ViolationHistoryDataSource extends DataGridSource {
  final List<ViolationHistoryEntry> _originalEntries;

  ViolationHistoryDataSource({
    required List<ViolationHistoryEntry> violationHistoryEntries,
  }) : _originalEntries = violationHistoryEntries {
    _buildRows();
  }

  void _buildRows() {
    _violationHistoryEntries =
        _originalEntries
            .map<DataGridRow>((e) => DataGridRow(cells: _buildCells(e)))
            .toList();
  }

  List<DataGridCell> _buildCells(ViolationHistoryEntry entry) {
    return [
      DataGridCell<int>(
        columnName: 'index',
        value: _originalEntries.indexOf(entry) + 1,
      ),
      DataGridCell<String>(columnName: 'violationId', value: entry.violationId),
      DataGridCell<String>(
        columnName: 'dateTime',
        value: DateTimeFormatter.formatFull(entry.dateTime),
      ),
      DataGridCell<String>(
        columnName: 'violationType',
        value: entry.violationType,
      ),
      DataGridCell<String>(columnName: 'reportedBy', value: entry.reportedBy),
      DataGridCell<String>(columnName: 'status', value: entry.status),
      DataGridCell<String>(
        columnName: 'createdAt',
        value: DateTimeFormatter.formatFull(entry.createdAt),
      ),
      DataGridCell<String>(
        columnName: 'lastUpdated',
        value: DateTimeFormatter.formatFull(entry.lastUpdated),
      ),
    ];
  }

  List<DataGridRow> _violationHistoryEntries = [];

  @override
  List<DataGridRow> get rows => _violationHistoryEntries;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final int rowIndex = _violationHistoryEntries.indexOf(row);
    final bool isEven = rowIndex % 2 == 0;
    final ViolationHistoryEntry entry = _originalEntries[rowIndex];

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

  Widget _buildCellWidget(DataGridCell cell, ViolationHistoryEntry entry) {
    switch (cell.columnName) {
      case 'violationId':
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

      case 'violationType':
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

      case 'status':
        final statusStr = cell.value.toString();
        final statusLower = statusStr.toLowerCase();
        final bool isResolved = statusLower == 'resolved';
        final bool isPending = statusLower == 'pending';
        final bool isInProgress = statusLower == 'in progress';

        final Color badgeBg =
            isResolved
                ? AppColors.successLight
                : isPending
                ? AppColors.chartOrange.withValues(alpha: 0.3)
                : isInProgress
                ? AppColors.neutralLight
                : AppColors.grey.withValues(alpha: 0.2);

        final Color textColor =
            isResolved
                ? const Color.fromARGB(255, 31, 144, 11)
                : isPending
                ? AppColors.chartOrange
                : isInProgress
                ? AppColors.neutral
                : AppColors.black;

        return CellBadge(
          horizontalPadding: 24,
          badgeBg: badgeBg,
          textColor: textColor,
          statusStr: statusStr,
          fontSize: AppFontSizes.small,
        );

      default:
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
    }
  }
}
