import 'package:cvms_desktop/features/dashboard/models/global_violation_history_model.dart';
import 'package:cvms_desktop/features/dashboard/widgets/datasource/violation/global_violation_history_data_source.dart';
import 'package:cvms_desktop/features/dashboard/widgets/tables/violation/global_violation_history_table_columns.dart';
import 'package:cvms_desktop/core/widgets/table/custom_table.dart';
import 'package:flutter/material.dart';

class GlobalViolationHistoryTable extends StatelessWidget {
  final bool allowSorting;
  final bool istableHeaderDark;

  const GlobalViolationHistoryTable({
    super.key,
    required this.allowSorting,
    required this.istableHeaderDark,
  });

  @override
  Widget build(BuildContext context) {
    // Get mock data - this would show all violations across all vehicles
    final globalViolationHistoryEntries =
        GlobalViolationHistoryEntry.getMockData();

    return CustomTable(
      isTableHeaderDark: istableHeaderDark,
      allowSorting: allowSorting,
      dataSource: GlobalViolationHistoryDataSource(
        globalViolationHistoryEntries: globalViolationHistoryEntries,
      ),
      columns: GlobalViolationHistoryTableColumns.getColumns(
        istableHeaderDark: istableHeaderDark,
      ),
    );
  }
}
