import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/dashboard/widgets/charts/bar_chart_widget.dart';
import 'package:cvms_desktop/features/dashboard/widgets/charts/line_chart_widget.dart';
import 'package:flutter/material.dart';
import '../../../data/mock_data.dart';

/// Individual Charts Section - Displays individual vehicle charts including:
/// - Violations by type (bar chart)
/// - Vehicle logs over time (line chart with basic time range selector)
class IndividualChartsSection extends StatelessWidget {
  const IndividualChartsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BarChartWidget(
            onViewTap: () {},
            onBarChartPointTap: (details) {},
            data: ReportMockData.violationTypeData,
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
            data: ReportMockData.vehicleLogsData,
            title: 'Vehicle Logs for the last',
          ),
        ),
      ],
    );
  }
}
