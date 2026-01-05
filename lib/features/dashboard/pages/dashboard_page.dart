import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/dashboard/widgets/skeletons/bar_chart_skeleton.dart';
import 'package:cvms_desktop/features/dashboard/widgets/skeletons/donut_chart_skeleton.dart';
import 'package:cvms_desktop/features/dashboard/widgets/skeletons/line_chart_skeleton.dart';
import 'package:cvms_desktop/features/dashboard/widgets/skeletons/stacked_bar_skeleton.dart';
import 'package:cvms_desktop/features/vehicle_monitoring/widgets/sections/dashboard_overview.dart';
import 'package:cvms_desktop/features/vehicle_monitoring/bloc/vehicle_monitoring_cubit.dart';
import 'package:cvms_desktop/features/vehicle_monitoring/data/vehicle_monitoring_repository.dart';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard_state.dart';
import 'package:cvms_desktop/features/dashboard/data/firestore_analytics_repository.dart';
import 'package:cvms_desktop/features/dashboard/widgets/charts/bar_chart_widget.dart';
import 'package:cvms_desktop/features/dashboard/widgets/charts/donut_chart_widget.dart';
import 'package:cvms_desktop/features/dashboard/widgets/charts/line_chart_widget.dart';
import 'package:cvms_desktop/features/dashboard/widgets/charts/stacked_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../bloc/dashboard_cubit.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) =>
                  DashboardCubit(dataSource: FirestoreAnalyticsRepository())
                    ..loadAll(),
        ),
        BlocProvider(
          create:
              (_) =>
                  VehicleMonitoringCubit(DashboardRepository())
                    ..startListening(),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.greySurface,
        body: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state.loading) {
              return Skeletonizer(
                enabled: true,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.medium),
                  child: Column(
                    children: [
                      const DashboardOverview(),
                      Spacing.vertical(size: AppSpacing.medium),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: DonutChartSkeleton(onViewTap: () {}),
                            ),
                            Spacing.horizontal(size: AppSpacing.medium),
                            Expanded(
                              child: BarChartSkeleton(
                                title: 'Top violation',
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
                            Expanded(
                              child: LineChartSkeleton(onViewTap: () {}),
                            ),
                            Spacing.horizontal(size: AppSpacing.medium),
                            Expanded(
                              child: StackedBarSkeleton(
                                title: 'Student with Most Violations',
                                onViewTap: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
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
