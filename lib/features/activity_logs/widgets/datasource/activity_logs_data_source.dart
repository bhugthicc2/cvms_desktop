import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/app/custom_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:cvms_desktop/features/activity_logs/bloc/activity_logs_cubit.dart';
import 'package:cvms_desktop/features/activity_logs/models/activity_entry.dart';
import 'package:cvms_desktop/features/activity_logs/widgets/actions/activity_actions.dart';
import 'package:intl/intl.dart';

class ActivityLogsDataSource extends DataGridSource {
  final List<ActivityLog> _activityLogs;
  final bool _showCheckbox;
  final BuildContext? _context;

  ActivityLogsDataSource({
    required List<ActivityLog> activityLogs,
    bool showCheckbox = false,
    BuildContext? context,
  }) : _activityLogs = activityLogs,
       _showCheckbox = showCheckbox,
       _context = context {
    _buildRows();
  }

  List<DataGridRow> _rows = [];

  @override
  List<DataGridRow> get rows => _rows;

  void updateDataSource(List<ActivityLog> logs) {
    _activityLogs.clear();
    _activityLogs.addAll(logs);
    _buildRows();
    notifyListeners();
  }

  void _buildRows() {
    _rows =
        _activityLogs.map<DataGridRow>((log) {
          return DataGridRow(cells: _buildCells(log));
        }).toList();
  }

  List<DataGridCell> _buildCells(ActivityLog log) {
    final cells = <DataGridCell>[];

    if (_showCheckbox) {
      cells.add(DataGridCell<bool>(columnName: 'checkbox', value: false));
    }

    cells.addAll([
      DataGridCell<String>(
        columnName: 'timestamp',
        value: _formatTimestamp(log.timestamp),
      ),
      DataGridCell<String>(
        columnName: 'type',
        value: _formatActivityType(log.type),
      ),
      DataGridCell<String>(columnName: 'description', value: log.description),
      DataGridCell<String>(
        columnName: 'user',
        value: log.userEmail ?? 'System',
      ),
      DataGridCell<String>(
        columnName: 'target',
        value:
            log.targetId != null ? '${log.targetType}: ${log.targetId}' : 'N/A',
      ),
      DataGridCell<String>(columnName: 'actions', value: ''),
    ]);

    return cells;
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final int rowIndex = _rows.indexOf(row);
    final bool isEven = rowIndex % 2 == 0;
    final ActivityLog log = _activityLogs[rowIndex];

    return DataGridRowAdapter(
      color: isEven ? AppColors.white : AppColors.dividerColor.withAlpha(51),
      cells:
          row.getCells().map<Widget>((cell) {
            return _buildCellWidget(cell, log);
          }).toList(),
    );
  }

  Widget _buildCellWidget(DataGridCell cell, ActivityLog log) {
    switch (cell.columnName) {
      case 'checkbox':
        return BlocBuilder<ActivityLogsCubit, ActivityLogsState>(
          builder: (context, state) {
            final isSelected = state.selectedLogs.contains(log);
            return Container(
              alignment: Alignment.center,
              child: CustomCheckbox(
                value: isSelected,
                onChanged: (value) {
                  context.read<ActivityLogsCubit>().selectLog(log);
                },
              ),
            );
          },
        );

      case 'actions':
        return BlocBuilder<ActivityLogsCubit, ActivityLogsState>(
          builder: (context, state) {
            return Container(
              alignment: Alignment.center,
              child: ActivityActions(log: log, context: context),
            );
          },
        );

      case 'description':
      case 'user':
      case 'target':
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
              fontFamily: 'Sora',
            ),
          ),
        );

      case 'type':
        final type = cell.value.toString();
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            decoration: BoxDecoration(
              color: _getTypeColor(type),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              type,
              style: const TextStyle(
                fontSize: AppFontSizes.small,
                fontFamily: 'Sora',
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );

      default:
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            cell.value.toString(),
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              fontFamily: 'Sora',
            ),
          ),
        );
    }
  }

  // Helper methods
  String _formatTimestamp(DateTime timestamp) {
    return DateFormat('MMM d, y HH:mm:ss').format(timestamp);
  }

  String _formatActivityType(ActivityType type) {
    return type
        .toString()
        .split('.')
        .last
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}')
        .trim();
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'vehicle added':
        return Colors.green;
      case 'vehicle updated':
        return Colors.blue;
      case 'vehicle deleted':
        return Colors.red;
      case 'violation reported':
        return Colors.orange;
      case 'user logged in':
        return Colors.teal;
      case 'user logged out':
        return Colors.purple;
      case 'user created':
        return Colors.green;
      case 'user updated':
        return Colors.blue;
      case 'user deleted':
        return Colors.red;
      case 'password reset':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  @override
  bool shouldRecalculateColumnWidths() => true;
}
