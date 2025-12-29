import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/app/custom_checkbox.dart';
import 'package:cvms_desktop/features/vehicle_management/models/vehicle_entry.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/actions/vehicle_actions_menu.dart';
import 'package:cvms_desktop/core/widgets/table/cell_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../bloc/vehicle_cubit.dart';

class VehicleDataSource extends DataGridSource {
  final List<VehicleEntry> _originalEntries;
  final bool _showCheckbox;
  final BuildContext? _context;

  VehicleDataSource({
    required List<VehicleEntry> vehicleEntries,
    bool showCheckbox = false,
    BuildContext? context,
  }) : _originalEntries = List.of(vehicleEntries),
       _showCheckbox = showCheckbox,
       _context = context {
    _sortByCreatedAtDesc();
    _buildRows();
  }

  // Sort by createdAt in descending order (newest first). Nulls go last.
  void _sortByCreatedAtDesc() {
    _originalEntries.sort((a, b) {
      final aDt = a.createdAt?.toDate();
      final bDt = b.createdAt?.toDate();
      if (aDt == null && bDt == null) return 0;
      if (aDt == null) return 1; // a is null -> after b
      if (bDt == null) return -1; // b is null -> after a
      return bDt.compareTo(aDt); // descending
    });
  }

  void _buildRows() {
    _vehicleEntries =
        _originalEntries
            .map<DataGridRow>((e) => DataGridRow(cells: _buildCells(e)))
            .toList();
  }

  List<DataGridCell> _buildCells(VehicleEntry entry) {
    final cells = <DataGridCell>[];

    if (_showCheckbox) {
      cells.add(DataGridCell<bool>(columnName: 'checkbox', value: false));
    }

    cells.addAll([
      DataGridCell<int>(
        columnName: 'index',
        value: _originalEntries.indexOf(entry) + 1,
      ),
      DataGridCell<String>(columnName: 'ownerName', value: entry.ownerName),
      DataGridCell<String>(columnName: 'schoolID', value: entry.schoolID),
      DataGridCell<String>(columnName: 'department', value: entry.department),
      DataGridCell<String>(columnName: 'plateNumber', value: entry.plateNumber),
      DataGridCell<String>(columnName: 'vehicleType', value: entry.vehicleType),
      DataGridCell<String>(
        columnName: 'vehicleModel',
        value: entry.vehicleModel,
      ),
      DataGridCell<String>(
        columnName: 'vehicleColor',
        value: entry.vehicleColor,
      ),
      DataGridCell<String>(
        columnName: 'licenseNumber',
        value: entry.licenseNumber,
      ),
      DataGridCell<String>(columnName: 'status', value: entry.status),
      DataGridCell<String>(columnName: 'actions', value: ''),
    ]);

    return cells;
  }

  List<DataGridRow> _vehicleEntries = [];

  @override
  List<DataGridRow> get rows => _vehicleEntries;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final int rowIndex = _vehicleEntries.indexOf(row);
    final bool isEven = rowIndex % 2 == 0;
    final VehicleEntry entry = _originalEntries[rowIndex];

    return DataGridRowAdapter(
      color:
          isEven
              ? AppColors.white
              : AppColors.dividerColor.withValues(alpha: 0.2),
      cells:
          row.getCells().map<Widget>((cell) {
            return _buildCellWidget(cell, entry);
          }).toList(),
    );
  }

  Widget _buildCellWidget(DataGridCell cell, VehicleEntry entry) {
    switch (cell.columnName) {
      case 'checkbox':
        return BlocBuilder<VehicleCubit, VehicleState>(
          builder: (context, state) {
            final isSelected = state.selectedEntries.contains(entry);
            return Container(
              alignment: Alignment.center,
              child: CustomCheckbox(
                value: isSelected,
                onChanged: (value) {
                  context.read<VehicleCubit>().selectEntry(entry);
                },
              ),
            );
          },
        );

      case 'ownerName':
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            cell.value.toString(),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              fontFamily: 'Sora',
            ),
          ),
        );

      case 'vehicleModel':
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            cell.value.toString(),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              fontFamily: 'Sora',
            ),
          ),
        );

      case 'actions':
        return BlocBuilder<VehicleCubit, VehicleState>(
          builder: (context, state) {
            if (!state.isBulkModeEnabled && _context != null) {
              final rowIndex = _originalEntries.indexOf(entry);
              return Container(
                alignment: Alignment.center,
                child: VehicleActionsMenu(
                  vehicleEntry: entry,
                  rowIndex: rowIndex,
                  context: _context,
                ),
              );
            } else {
              return Container(
                alignment: Alignment.center,
                child: const Icon(Icons.more_horiz, size: 20),
              );
            }
          },
        );

      case 'status':
        return BlocBuilder<VehicleCubit, VehicleState>(
          builder: (context, state) {
            // Hide status if vehicle has no logs (no transactions yet)
            if (!state.vehiclesWithLogs.contains(entry.vehicleID)) {
              return const SizedBox.shrink();
            }

            final statusStr = cell.value.toString();
            final statusLower = statusStr.toLowerCase();
            final bool isInside = statusLower == 'onsite';
            final bool isOutside = statusLower == 'offsite';

            final Color badgeBg =
                isInside
                    ? AppColors.successLight
                    : isOutside
                    ? AppColors.errorLight
                    : AppColors.grey.withValues(alpha: 0.2);

            final Color textColor =
                isInside
                    ? const Color.fromARGB(255, 31, 144, 11)
                    : isOutside
                    ? AppColors.error
                    : AppColors.black;

            return CellBadge(
              badgeBg: badgeBg,
              textColor: textColor,
              statusStr: statusStr,
              fontSize: AppFontSizes.small,
            );
          },
        );

      default:
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            cell.value.toString(),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              fontFamily: 'Sora',
            ),
          ),
        );
    }
  }
}
