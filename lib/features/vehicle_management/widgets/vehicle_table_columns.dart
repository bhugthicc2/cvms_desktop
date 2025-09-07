import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:cvms_desktop/core/widgets/table/table_column_factory.dart';
import 'package:cvms_desktop/core/widgets/app/custom_checkbox.dart';
import 'package:cvms_desktop/features/vehicle_management/bloc/vehicle_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleTableColumns {
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
            child: BlocBuilder<VehicleCubit, VehicleState>(
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
                    context.read<VehicleCubit>().selectAllEntries();
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
      TableColumnFactory.build(name: 'name', label: 'Name'),
      TableColumnFactory.build(name: 'vehicle', label: 'Vehicle'),
      TableColumnFactory.build(name: 'SchoolID', label: 'School ID'),
      TableColumnFactory.build(name: 'plateNumber', label: 'Plate Number'),
      TableColumnFactory.build(name: 'vehicleModel', label: 'Vehicle Model'),
      TableColumnFactory.build(name: 'vehicleType', label: 'Vehicle Type'),
      TableColumnFactory.build(name: 'vehicleColor', label: 'Vehicle Color'),
      TableColumnFactory.build(name: 'status', label: 'Status'),
      TableColumnFactory.build(
        name: 'violationStatus',
        label: 'Violation Status',
      ),
      // Custom actions column without sorting
      GridColumn(
        columnName: 'actions',
        label: Container(
          alignment: Alignment.center,
          child: const Text(
            'Actions',
            style: TextStyle(
              fontFamily: 'Sora',
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
