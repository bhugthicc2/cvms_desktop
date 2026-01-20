import 'package:cvms_desktop/core/widgets/table/custom_table.dart';
import 'package:cvms_desktop/features/dashboard/widgets/tables/vehicle_logs/vehicle_logs_table_columns.dart';
import 'package:cvms_desktop/features/dashboard2/models/dashboard/recent_log_entry.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/components/tables/dashboard_table.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/sections/tables/recent_logs/recent_logs_data_source.dart';
import 'package:flutter/material.dart';

class RecentLogsTableSection extends StatelessWidget {
  final bool istableHeaderDark;
  final bool allowSorting;
  final List<RecentLogEntry> recentLogsEntries;
  final String sectionTitle;
  final VoidCallback onClick;
  const RecentLogsTableSection({
    super.key,
    required this.istableHeaderDark,
    required this.allowSorting,
    required this.recentLogsEntries,
    required this.sectionTitle,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return DashboardTable(
      tableTitle: sectionTitle,
      onClick: onClick,
      child: CustomTable(
        isTableHeaderDark: istableHeaderDark,
        allowSorting: allowSorting,
        dataSource: RecentLogsDataSource(recentLogsEntries: recentLogsEntries),
        columns: VehicleLogsTableColumns.getColumns(
          istableHeaderDark: istableHeaderDark,
        ),
      ),
    );
  }
}
