import 'package:cvms_desktop/features/sanction_management/bloc/sanction_cubit.dart';
import 'package:cvms_desktop/features/sanction_management/bloc/sanction_state.dart';
import 'package:cvms_desktop/features/sanction_management/models/saction_model.dart';
import 'package:cvms_desktop/features/sanction_management/widgets/datasource/sanction_data_source.dart';
import 'package:cvms_desktop/features/sanction_management/widgets/tables/sanction_table_columns.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/widgets/table/custom_table.dart';

class SanctionTable extends StatelessWidget {
  final String title;
  final List<Sanction> entries;
  final TextEditingController searchController;
  final VoidCallback onView;

  const SanctionTable({
    super.key,
    required this.title,
    required this.entries,
    required this.searchController,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SanctionCubit, SanctionState>(
      builder: (context, state) {
        return Expanded(
          child: CustomTable(
            dataSource: SanctionDataSource(
              sanctionEntries: entries,
              showCheckbox: state.isBulkModeEnabled,
              context: context,
              onView: onView,
            ),
            columns: SanctionTableColumns.getColumns(
              showCheckbox: state.isBulkModeEnabled,
            ),
            onSearchCleared: () {
              searchController.clear();
            },
          ),
        );
      },
    );
  }
}
