import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_grow.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:cvms_desktop/core/widgets/table/table_column_factory.dart';
import 'package:cvms_desktop/core/widgets/app/custom_checkbox.dart';
import 'package:cvms_desktop/features/vehicle_management/bloc/vehicle_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleTableColumns {
  static List<GridColumn> getColumns({
    bool showCheckbox = false,
    bool showStatus = true,
  }) {
    final columns = <GridColumn>[];

    if (showCheckbox) {
      columns.add(
        GridColumn(
          allowSorting: false,
          columnName: 'checkbox',
          width: 50,
          label: HoverGrow(
            cursor: SystemMouseCursors.click,
            child: Container(
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
        ),
      );
    }

    final baseColumns = [
      TableColumnFactory.build(name: 'index', label: '#', width: 50),
      // TableColumnFactory.build(name: 'vehicleID', label: 'Vehicle ID'),
      TableColumnFactory.build(name: 'ownerName', label: 'Owner Name'),
      TableColumnFactory.build(name: 'schoolID', label: 'School ID'),
      TableColumnFactory.build(name: 'department', label: 'Department'),
      TableColumnFactory.build(name: 'plateNumber', label: 'Plate Number'),
      TableColumnFactory.build(name: 'vehicleType', label: 'Vehicle Type'),
      TableColumnFactory.build(name: 'vehicleModel', label: 'Vehicle Model'),
      TableColumnFactory.build(name: 'vehicleColor', label: 'Vehicle Color'),
      TableColumnFactory.build(name: 'licenseNumber', label: 'License Number'),
    ];

    // Only add status column if at least one vehicle has logs
    if (showStatus) {
      baseColumns.add(
        TableColumnFactory.build(name: 'status', label: 'Status'),
      );
    }

    baseColumns.add(
      // TableColumnFactory.build(name: 'createdAt', label: 'Created At'),
      GridColumn(
        columnName: 'actions',
        label: HoverGrow(
          child: Container(
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
        ),
        allowSorting: false,
      ),
    );

    columns.addAll(baseColumns);

    return columns;
  }

  static List<GridColumn> get columns => getColumns();
}
