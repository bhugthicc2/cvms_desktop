import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard/widgets/charts/bar_chart_widget.dart';
import 'package:cvms_desktop/features/dashboard/widgets/charts/donut_chart_widget.dart';
import 'package:cvms_desktop/features/dashboard/widgets/charts/line_chart_widget.dart';
import 'package:cvms_desktop/features/dashboard/extensions/time_range_extensions.dart';
import 'package:cvms_desktop/features/dashboard/widgets/charts/stacked_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/reports/reports_cubit.dart';
import '../../../bloc/reports/reports_state.dart';
import '../../../models/fleet_summary.dart';
import '../../../data/mock_data.dart';

/// Global Charts Section - Displays fleet-wide charts including:
class GlobalChartsSection extends StatefulWidget {
  const GlobalChartsSection({super.key, required this.summary});

  final FleetSummary summary;

  @override
  State<GlobalChartsSection> createState() => _GlobalChartsSectionState();
}

class _GlobalChartsSectionState extends State<GlobalChartsSection> {
  @override
  Widget build(BuildContext context) {
    final deptData =
        widget.summary.departmentLogData.isNotEmpty
            ? widget.summary.departmentLogData
            : ReportMockData.vehicleLogsCollegeData; // Fallback mock if null
    final typesData =
        widget.summary.topViolationTypes
            .map(
              (t) =>
                  ChartDataModel(category: t.type, value: t.count.toDouble()),
            )
            .toList();

    return BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  //Todo Vehicle Distribution per College
                  Expanded(
                    child: DonutChartWidget(
                      explode: true,
                      showPercentageInSlice: false,
                      onViewTap: () {},
                      onDonutChartPointTap: (details) {},
                      data:
                          state.vehicleDistribution ??
                          ReportMockData
                              .vehicleLogsCollegeData, // Use real data with fallback
                      title: 'Vehicle Distribution per College',
                      radius: '90%',
                      innerRadius: '60%',
                    ),
                  ),
                  Spacing.horizontal(size: AppSpacing.medium),
                  //todo year level breakdown
                  Expanded(
                    child: DonutChartWidget(
                      explode: true,
                      showPercentageInSlice: false,
                      onViewTap: () {},
                      onDonutChartPointTap: (details) {},
                      data:
                          state.yearLevelBreakdown ??
                          ReportMockData
                              .yearLevelBreakdownData, // Use real data with fallback
                      title: 'Year Level Breakdown',
                      radius: '90%',
                      innerRadius: '60%',
                    ),
                  ),
                ],
              ),
            ),
            Spacing.vertical(size: AppSpacing.medium),

            Expanded(
              child: Row(
                children: [
                  //todo year level breakdown

                  //Todo Student with Most violation
                  Expanded(
                    child: StackedBarWidget(
                      title: 'Student with most violation',
                      data:
                          state.studentWithMostViolations ??
                          ReportMockData
                              .studentViolationData, // Use real data with fallback
                      onViewTap: () {},
                    ),
                  ),
                  Spacing.horizontal(size: AppSpacing.medium),
                  //todo City/Municipality Breakdown
                  Expanded(
                    child: StackedBarWidget(
                      title: 'City/Municipality Breakdown',
                      data:
                          state.cityBreakdown ??
                          ReportMockData
                              .cityBreakdownData, // Use real data with fallback
                      onViewTap: () {},
                    ),
                  ),
                ],
              ),
            ),
            Spacing.vertical(size: AppSpacing.medium),
            Expanded(
              child: Row(
                children: [
                  //Vehicle Logs Distribution per College
                  Expanded(
                    child: DonutChartWidget(
                      explode: true,
                      showPercentageInSlice: false,
                      onViewTap: () {},
                      onDonutChartPointTap: (details) {},
                      data: deptData, //MOCK
                      title: 'Vehicle Logs Distribution per College',
                      radius: '90%',
                      innerRadius: '60%',
                    ),
                  ),
                  Spacing.horizontal(size: AppSpacing.medium),
                  //Violation distribution per college
                  Expanded(
                    child: DonutChartWidget(
                      explode: true,
                      showPercentageInSlice: false,
                      onViewTap: () {},
                      onDonutChartPointTap: (details) {},
                      // In the violation donut:
                      data:
                          widget.summary.deptViolationData.isNotEmpty
                              ? widget.summary.deptViolationData
                              : ReportMockData.vehicleLogsCollegeData,
                      title: 'Violation Distribution per College',
                      radius: '90%',
                      innerRadius: '60%',
                    ),
                  ),
                ],
              ),
            ),
            Spacing.vertical(size: AppSpacing.medium),
            Expanded(
              child: Row(
                children: [
                  //todo may be add a filter for resolved and pending?c
                  Expanded(
                    child: BarChartWidget(
                      onViewTap: () {},
                      onBarChartPointTap: (details) {},
                      data: typesData,
                      title: 'Top 5 Violations by Type',
                    ),
                  ),
                  Spacing.horizontal(size: AppSpacing.medium),
                  //vehicle logs for the last 7 days for now
                  Expanded(
                    child: LineChartWidget(
                      customWidget: CustomDropdown(
                        color: AppColors.donutBlue,
                        fontSize: 14,
                        verticalPadding: 0,
                        items: const ['7 days', 'Month', 'Year'],
                        initialValue: state.selectedTimeRange.displayName,
                        onChanged: (value) {
                          final timeRange = value.toTimeRange();
                          if (timeRange != null) {
                            context.read<ReportsCubit>().changeTimeRange(
                              timeRange,
                            );
                          }
                        },
                      ),
                      onViewTap: () {},
                      onLineChartPointTap: (details) {
                        CustomSnackBar.show(
                          context: context,
                          message:
                              'Line Chart Point Clicked: ${details.pointIndex}',
                          type: SnackBarType.success,
                          duration: const Duration(seconds: 3),
                        );
                      },
                      data:
                          state.logsData.isNotEmpty
                              ? state.logsData
                              : ReportMockData
                                  .vehicleLogsData, // fallback to mock
                      title: 'Fleet Logs for the last',
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
