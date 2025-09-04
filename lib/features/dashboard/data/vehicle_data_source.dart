import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/features/dashboard/models/vehicle_entry.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class VehicleEntryDataSource extends DataGridSource {
  VehicleEntryDataSource({required List<VehicleEntry> vehicleEntries}) {
    _vehicleEntries =
        vehicleEntries
            .map<DataGridRow>(
              (e) => DataGridRow(
                cells: [
                  DataGridCell<int>(
                    columnName: 'index',
                    value: vehicleEntries.indexOf(e) + 1,
                  ),
                  DataGridCell<String>(columnName: 'name', value: e.name),
                  DataGridCell<String>(columnName: 'vehicle', value: e.vehicle),
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
                child: const Icon(Icons.more_horiz, size: 20),
              );
            }
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                e.value.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, fontFamily: 'Sora'),
              ),
            );
          }).toList(),
    );
  }
}
