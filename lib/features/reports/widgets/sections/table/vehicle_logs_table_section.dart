import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/card_decor.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';
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
          constraints: BoxConstraints(maxHeight: 400),
          decoration: cardDecoration(),
          child: Column(
            children: [
              ReportTableHeader(tableTitle: 'Vehicle Logs', onTap: () {}),
              Spacing.vertical(size: AppSpacing.medium),
              Expanded(
                child: const VehicleLogsTable(
                  istableHeaderDark: false,
                  allowSorting: true,
                ),
              ),
            ],
          ),
        )
        : SizedBox.shrink();
  }
}
