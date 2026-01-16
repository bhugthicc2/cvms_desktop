import 'package:cvms_desktop/core/models/activity_log.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/activity_logs/bloc/activity_logs_cubit.dart';
import 'package:cvms_desktop/features/activity_logs/bloc/activity_logs_state.dart';
import 'package:cvms_desktop/features/activity_logs/widgets/tables/table_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/widgets/table/custom_table.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../datasource/activity_logs_data_source.dart';
import 'activity_logs_table_columns.dart';

class ActivityLogsTable extends StatefulWidget {
  final String title;
  final List<ActivityLog> logs;
  final Map<String, String> userFullnames;
  final TextEditingController searchController;
  final bool hasSearchQuery;
  final DataGridCellTapCallback? onCellTap;
  final Function(ActivityLog, int)? onActionTap;

  const ActivityLogsTable({
    super.key,
    required this.title,
    required this.logs,
    required this.userFullnames,
    required this.searchController,
    this.hasSearchQuery = false,
    this.onCellTap,
    this.onActionTap,
  });

  @override
  State<ActivityLogsTable> createState() => _ActivityLogsTableState();
}

class _ActivityLogsTableState extends State<ActivityLogsTable> {
  late ActivityLogsDataSource _dataSource;
  final DataGridController _controller = DataGridController();

  @override
  void initState() {
    super.initState();
    _dataSource = ActivityLogsDataSource(
      activityLogs: widget.logs,
      userFullnames: widget.userFullnames,
      showCheckbox: false, // Activity logs are read-only
    );
  }

  @override
  void didUpdateWidget(covariant ActivityLogsTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.logs, widget.logs) ||
        oldWidget.onActionTap != widget.onActionTap ||
        !mapEquals(oldWidget.userFullnames, widget.userFullnames)) {
      _dataSource = ActivityLogsDataSource(
        activityLogs: widget.logs,
        userFullnames: widget.userFullnames,
        showCheckbox: false, // Activity logs are read-only
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityLogsCubit, ActivityLogsState>(
      builder: (context, state) {
        // Update data source when logs change
        _dataSource = ActivityLogsDataSource(
          activityLogs: widget.logs,
          userFullnames: widget.userFullnames,
          showCheckbox: false, // Activity logs are read-only
        );

        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              TableHeader(searchController: widget.searchController),
              Spacing.vertical(size: AppFontSizes.medium),
              Expanded(
                child: CustomTable(
                  gridKey: ValueKey('activityLogsGrid-${widget.title}'),
                  controller: _controller,
                  onCellTap: widget.onCellTap,
                  dataSource: _dataSource,
                  columns: ActivityLogsTableColumns.getColumns(
                    showCheckbox:
                        false, // Activity logs are read-only, no bulk selection
                  ),
                  hasSearchQuery: widget.hasSearchQuery,
                  onSearchCleared: () {
                    widget.searchController.clear();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
