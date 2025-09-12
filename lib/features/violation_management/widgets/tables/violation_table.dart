import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/violation_management/bloc/violation_cubit.dart';
import 'package:cvms_desktop/features/violation_management/widgets/datasource/violation_data_source.dart';
import 'package:cvms_desktop/features/violation_management/models/violation_model.dart';
import 'package:cvms_desktop/features/violation_management/widgets/tables/table_header.dart';
import 'package:cvms_desktop/features/violation_management/widgets/actions/toggle_actions.dart';
import 'package:cvms_desktop/features/violation_management/widgets/tables/violation_table_columns.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/widgets/table/custom_table.dart';

class ViolationTable extends StatelessWidget {
  final String title;
  final List<ViolationEntry> entries;
  final TextEditingController searchController;

  const ViolationTable({
    super.key,
    required this.title,
    required this.entries,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViolationCubit, ViolationState>(
      builder: (context, state) {
        return Column(
          children: [
            TableHeader(searchController: searchController),
            if (state.isBulkModeEnabled) ...[
              Spacing.vertical(size: AppFontSizes.medium),
              ToggleActions(
                resetValue: state.selectedEntries.length.toString(),
                exportValue: state.selectedEntries.length.toString(),
                deleteValue: state.selectedEntries.length.toString(),
                updateValue: state.selectedEntries.length.toString(),
                onExport: () {
                  //todo Handle export QR codes
                  debugPrint(
                    'Exporting QR codes for ${state.selectedEntries.length} entries',
                  );
                },
                onUpdate: () {
                  //todo Handle update status
                  debugPrint(
                    'Updating status for ${state.selectedEntries.length} entries',
                  );
                },
                onDelete: () {
                  //todo Handle delete selected
                  debugPrint(
                    'Deleting ${state.selectedEntries.length} entries',
                  );
                },
                onReset: () {
                  //todo Handle delete selected
                  debugPrint(
                    'Resetting password for ${state.selectedEntries.length} entries',
                  );
                },
              ),
            ],
            Spacing.vertical(size: AppFontSizes.medium),
            Expanded(
              child: CustomTable(
                dataSource: ViolationDataSource(
                  violationEntries: entries,
                  showCheckbox: state.isBulkModeEnabled,
                  context: context,
                ),
                columns: ViolationTableColumns.getColumns(
                  showCheckbox: state.isBulkModeEnabled,
                ),
                onSearchCleared: () {
                  searchController.clear();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
