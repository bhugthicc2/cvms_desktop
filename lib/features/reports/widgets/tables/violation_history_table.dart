import 'package:cvms_desktop/features/reports/models/violation_history_model.dart';
import 'package:cvms_desktop/features/reports/widgets/datasource/violation_history_data_source.dart';
import 'package:cvms_desktop/features/reports/widgets/tables/violation_history_table_columns.dart';
import 'package:cvms_desktop/core/widgets/table/custom_table.dart';
import 'package:flutter/material.dart';

class ViolationHistoryTable extends StatelessWidget {
  final bool allowSorting;
  final bool istableHeaderDark;
  const ViolationHistoryTable({
    super.key,
    required this.allowSorting,
    required this.istableHeaderDark,
  });

  @override
  Widget build(BuildContext context) {
    // Get mock data
    final violationHistoryEntries = ViolationHistoryEntry.getMockData();

    return CustomTable(
      isTableHeaderDark: istableHeaderDark,
      allowSorting: allowSorting,
      dataSource: ViolationHistoryDataSource(
        violationHistoryEntries: violationHistoryEntries,
      ),
      columns: ViolationHistoryTableColumns.getColumns(
        istableHeaderDark: istableHeaderDark,
      ),
    );
  }
}
