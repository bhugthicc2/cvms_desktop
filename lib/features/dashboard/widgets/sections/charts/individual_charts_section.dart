import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_slide.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/core/widgets/charts/bar_chart_widget.dart';
import 'package:cvms_desktop/core/widgets/charts/line_chart_widget.dart';
import 'package:cvms_desktop/features/dashboard/models/dashboard/chart_data_model.dart';
import 'package:flutter/material.dart';

class IndividualChartsSection extends StatelessWidget {
  final List<ChartDataModel> violationDistribution;
  final List<ChartDataModel> vehicleLogs;
  final String lineChartTitle;
  final Function(String)? onTimeRangeChanged;
  final double hoverDy;

  const IndividualChartsSection({
    super.key,
    required this.violationDistribution,
    required this.vehicleLogs,
    required this.lineChartTitle,
    this.onTimeRangeChanged,
    this.hoverDy = -0.01,
  });

  @override
  Widget build(BuildContext context) {
    double height = 280;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.medium,
        AppSpacing.medium,
        AppSpacing.medium,
        0,
      ),
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            Expanded(
              child: _buildBarChart(
                'Violations by Type',
                violationDistribution,
              ),
            ),
            Spacing.horizontal(size: AppSpacing.medium),
            Expanded(child: _buildLineChart(lineChartTitle, vehicleLogs)),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(String title, List<ChartDataModel> data) {
    return HoverSlide(
      dx: 0,
      dy: hoverDy,
      child: BarChartWidget(
        data: data,
        title: title,
        onViewTap: () {},
        onBarChartPointTap: (details) {},
      ),
    );
  }

  Widget _buildLineChart(String title, List<ChartDataModel> data) {
    return HoverSlide(
      dx: 0,
      dy: hoverDy,
      child: LineChartWidget(
        customWidget: CustomDropdown(
          color: AppColors.donutBlue,
          fontSize: 14,
          verticalPadding: 0,
          items: const ['7 days', '30 days', 'Month', 'Year', 'Custom'],
          initialValue: '7 days',
          onChanged: (value) {
            onTimeRangeChanged?.call(value);
          },
        ),
        data: data,
        title: title,
        onViewTap: () {},
        onLineChartPointTap: (details) {},
      ),
    );
  }
}
