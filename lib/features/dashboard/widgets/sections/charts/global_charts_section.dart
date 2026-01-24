import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_slide.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/core/widgets/charts/donut_chart_widget.dart';
import 'package:cvms_desktop/core/widgets/charts/stacked_bar_widget.dart';
import 'package:cvms_desktop/core/widgets/charts/bar_chart_widget.dart';
import 'package:cvms_desktop/core/widgets/charts/line_chart_widget.dart';
import 'package:cvms_desktop/features/dashboard/models/dashboard/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard/utils/chart_data_sorter.dart';
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
  final List<ChartDataModel> violationTrendData;
  final Function(String)? onTimeRangeChanged1;
  final Function(String)? onTimeRangeChanged2;
  final String lineChartTitle1;
  final String lineChartTitle2;
  final String vehicleLogsTimeRange;
  final String violationTrendTimeRange;
  final double hoverDy;
  // Chart view tap handlers
  final VoidCallback? onVehicleDistributionTap;
  final VoidCallback? onYearLevelBreakdownTap;
  final VoidCallback? onTopViolatorsTap;
  final VoidCallback? onTopCitiesTap;
  final VoidCallback? onVehicleLogsDistributionTap;
  final VoidCallback? onViolationDistributionTap;
  final VoidCallback? onTopViolationsTap;
  final VoidCallback? onFleetLogsTap;
  final VoidCallback? onViolationTrendTap;

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
    this.onTimeRangeChanged1,
    this.onTimeRangeChanged2,
    required this.lineChartTitle1,
    required this.lineChartTitle2,
    required this.vehicleLogsTimeRange,
    required this.violationTrendTimeRange,
    required this.violationTrendData,
    this.hoverDy = -0.01,
    this.onVehicleDistributionTap,
    this.onYearLevelBreakdownTap,
    this.onTopViolatorsTap,
    this.onTopCitiesTap,
    this.onVehicleLogsDistributionTap,
    this.onViolationDistributionTap,
    this.onTopViolationsTap,
    this.onFleetLogsTap,
    this.onViolationTrendTap,
  });

  @override
  Widget build(BuildContext context) {
    double height = 300;
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
                    'Registered Vehicles by College',
                    vehicleDistribution,
                    onVehicleDistributionTap,
                  ),
                ),
                Spacing.horizontal(size: AppSpacing.medium),
                Expanded(
                  child: _buildDonutChart(
                    'Registered Vehicles by Year Level',
                    yearLevelBreakdown,
                    onYearLevelBreakdownTap,
                  ),
                ),
              ],
            ),
          ),

          Spacing.vertical(size: AppSpacing.medium),

          // Second Row: Top Violators + Cities
          SizedBox(
            height: height + 10,
            child: Row(
              children: [
                Expanded(
                  child: _buildBarChart(
                    'Top 5 Students by Violation Share',
                    studentWithMostViolations,
                    onTopViolatorsTap,
                  ),
                ),
                Spacing.horizontal(size: AppSpacing.medium),
                Expanded(
                  child: _buildBarChart(
                    'Top 5 Cities/Municipalities by Vehicle Share',
                    cityBreakdown,
                    onTopCitiesTap,
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
                    'Vehicle Logs by College',
                    vehicleLogsDistributionPerCollege,
                    onVehicleLogsDistributionTap,
                  ),
                ),
                Spacing.horizontal(size: AppSpacing.medium),
                Expanded(
                  child: _buildDonutChart(
                    'Violation by College',
                    violationDistributionPerCollege,
                    onViolationDistributionTap,
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
                    onTopViolationsTap,
                  ),
                ),
                Spacing.horizontal(size: AppSpacing.medium),
                Expanded(
                  child: _buildLineChart1(
                    lineChartTitle1,
                    fleetLogsData,
                    onFleetLogsTap,
                  ),
                ),
              ],
            ),
          ),

          Spacing.vertical(size: AppSpacing.medium),
          SizedBox(
            height: height + 100,
            child: Expanded(
              child: _buildLineChart2(
                lineChartTitle2,
                violationTrendData,
                onViolationTrendTap,
              ),
            ),
          ),
          Spacing.vertical(size: AppSpacing.medium),
        ],
      ),
    );
  }

  Widget _buildDonutChart(
    String title,
    List<ChartDataModel> data,
    VoidCallback? onViewTap,
  ) {
    // Sort data by value in descending order for legend
    // In UI widget
    final sortedData = ChartDataSorter.sortByValueDescending(data);

    return HoverSlide(
      dx: 0,
      dy: hoverDy,
      child: DonutChartWidget(
        explode: true,
        showPercentageInSlice: false,
        data: sortedData,
        title: title,
        radius: '90%',
        innerRadius: '60%',
        onViewTap: onViewTap ?? () {},
        onDonutChartPointTap: (details) {},
        highlightHighestIndex:
            sortedData.isNotEmpty
                ? 0
                : null, // First item is highest after sorting
      ),
    );
  }

  // Widget _buildStackedChart(
  //   String title,
  //   List<ChartDataModel> data,
  //   VoidCallback? onViewTap,
  // ) {
  //   // Sort data by value in descending order for highlighting
  //   final sortedData = ChartDataSorter.sortByValueDescending(data);

  //   return HoverSlide(
  //     dx: 0,
  //     dy: hoverDy,
  //     child: StackedBarWidget(
  //       title: title,
  //       data: sortedData,
  //       onViewTap: onViewTap ?? () {},
  //       onStackBarPointTapped: (details) {},
  //       highlightHighestIndex:
  //           sortedData.isNotEmpty
  //               ? 0
  //               : null, // First item is highest after sorting
  //     ),
  //   );
  // }

  Widget _buildBarChart(
    String title,
    List<ChartDataModel> data,
    VoidCallback? onViewTap,
  ) {
    // Sort data by value in descending order for highlighting
    final sortedData = ChartDataSorter.sortByValueDescending(data);

    return HoverSlide(
      dx: 0,
      dy: hoverDy,
      child: BarChartWidget(
        data: sortedData,
        title: title,
        onViewTap: onViewTap ?? () {},
        onBarChartPointTap: (details) {},
        highlightHighestIndex:
            sortedData.isNotEmpty
                ? 0
                : null, // First item is highest after sorting
      ),
    );
  }

  Widget _buildLineChart1(
    String title,
    List<ChartDataModel> data,
    VoidCallback? onViewTap,
  ) {
    return HoverSlide(
      dx: 0,
      dy: hoverDy,
      child: LineChartWidget(
        customWidget: CustomDropdown(
          color: AppColors.donutBlue,
          fontSize: 14,
          verticalPadding: 0,
          items: const ['7 days', '30 days', 'Month', 'Year', 'Custom'],
          initialValue: vehicleLogsTimeRange,
          onChanged: (value) {
            onTimeRangeChanged1?.call(value);
          },
        ),
        data: data,
        title: title,
        onViewTap: onViewTap ?? () {},
        onLineChartPointTap: (details) {},
      ),
    );
  }

  Widget _buildLineChart2(
    String title,
    List<ChartDataModel> data,
    VoidCallback? onViewTap,
  ) {
    return HoverSlide(
      dx: 0,
      dy: hoverDy,
      child: LineChartWidget(
        customWidget: CustomDropdown(
          color: AppColors.donutBlue,
          fontSize: 14,
          verticalPadding: 0,
          items: const ['7 days', '30 days', 'Month', 'Year', 'Custom'],
          initialValue: violationTrendTimeRange,
          onChanged: (value) {
            onTimeRangeChanged2?.call(value);
          },
        ),
        data: data,
        title: title,
        onViewTap: onViewTap ?? () {},
        onLineChartPointTap: (details) {},
      ),
    );
  }
}
