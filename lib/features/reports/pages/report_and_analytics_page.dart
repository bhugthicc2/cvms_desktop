import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_progress_indicator.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/dashboard/widgets/sections/dashboard_overview.dart';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard_cubit.dart';
import 'package:cvms_desktop/features/dashboard/data/dashboard_repository.dart';
import 'package:cvms_desktop/features/reports/bloc/report_analytics_state.dart';
import 'package:cvms_desktop/features/reports/data/firestore_analytics_repository.dart';
import 'package:cvms_desktop/features/reports/widgets/charts/bar_chart_widget.dart';
import 'package:cvms_desktop/features/reports/widgets/charts/donut_chart_widget.dart';
import 'package:cvms_desktop/features/reports/widgets/charts/line_chart_widget.dart';
import 'package:cvms_desktop/features/reports/widgets/charts/stacked_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/report_analytics_cubit.dart';

class ReportAndAnalyticsPage extends StatefulWidget {
  const ReportAndAnalyticsPage({super.key});

  @override
  State<ReportAndAnalyticsPage> createState() => _ReportAndAnalyticsPageState();
}

class _ReportAndAnalyticsPageState extends State<ReportAndAnalyticsPage> {
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
        body: BlocBuilder<ReportAnalyticsCubit, ReportAnalyticsState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CustomProgressIndicator());
            }
            if (state.error != null) {
              return Center(child: Text('Error: ${state.error}'));
            }
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.medium),
              child: Column(
                children: [
                  const DashboardOverview(),
                  Spacing.vertical(size: AppSpacing.medium),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: DonutChartWidget(
                            onViewTap: () {},
                            data: state.vehicleDistribution,
                            onDonutChartPointTap: (details) {
                              CustomSnackBar.show(
                                context: context,
                                message:
                                    'Donut Chart Point Clicked: ${details.pointIndex}',
                                type: SnackBarType.success,
                                duration: const Duration(seconds: 3),
                              );
                            },
                            title: 'College/Department Vehicle Distribution',
                          ),
                        ),
                        Spacing.horizontal(size: AppSpacing.medium),
                        Expanded(
                          child: BarChartWidget(
                            onViewTap: () {},
                            onBarChartPointTap: (details) {
                              CustomSnackBar.show(
                                context: context,
                                message:
                                    'Bar Chart Point Clicked: ${details.pointIndex}',
                                type: SnackBarType.success,
                                duration: const Duration(seconds: 3),
                              );
                            },
                            data: state.topViolations,
                            title: 'Top violation',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacing.vertical(size: AppSpacing.medium),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: LineChartWidget(
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
                            data: state.weeklyTrend,
                            title: 'Vehicle Logs for the last',
                          ),
                        ),
                        Spacing.horizontal(size: AppSpacing.medium),
                        Expanded(
                          child: StackedBarWidget(
                            onViewTap: () {},
                            onStackBarPointTapped: (details) {
                              CustomSnackBar.show(
                                context: context,
                                message:
                                    'Stacked Bar Chart Point Clicked: ${details.pointIndex}',
                                type: SnackBarType.success,
                                duration: const Duration(seconds: 3),
                              );
                            },
                            data: state.topViolators,
                            title: 'Student with Most Violations',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
