import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/core/widgets/charts/donut_chart_widget.dart';
import 'package:cvms_desktop/core/widgets/charts/stacked_bar_widget.dart';
import 'package:cvms_desktop/core/widgets/charts/bar_chart_widget.dart';
import 'package:cvms_desktop/core/widgets/charts/line_chart_widget.dart';
import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';
import 'package:flutter/material.dart';

class GlobalChartsSection extends StatelessWidget {
  final List<ChartDataModel> vehicleDistribution;
  final List<ChartDataModel> yearLevelBreakdown;
  final List<ChartDataModel> studentWithMostViolations;
  final List<ChartDataModel> cityBreakdown;
  final List<ChartDataModel> violationTypeDistribution;
  final List<ChartDataModel> vehicleLogsDistributionPerCollege;
  final List<ChartDataModel> violationDistributionPerCollege;
  final List<ChartDataModel> fleetLogsData;

  const GlobalChartsSection({
    super.key,
    required this.vehicleDistribution,
    required this.yearLevelBreakdown,
    required this.studentWithMostViolations,
    required this.cityBreakdown,
    required this.violationTypeDistribution,
    required this.vehicleLogsDistributionPerCollege,
    required this.violationDistributionPerCollege,
    required this.fleetLogsData,
  });

  @override
  Widget build(BuildContext context) {
    double height = 280;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
      child: Column(
        children: [
          // First Row: Vehicle Distribution + Year Level
          SizedBox(
            height: height,
            child: Row(
              children: [
                Expanded(
                  child: _buildDonutChart(
                    'Vehicle Distribution per College',
                    vehicleDistribution,
                  ),
                ),
                Spacing.horizontal(size: AppSpacing.medium),
                Expanded(
                  child: _buildDonutChart(
                    'Year Level Breakdown',
                    yearLevelBreakdown,
                  ),
                ),
              ],
            ),
          ),

          Spacing.vertical(size: AppSpacing.medium),

          // Second Row: Top Violators + Cities
          SizedBox(
            height: height,
            child: Row(
              children: [
                Expanded(
                  child: _buildStackedChart(
                    'Top 5 Students with Most Violations',
                    studentWithMostViolations,
                  ),
                ),
                Spacing.horizontal(size: AppSpacing.medium),
                Expanded(
                  child: _buildStackedChart(
                    'Top 5 Cities/Municipalities',
                    cityBreakdown,
                  ),
                ),
              ],
            ),
          ),

          Spacing.vertical(size: AppSpacing.medium),

          // Third Row: Logs Distribution + Violation Distribution
          SizedBox(
            height: height,
            child: Row(
              children: [
                Expanded(
                  child: _buildDonutChart(
                    'Vehicle Logs Distribution per College',
                    vehicleLogsDistributionPerCollege,
                  ),
                ),
                Spacing.horizontal(size: AppSpacing.medium),
                Expanded(
                  child: _buildDonutChart(
                    'Violation Distribution per College',
                    violationDistributionPerCollege,
                  ),
                ),
              ],
            ),
          ),

          Spacing.vertical(size: AppSpacing.medium),

          // Fourth Row: Top 5 Violations by type + Fleet logs
          SizedBox(
            height: height,
            child: Row(
              children: [
                Expanded(
                  child: _buildBarChart(
                    'Top 5 Violations by Type',
                    violationTypeDistribution,
                  ),
                ),
                Spacing.horizontal(size: AppSpacing.medium),
                Expanded(
                  child: _buildLineChart(
                    'Fleet logs for the last',
                    fleetLogsData,
                  ),
                ),
              ],
            ),
          ),

          Spacing.vertical(size: AppSpacing.medium),
        ],
      ),
    );
  }

  Widget _buildDonutChart(String title, List<ChartDataModel> data) {
    return DonutChartWidget(
      explode: true,
      showPercentageInSlice: false,
      data: data,
      title: title,
      radius: '90%',
      innerRadius: '60%',
      onViewTap: () {},
      onDonutChartPointTap: (details) {},
    );
  }

  Widget _buildStackedChart(String title, List<ChartDataModel> data) {
    return StackedBarWidget(title: title, data: data, onViewTap: () {});
  }

  Widget _buildBarChart(String title, List<ChartDataModel> data) {
    return BarChartWidget(
      data: data,
      title: title,
      onViewTap: () {},
      onBarChartPointTap: (details) {},
    );
  }

  Widget _buildLineChart(String title, List<ChartDataModel> data) {
    return LineChartWidget(
      customWidget: CustomDropdown(
        color: AppColors.donutBlue,
        fontSize: 14,
        verticalPadding: 0,
        items: const ['7 days', 'Month', 'Year'],
        initialValue: '7 days',
        onChanged: (value) {
          //todo
        },
      ),
      data: data,
      title: title,
      onViewTap: () {},
      onLineChartPointTap: (details) {},
    );
  }
}
