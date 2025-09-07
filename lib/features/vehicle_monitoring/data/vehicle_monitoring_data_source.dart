import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../models/vehicle_monitoring_entry.dart';

class VehicleMonitoringDataSource extends DataGridSource {
  VehicleMonitoringDataSource({
    required List<VehicleMonitoringEntry> vehicleEntries,
  }) : _vehicleEntries = vehicleEntries;

  final List<VehicleMonitoringEntry> _vehicleEntries;

  @override
  List<DataGridRow> get rows =>
      _vehicleEntries
          .asMap()
          .entries
          .map(
            (entry) => DataGridRow(
              cells: [
                DataGridCell<String>(
                  columnName: 'index',
                  value: '${entry.key + 1}',
                ),
                DataGridCell<String>(
                  columnName: 'name',
                  value: entry.value.name,
                ),
                DataGridCell<String>(
                  columnName: 'vehicle',
                  value: entry.value.vehicle,
                ),
                DataGridCell<String>(
                  columnName: 'plateNumber',
                  value: entry.value.plateNumber,
                ),
                DataGridCell<String>(
                  columnName: 'duration',
                  value:
                      '${entry.value.duration.inHours}h ${entry.value.duration.inMinutes % 60}m',
                ),
                DataGridCell<String>(
                  columnName: 'status',
                  value: entry.value.status,
                ),
              ],
            ),
          )
          .toList();

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells:
          row.getCells().map<Widget>((dataGridCell) {
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                dataGridCell.value.toString(),
                style: const TextStyle(
                  fontFamily: 'Sora',
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
            );
          }).toList(),
    );
  }

  @override
  bool shouldRecalculateColumnWidths() => true;
}
