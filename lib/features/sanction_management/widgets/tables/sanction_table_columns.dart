import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/features/sanction_management/bloc/sanction_cubit.dart';
import 'package:cvms_desktop/features/sanction_management/bloc/sanction_state.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:cvms_desktop/core/widgets/table/table_column_factory.dart';
import 'package:cvms_desktop/core/widgets/app/custom_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SanctionTableColumns {
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
            child: BlocBuilder<SanctionCubit, SanctionState>(
              builder: (context, state) {
                final allFiltered = state.sanctions;
                final allSelected =
                    allFiltered.isNotEmpty &&
                    allFiltered.every(
                      (entry) => state.selectedEntries.contains(entry),
                    );

                return CustomCheckbox(
                  value: allSelected,
                  onChanged: (value) {
                    context.read<SanctionCubit>().selectAllEntries();
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
        width: 150,
        name: 'vehicleId',
        label: 'Vehicle ID',
        alignment: Alignment.centerLeft,
      ),
      TableColumnFactory.build(
        name: 'offenseNumber',
        label: 'Offense Number',
        alignment: Alignment.centerLeft,
      ),
      TableColumnFactory.build(
        name: 'sanctionType',
        label: 'Sanction Type',
        alignment: Alignment.centerLeft,
      ),
      TableColumnFactory.build(
        name: 'status',
        label: 'Status',
        alignment: Alignment.centerLeft,
      ),
      TableColumnFactory.build(
        name: 'startDate',
        label: 'Start Date',
        alignment: Alignment.centerLeft,
      ),
      TableColumnFactory.build(
        name: 'endDate',
        label: 'End Date',
        alignment: Alignment.centerLeft,
      ),
      // Custom actions column without sorting
      GridColumn(
        columnName: 'actions',
        label: Container(
          alignment: Alignment.center,
          child: const Text(
            'Actions',
            style: TextStyle(
              fontFamily: 'Inter',
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
