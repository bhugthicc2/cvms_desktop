import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/core/widgets/charts/bar_chart_widget.dart';
import 'package:cvms_desktop/core/widgets/charts/line_chart_widget.dart';
import 'package:cvms_desktop/features/dashboard/bloc/reports/reports_cubit.dart';
import 'package:cvms_desktop/features/dashboard/bloc/reports/reports_state.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';

/// Individual Charts Section - Displays individual vehicle charts including:
class IndividualChartsSection extends StatelessWidget {
  const IndividualChartsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        final violationsByType = state.violationsByType ?? [];
        final vehicleLogsForLast7Days = state.vehicleLogsForLast7Days ?? [];

        return Row(
          children: [
            Expanded(
              child: BarChartWidget(
                onViewTap: () {},
                onBarChartPointTap: (details) {},
                data: violationsByType,
                title: 'Violation by Type',
              ),
            ),
            Spacing.horizontal(size: AppSpacing.medium),
            Expanded(
              child: LineChartWidget(
                customWidget: CustomDropdown(
                  color: AppColors.donutBlue,
                  fontSize: 14,
                  verticalPadding: 0,
                  items: const ['7 days', 'Month', 'Year'],
                  initialValue: '7 days',
                  onChanged: (value) {}, // Stub—wire if needed
                ),
                onViewTap: () {},
                onLineChartPointTap: (details) {},
                data: vehicleLogsForLast7Days,
                title: 'Vehicle Logs for the last',
              ),
            ),
          ],
        );
      },
    );
  }
}
