import 'package:cvms_desktop/core/models/activity_log.dart';
import 'package:cvms_desktop/core/models/activity_type.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/utils/date_time_formatter.dart';
import 'package:cvms_desktop/core/widgets/app/custom_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart'
    show DataGridSource, DataGridRow, DataGridCell, DataGridRowAdapter;

class ActivityLogsDataSource extends DataGridSource {
  final List<ActivityLog> _originalEntries;
  final bool _showCheckbox;
  final Map<String, String> _userFullnames; // Cache for user fullnames

  late List<DataGridRow> _activityLogEntries;

  ActivityLogsDataSource({
    required List<ActivityLog> activityLogs,
    bool showCheckbox = false,
    required Map<String, String> userFullnames,
  }) : _originalEntries = activityLogs,
       _showCheckbox = showCheckbox,
       _userFullnames = userFullnames {
    _buildRows();
  }

  void _buildRows() {
    _activityLogEntries =
        _originalEntries
            .map<DataGridRow>(
              (e) => DataGridRow(
                cells: [
                  if (_showCheckbox)
                    DataGridCell<bool>(columnName: 'checkbox', value: false),
                  DataGridCell<int>(
                    columnName: 'index',
                    value: _originalEntries.indexOf(e) + 1,
                  ),
                  DataGridCell<String>(columnName: 'type', value: e.type.label),
                  DataGridCell<String>(
                    columnName: 'description',
                    value: e.description,
                  ),
                  DataGridCell<String>(
                    columnName: 'fullname',
                    value: _userFullnames[e.userId] ?? 'System',
                  ),
                  DataGridCell<String>(
                    columnName: 'userId',
                    value: e.userId ?? 'System',
                  ),
                  DataGridCell<String>(
                    columnName: 'targetId',
                    value: e.targetId ?? 'None',
                  ),
                  DataGridCell<String>(
                    columnName: 'timestamp',
                    value: DateTimeFormatter.formatFull(e.timestamp),
                  ),
                  const DataGridCell<String>(columnName: 'actions', value: ''),
                ],
              ),
            )
            .toList();
  }

  @override
  List<DataGridRow> get rows => _activityLogEntries;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final rowIndex = _activityLogEntries.indexOf(row);
    if (rowIndex < 0 || rowIndex >= _originalEntries.length) {
      return null;
    }

    final entry = _originalEntries[rowIndex];
    final isEven = rowIndex.isEven;

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

  Widget _buildCellWidget(DataGridCell cell, ActivityLog entry) {
    switch (cell.columnName) {
      case 'checkbox':
        return Center(
          child: CustomCheckbox(
            value: false, // Will be handled by BLoC
            onChanged: (_) {}, // Will be handled by BLoC
          ),
        );
      case 'index':
        return _text(cell.value.toString(), Alignment.center);
      case 'type':
        return _buildTypeCell(entry.type);

      case 'description':
        return _text(cell.value.toString(), Alignment.centerLeft);

      case 'fullname':
        return _text(cell.value.toString(), Alignment.centerLeft);

      case 'userId':
        return _text(cell.value.toString(), Alignment.centerLeft);

      case 'targetId':
        return _text(cell.value.toString(), Alignment.centerLeft);

      case 'timestamp':
        return _text(cell.value.toString(), Alignment.centerLeft);

      case 'actions':
        return const Center(child: Icon(Icons.more_horiz, size: 20));

      default:
        return _text(cell.value.toString(), Alignment.centerLeft);
    }
  }

  Widget _buildTypeCell(ActivityType type) {
    return Container(
      alignment: Alignment.centerLeft,

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        // decoration: BoxDecoration(
        //   //color: type.color.withValues(alpha: 0.1),
        //   borderRadius: BorderRadius.circular(12),
        //   // border: Border.all(color: type.color.withValues(alpha: 0.3)),
        // ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon(type.icon, size: 16, color: type.color),
            // const SizedBox(width: 4),
            Flexible(
              child: Text(
                type.label,
                style: TextStyle(
                  fontSize: AppFontSizes.small,
                  color: type.color,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _text(String value, Alignment alignment) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        value,
        textAlign:
            alignment == Alignment.center ? TextAlign.center : TextAlign.left,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: const TextStyle(
          fontSize: AppFontSizes.small,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}
