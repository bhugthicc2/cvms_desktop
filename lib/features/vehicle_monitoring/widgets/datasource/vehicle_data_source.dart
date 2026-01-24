import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/features/vehicle_monitoring/models/vehicle_entry.dart';
import 'package:cvms_desktop/features/vehicle_monitoring/widgets/actions/vehicle_actions_menu.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class VehicleEntryDataSource extends DataGridSource {
  final List<VehicleEntry> _originalVehicleEntries;
  final Function(VehicleEntry, int)? onActionTap;
  final BuildContext? context;

  VehicleEntryDataSource({
    required List<VehicleEntry> vehicleEntries,
    this.onActionTap,
    this.context,
  }) : _originalVehicleEntries = vehicleEntries {
    _vehicleEntries =
        vehicleEntries
            .map<DataGridRow>(
              (e) => DataGridRow(
                cells: [
                  DataGridCell<int>(
                    columnName: 'index',
                    value: vehicleEntries.indexOf(e) + 1,
                  ),
                  DataGridCell<String>(
                    columnName: 'ownerName',
                    value: e.ownerName,
                  ),
                  DataGridCell<String>(
                    columnName: 'vehicleModel',
                    value: e.vehicleModel,
                  ),
                  DataGridCell<String>(
                    columnName: 'plateNumber',
                    value: e.plateNumber,
                  ),
                  DataGridCell<String>(
                    columnName: 'duration',
                    value: e.formattedDuration,
                  ),
                  DataGridCell<String>(columnName: 'actions', value: ''),
                ],
              ),
            )
            .toList();
  }

  List<DataGridRow> _vehicleEntries = [];

  @override
  List<DataGridRow> get rows => _vehicleEntries;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final int rowIndex = _vehicleEntries.indexOf(row);
    final bool isEven = rowIndex % 2 == 0;

    return DataGridRowAdapter(
      color:
          isEven
              ? AppColors.white
              : AppColors.dividerColor.withValues(alpha: 0.2),
      cells:
          row.getCells().map<Widget>((e) {
            if (e.columnName == 'actions') {
              return Container(
                alignment: Alignment.center,
                child:
                    context != null
                        ? VehicleActionsMenu(
                          vehicleEntry: _originalVehicleEntries[rowIndex],
                          rowIndex: rowIndex,
                          context: context!,
                        )
                        : InkWell(
                          onTap: () {
                            if (onActionTap != null) {
                              final vehicleEntry =
                                  _originalVehicleEntries[rowIndex];
                              onActionTap!(vehicleEntry, rowIndex);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.more_horiz,
                              size: 20,
                              color: AppColors.grey,
                            ),
                          ),
                        ),
              );
            }
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                e.value.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: AppFontSizes.small,
                  fontFamily: 'Inter',
                ),
              ),
            );
          }).toList(),
    );
  }
}
