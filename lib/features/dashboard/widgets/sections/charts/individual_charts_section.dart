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
  final List<ChartDataModel> violationTrend;
  final String lineChartTitle1;
  final String lineChartTitle2;
  final Function(String)? onTimeRangeChanged1;
  final Function(String)? onTimeRangeChanged2;
  final double hoverDy;

  const IndividualChartsSection({
    super.key,
    required this.violationDistribution,
    required this.vehicleLogs,
    required this.violationTrend,
    required this.lineChartTitle1,
    required this.lineChartTitle2,
    this.onTimeRangeChanged1,
    this.onTimeRangeChanged2,
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
      child: Column(
        children: [
          SizedBox(
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
                Expanded(child: _buildLineChart1(lineChartTitle1, vehicleLogs)),
              ],
            ),
          ),
          Spacing.vertical(size: AppSpacing.medium),
          SizedBox(
            height: height + 20,
            child: Expanded(
              child: _buildLineChart2(lineChartTitle2, violationTrend),
            ),
          ),
        ],
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

  Widget _buildLineChart1(String title1, List<ChartDataModel> data) {
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
            onTimeRangeChanged1?.call(value);
          },
        ),
        data: data,
        title: title1,
        onViewTap: () {},
        onLineChartPointTap: (details) {},
      ),
    );
  }

  Widget _buildLineChart2(String title2, List<ChartDataModel> data) {
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
            onTimeRangeChanged2?.call(value);
          },
        ),
        data: data,
        title: title2,
        onViewTap: () {},
        onLineChartPointTap: (details) {},
      ),
    );
  }
}
