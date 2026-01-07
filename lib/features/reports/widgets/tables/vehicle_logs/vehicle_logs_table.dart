import 'package:cvms_desktop/features/reports/models/vehicle_logs_model.dart';
import 'package:cvms_desktop/features/reports/widgets/datasource/vehicle_logs/vehicle_logs_data_source.dart';
import 'package:cvms_desktop/features/reports/widgets/tables/vehicle_logs/vehicle_logs_table_columns.dart';
import 'package:cvms_desktop/core/widgets/table/custom_table.dart';
import 'package:flutter/material.dart';

class VehicleLogsTable extends StatelessWidget {
  final bool istableHeaderDark;
  final bool allowSorting;
  const VehicleLogsTable({
    super.key,
    required this.istableHeaderDark,
    required this.allowSorting,
  });

  @override
  Widget build(BuildContext context) {
    // Get mock data
    final vehicleLogsEntries = VehicleLogsEntry.getMockData();

    return CustomTable(
      isTableHeaderDark: istableHeaderDark,
      allowSorting: allowSorting,
      dataSource: VehicleLogsDataSource(vehicleLogsEntries: vehicleLogsEntries),
      columns: VehicleLogsTableColumns.getColumns(
        istableHeaderDark: istableHeaderDark,
      ),
    );
  }
}
