import 'package:cvms_desktop/core/widgets/table/custom_table.dart';
import 'package:cvms_desktop/features/dashboard2/models/violation_history_entry.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/components/tables/dashboard_table.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/sections/tables/violation_history/violation_history_data_source.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/sections/tables/violation_history/violation_history_table_columns.dart';
import 'package:flutter/material.dart';

class ViolationHistoryTableSection extends StatelessWidget {
  final List<ViolationHistoryEntry> violationHistoryEntries;
  final bool allowSorting;
  final bool istableHeaderDark;
  final String sectionTitle;
  final VoidCallback onClick;
  const ViolationHistoryTableSection({
    super.key,
    required this.violationHistoryEntries,
    required this.allowSorting,
    required this.istableHeaderDark,
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
        dataSource: ViolationHistoryDataSource(
          violationHistoryEntries: violationHistoryEntries,
        ),
        columns: ViolationHistoryTableColumns.getColumns(
          istableHeaderDark: istableHeaderDark,
        ),
      ),
    );
  }
}
