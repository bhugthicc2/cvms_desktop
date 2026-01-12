import 'package:cvms_desktop/features/reports/models/global_vehicle_logs_model.dart';
import 'package:cvms_desktop/features/reports/widgets/datasource/vehicle_logs/global_vehicle_logs_data_source.dart';
import 'package:cvms_desktop/features/reports/widgets/tables/vehicle_logs/global_vehicle_logs_table_columns.dart';
import 'package:cvms_desktop/core/widgets/table/custom_table.dart';
import 'package:flutter/material.dart';

class GlobalVehicleLogsTable extends StatelessWidget {
  final bool istableHeaderDark;
  final bool allowSorting;

  const GlobalVehicleLogsTable({
    super.key,
    required this.istableHeaderDark,
    required this.allowSorting,
  });

  @override
  Widget build(BuildContext context) {
    // Get mock data - this would show all vehicle logs across all vehicles
    final globalVehicleLogsEntries = GlobalVehicleLogsEntry.getMockData();

    return CustomTable(
      isTableHeaderDark: istableHeaderDark,
      allowSorting: allowSorting,
      dataSource: GlobalVehicleLogsDataSource(
        globalVehicleLogsEntries: globalVehicleLogsEntries,
      ),
      columns: GlobalVehicleLogsTableColumns.getColumns(
        istableHeaderDark: istableHeaderDark,
      ),
    );
  }
}
