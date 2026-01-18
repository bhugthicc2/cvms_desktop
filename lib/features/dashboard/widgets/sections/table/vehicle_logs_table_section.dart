import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/card_decor.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/features/dashboard/bloc/reports/reports_cubit.dart';
import 'package:cvms_desktop/features/dashboard/bloc/reports/reports_state.dart';
import 'report_table_header.dart';
import '../../tables/vehicle_logs/vehicle_logs_table.dart';

/// Vehicle Logs Table Section - Displays vehicle logs table with header including:
class VehicleLogsTableSection extends StatelessWidget {
  const VehicleLogsTableSection({super.key, required this.isGlobal});

  final bool isGlobal;

  @override
  Widget build(BuildContext context) {
    return isGlobal == false
        ? Container(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.medium,
            AppSpacing.medium,
            AppSpacing.medium,
            0,
          ),
          decoration: cardDecoration(),
          child: BlocBuilder<ReportsCubit, ReportsState>(
            builder: (context, state) {
              final logCount = state.vehicleLogs?.length ?? 0;
              // Calculate height: header (60) + spacing (16) + rows (45px per row) + bottom padding (20)
              final calculatedHeight = (96.0 + (logCount * 45.0)).clamp(
                150.0,
                600.0,
              );

              return SizedBox(
                height:
                    logCount > 0
                        ? calculatedHeight
                        : 450, //handle the height of empty state illustration
                child: Column(
                  children: [
                    ReportTableHeader(tableTitle: 'Vehicle Logs', onTap: () {}),
                    Spacing.vertical(size: AppSpacing.medium),
                    Expanded(
                      child: VehicleLogsTable(
                        istableHeaderDark: false,
                        allowSorting: true,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        )
        : SizedBox.shrink();
  }
}
