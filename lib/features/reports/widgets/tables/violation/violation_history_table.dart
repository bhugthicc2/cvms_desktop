import 'package:cvms_desktop/features/reports/models/violation_history_model.dart';
import 'package:cvms_desktop/features/reports/widgets/datasource/violation/violation_history_data_source.dart';
import 'package:cvms_desktop/features/reports/widgets/tables/violation/violation_history_table_columns.dart';
import 'package:cvms_desktop/core/widgets/table/custom_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/features/reports/bloc/reports/reports_cubit.dart';
import 'package:cvms_desktop/features/reports/bloc/reports/reports_state.dart';

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
    return BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        final violationHistoryEntries = state.violationHistory ?? [];

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
      },
    );
  }
}
