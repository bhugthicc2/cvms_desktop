import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/features/violation_management/bloc/violation_cubit.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:cvms_desktop/core/widgets/table/table_column_factory.dart';
import 'package:cvms_desktop/core/widgets/app/custom_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViolationTableColumns {
  static List<GridColumn> getColumns({bool showCheckbox = false}) {
    final columns = <GridColumn>[];

    if (showCheckbox) {
      columns.add(
        GridColumn(
          allowSorting: false,
          columnName: 'checkbox',
          width: 50,
          label: Container(
            alignment: Alignment.center,
            child: BlocBuilder<ViolationCubit, ViolationState>(
              builder: (context, state) {
                final allFiltered = state.filteredEntries;
                final allSelected =
                    allFiltered.isNotEmpty &&
                    allFiltered.every(
                      (entry) => state.selectedEntries.contains(entry),
                    );

                return CustomCheckbox(
                  value: allSelected,
                  onChanged: (value) {
                    context.read<ViolationCubit>().selectAllEntries();
                  },
                );
              },
            ),
          ),
        ),
      );
    }

    columns.addAll([
      TableColumnFactory.build(
        name: 'index',
        label: '#',
        width: 50,
        alignment: Alignment.centerLeft,
      ),
      TableColumnFactory.build(
        width: 200,
        name: 'dateTime',
        label: 'Date Time',
        alignment: Alignment.centerLeft,
      ),
      TableColumnFactory.build(
        name: 'reportedBy',
        label: 'Reported By',
        alignment: Alignment.centerLeft,
      ),
      TableColumnFactory.build(
        name: 'plateNumber',
        label: 'Plate Number',
        alignment: Alignment.centerLeft,
      ),
      TableColumnFactory.build(
        name: 'owner',
        label: 'Owner',
        alignment: Alignment.centerLeft,
      ),
      TableColumnFactory.build(
        name: 'violation',
        label: 'Violation',
        alignment: Alignment.centerLeft,
      ),
      TableColumnFactory.build(name: 'status', label: 'Status'),
      // Custom actions column without sorting
      GridColumn(
        columnName: 'actions',
        label: Container(
          alignment: Alignment.center,
          child: const Text(
            'Actions',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: AppFontSizes.small,
              color: AppColors.white,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        allowSorting: false, // This removes the sort icon
      ),
    ]);

    return columns;
  }

  // Keep the original static getter for backward compatibility
  static List<GridColumn> get columns => getColumns();
}
