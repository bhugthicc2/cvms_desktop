import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_progress_indicator.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/dashboard/widgets/sections/dashboard_overview.dart';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard_cubit.dart';
import 'package:cvms_desktop/features/dashboard/data/dashboard_repository.dart';
import 'package:cvms_desktop/features/report_and_analytics/bloc/report_analytics_state.dart';
import 'package:cvms_desktop/features/report_and_analytics/data/firestore_analytics_repository.dart';
import 'package:cvms_desktop/features/report_and_analytics/widgets/charts/bar_chart_widget.dart';
import 'package:cvms_desktop/features/report_and_analytics/widgets/charts/donut_chart_widget.dart';
import 'package:cvms_desktop/features/report_and_analytics/widgets/charts/line_chart_widget.dart';
import 'package:cvms_desktop/features/report_and_analytics/widgets/charts/stacked_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/report_analytics_cubit.dart';

class ReportAndAnalyticsPage extends StatelessWidget {
  const ReportAndAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => ReportAnalyticsCubit(
                dataSource: FirestoreAnalyticsRepository(),
              )..loadAll(),
        ),
        BlocProvider(
          create:
              (_) => DashboardCubit(DashboardRepository())..startListening(),
        ),
      ],
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
                                  //todo retrieve the departments from vehicles collection
                                  data: state.vehicleDistribution,
                                  title:
                                      'College/Department Vehicle Distribution',
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: BarChartWidget(
                                  //retrieve the top 5 violation from violations collection
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
                                  //retrieve the trend from vechicle_logs collection
                                  data: state.weeklyTrend,
                                  title: 'Vehicle Logs for the last 7 days',
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: StackedBarWidget(
                                  //retrieve the top 5 violators from violations collection
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
