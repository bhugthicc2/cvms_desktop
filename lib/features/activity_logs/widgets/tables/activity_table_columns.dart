import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/table/table_column_factory.dart';
import 'package:cvms_desktop/core/widgets/app/custom_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';
import 'package:cvms_desktop/features/activity_logs/bloc/activity_logs_cubit.dart';
import 'package:cvms_desktop/features/activity_logs/models/activity_entry.dart';

class ActivityTableColumns {
  static final _dateFormat = DateFormat('MMM d, y HH:mm:ss');

  static List<GridColumn> getColumns({bool showCheckbox = false}) {
    final columns = <GridColumn>[];

    // Checkbox column for bulk selection
    if (showCheckbox) {
      columns.add(
        GridColumn(
          allowSorting: false,
          columnName: 'checkbox',
          width: 50,
          label: Container(
            alignment: Alignment.center,
            child: BlocBuilder<ActivityLogsCubit, ActivityLogsState>(
              builder: (context, state) {
                final allFiltered = state.filteredLogs;
                final allSelected =
                    allFiltered.isNotEmpty &&
                    allFiltered.every(
                      (log) => state.selectedLogs.contains(log),
                    );

                return CustomCheckbox(
                  value: allSelected,
                  onChanged: (value) {
                    // todo context.read<ActivityLogsCubit>().toggleSelectAllLogs();
                  },
                );
              },
            ),
          ),
        ),
      );
    }

    columns.addAll([
      // Timestamp Column
      TableColumnFactory.build(
        name: 'timestamp',
        label: 'Timestamp',
        width: 180,
        alignment: Alignment.centerLeft,
        // cellBuilder: (context, log) {
        //   return Text(
        //     _formatTimestamp(log.timestamp),
        //     style: const TextStyle(fontSize: 13),
        //     overflow: TextOverflow.ellipsis,
        //   );
        // },
      ),

      // Activity Type Column
      TableColumnFactory.build(
        name: 'type',
        label: 'Activity Type',
        width: 150,
        alignment: Alignment.centerLeft,
        // cellBuilder: (context, log) {
        //   return Container(
        //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        //     decoration: BoxDecoration(
        //       color: _getTypeColor(log.type).withValues( alpha:0.1),
        //       borderRadius: BorderRadius.circular(12),
        //     ),
        //     child: Text(
        //       _formatActivityType(log.type),
        //       style: TextStyle(
        //         color: _getTypeColor(log.type),
        //         fontSize: 12,
        //         fontWeight: FontWeight.w500,
        //       ),
        //     ),
        //   );
        // },
      ),

      // Description Column
      TableColumnFactory.build(
        name: 'description',
        label: 'Description',
        width: 250,
        alignment: Alignment.centerLeft,
        // cellBuilder: (context, log) {
        //   return Text(
        //     log.description,
        //     style: const TextStyle(fontSize: 13),
        //     maxLines: 2,
        //     overflow: TextOverflow.ellipsis,
        //   );
        // },
      ),

      // User Column
      TableColumnFactory.build(
        name: 'user',
        label: 'User',
        width: 200,
        alignment: Alignment.centerLeft,
        // cellBuilder: (context, log) {
        //   return Text(
        //     log.userEmail ?? 'System',
        //     style: const TextStyle(fontSize: 13),
        //     overflow: TextOverflow.ellipsis,
        //   );
        // },
      ),

      // Target Column
      TableColumnFactory.build(
        name: 'target',
        label: 'Target',
        width: 180,
        alignment: Alignment.centerLeft,
        // cellBuilder: (context, log) {
        //   return Text(
        //     log.targetType != null ? '${log.targetType}: ${log.targetId ?? 'N/A'}' : 'N/A',
        //     style: const TextStyle(fontSize: 13),
        //     overflow: TextOverflow.ellipsis,
        //   );
        // },
      ),

      // Actions Column
      GridColumn(
        columnName: 'actions',
        width: 100,
        label: Container(
          alignment: Alignment.center,
          child: const Text(
            'Actions',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: AppFontSizes.small,
              color: AppColors.black,
            ),
          ),
        ),
        allowSorting: false,
      ),
    ]);

    return columns;
  }

  // Helper Methods
  static String _formatTimestamp(DateTime timestamp) {
    return _dateFormat.format(timestamp);
  }

  static String _formatActivityType(ActivityType type) {
    return type
        .toString()
        .split('.')
        .last
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}')
        .trim();
  }

  static Color _getTypeColor(ActivityType type) {
    switch (type) {
      case ActivityType.vehicleAdded:
      case ActivityType.vehicleUpdated:
        return AppColors.success;
      case ActivityType.vehicleDeleted:
        return AppColors.error;
      case ActivityType.userLoggedIn:
      case ActivityType.userLoggedOut:
        return AppColors.grey;
      case ActivityType.violationReported:
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  // Keep the original static getter for backward compatibility
  static List<GridColumn> get columns => getColumns();
}
