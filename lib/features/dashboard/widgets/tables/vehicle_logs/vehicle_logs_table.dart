import 'package:cvms_desktop/features/dashboard/widgets/datasource/vehicle_logs/vehicle_logs_data_source.dart';
import 'package:cvms_desktop/features/dashboard/widgets/tables/vehicle_logs/vehicle_logs_table_columns.dart';
import 'package:cvms_desktop/core/widgets/table/custom_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/features/dashboard/bloc/reports/reports_cubit.dart';
import 'package:cvms_desktop/features/dashboard/bloc/reports/reports_state.dart';

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
    return BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        final vehicleLogsEntries = state.vehicleLogs ?? [];

        return CustomTable(
          isTableHeaderDark: istableHeaderDark,
          allowSorting: allowSorting,
          dataSource: VehicleLogsDataSource(
            vehicleLogsEntries: vehicleLogsEntries,
          ),
          columns: VehicleLogsTableColumns.getColumns(
            istableHeaderDark: istableHeaderDark,
          ),
        );
      },
    );
  }
}
