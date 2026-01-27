import 'package:cvms_desktop/features/violation_management/bloc/violation_cubit.dart';
import 'package:cvms_desktop/features/violation_management/widgets/datasource/violation_data_source.dart';
import 'package:cvms_desktop/features/violation_management/models/violation_model.dart';
import 'package:cvms_desktop/features/violation_management/widgets/tables/violation_table_columns.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/widgets/table/custom_table.dart';

class ViolationTable extends StatelessWidget {
  final String title;
  final List<ViolationEntry> entries;
  final TextEditingController searchController;
  final Function(ViolationEntry) onReject;
  final Function(ViolationEntry) onEdit;
  final Function(ViolationEntry) onConfirm;
  final Function(ViolationEntry) onViewMore;

  const ViolationTable({
    super.key,
    required this.title,
    required this.entries,
    required this.searchController,
    required this.onReject,
    required this.onEdit,
    required this.onConfirm,
    required this.onViewMore,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViolationCubit, ViolationState>(
      builder: (context, state) {
        return Expanded(
          child: CustomTable(
            dataSource: ViolationDataSource(
              onReject: onReject,
              onEdit: onEdit,
              onConfirm: onConfirm,
              onViewMore: onViewMore,
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
        );
      },
    );
  }
}
