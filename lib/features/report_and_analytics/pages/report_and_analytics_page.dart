import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_progress_indicator.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/dashboard/widgets/dashboard_overview.dart';
import 'package:cvms_desktop/features/report_and_analytics/bloc/report_analytics_state.dart';
import 'package:cvms_desktop/features/report_and_analytics/widgets/bar_chart_widget.dart';
import 'package:cvms_desktop/features/report_and_analytics/widgets/donut_chart_widget.dart';
import 'package:cvms_desktop/features/report_and_analytics/widgets/line_chart_widget.dart';
import 'package:cvms_desktop/features/report_and_analytics/widgets/stacked_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/report_analytics_cubit.dart';
import '../data/mock_analytics_data_source.dart';

class ReportAndAnalyticsPage extends StatelessWidget {
  const ReportAndAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => ReportAnalyticsCubit(
            dataSource: MockAnalyticsDataSource(),
          ) //todo add the actual data
          ..loadAll(),
      child: Scaffold(
        backgroundColor: AppColors.greySurface,
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: BlocBuilder<ReportAnalyticsCubit, ReportAnalyticsState>(
            builder: (context, state) {
              if (state.loading) {
                return const Center(child: CustomProgressIndicator());
              }
              if (state.error != null) {
                return Center(child: Text('Error: ${state.error}'));
              }
              return Column(
                children: [
                  const DashboardOverview(),
                  Spacing.vertical(size: AppSpacing.medium),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: DonutChartWidget(
                                  data: state.vehicleDistribution,
                                  title:
                                      'College/Department Vehicle Distribution',
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: BarChartWidget(
                                  data: state.topViolations,
                                  title: 'Top violation',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: LineChartWidget(
                                  data: state.monthlyTrend,
                                  title: 'Monthly trend',
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: StackedBarWidget(
                                  data: state.topViolators,
                                  title: 'Top Violator',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
