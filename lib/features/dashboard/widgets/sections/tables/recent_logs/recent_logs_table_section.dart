import 'package:cvms_desktop/core/widgets/table/custom_table.dart';
import 'package:cvms_desktop/features/dashboard/models/dashboard/recent_log_entry.dart';
import 'package:cvms_desktop/features/dashboard/widgets/components/tables/dashboard_table.dart';
import 'package:cvms_desktop/features/dashboard/widgets/sections/tables/recent_logs/recent_logs_data_source.dart';
import 'package:cvms_desktop/features/dashboard/widgets/sections/tables/recent_logs/recent_logs_table_columns.dart';
import 'package:flutter/material.dart';

class RecentLogsTableSection extends StatelessWidget {
  final bool istableHeaderDark;
  final bool allowSorting;
  final List<RecentLogEntry> recentLogsEntries;
  final String sectionTitle;
  final VoidCallback onClick;
  final double hoverDy;
  const RecentLogsTableSection({
    super.key,
    required this.istableHeaderDark,
    required this.allowSorting,
    required this.recentLogsEntries,
    required this.sectionTitle,
    required this.onClick,
    this.hoverDy = -0.01,
  });

  @override
  Widget build(BuildContext context) {
    return DashboardTable(
      tableTitle: sectionTitle,
      onClick: onClick,
      hoverDy: hoverDy,
      child: CustomTable(
        isTableHeaderDark: istableHeaderDark,
        allowSorting: allowSorting,
        dataSource: RecentLogsDataSource(recentLogsEntries: recentLogsEntries),
        columns: RecentLogsTableColumns.getColumns(
          istableHeaderDark: istableHeaderDark,
        ),
      ),
    );
  }
}
