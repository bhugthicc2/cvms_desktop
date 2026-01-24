import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/widgets/table/table_column_factory.dart';
import 'package:cvms_desktop/core/widgets/app/custom_checkbox.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/bloc/vehicle_logs_cubit.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/bloc/vehicle_logs_state.dart';

class VehicleLogsTableColumns {
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
            child: BlocBuilder<VehicleLogsCubit, VehicleLogsState>(
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
                    context.read<VehicleLogsCubit>().selectAllEntries();
                  },
                );
              },
            ),
          ),
        ),
      );
    }

    columns.addAll([
      TableColumnFactory.build(name: 'index', label: '#', width: 50),
      TableColumnFactory.build(name: 'fullname', label: 'OnwerName'),
      TableColumnFactory.build(name: 'vehicle', label: 'Vehicle'),
      TableColumnFactory.build(name: 'plateNumber', label: 'Plate Number'),
      TableColumnFactory.build(name: 'updatedBy', label: 'Updated By'),
      TableColumnFactory.build(name: 'status', label: 'Status'),
      TableColumnFactory.build(name: 'timeIn', label: 'Time In'),
      TableColumnFactory.build(name: 'timeOut', label: 'Time Out'),
      TableColumnFactory.build(name: 'duration', label: 'Duration'),
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
              fontFamily: 'Inter',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        allowSorting: false,
      ),
    ]);

    return columns;
  }

  static List<GridColumn> get columns => getColumns();
}
