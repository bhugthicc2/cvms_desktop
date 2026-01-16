import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/features/activity_logs/bloc/activity_logs_cubit.dart';
import 'package:cvms_desktop/features/activity_logs/bloc/activity_logs_state.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/widgets/table/table_column_factory.dart';
import 'package:cvms_desktop/core/widgets/app/custom_checkbox.dart';

class ActivityLogsTableColumns {
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
            child: BlocBuilder<ActivityLogsCubit, ActivityLogsState>(
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
                    context.read<ActivityLogsCubit>().selectAllEntries();
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
        width: 60,
        alignment: Alignment.center,
      ),
      TableColumnFactory.build(
        name: 'type',
        label: 'Type',
        width: 180,
        alignment: Alignment.centerLeft,
      ),
      TableColumnFactory.build(
        name: 'description',
        label: 'Description',
        alignment: Alignment.centerLeft,
      ),
      TableColumnFactory.build(
        name: 'fullname',
        label: "User's Full Name",
        width: 200,
        alignment: Alignment.centerLeft,
      ),
      TableColumnFactory.build(
        name: 'userId',
        label: 'User ID',
        width: 200,
        alignment: Alignment.centerLeft,
      ),
      TableColumnFactory.build(
        name: 'targetId',
        label: 'Target ID',
        width: 200,
        alignment: Alignment.centerLeft,
      ),
      TableColumnFactory.build(
        name: 'timestamp',
        label: 'Timestamp',
        alignment: Alignment.centerLeft,
      ),
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
              fontFamily: 'Poppins',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        allowSorting: false,
        width: 80,
      ),
    ]);

    return columns;
  }

  static List<GridColumn> get columns => getColumns();
}
