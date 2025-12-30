import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_progress_indicator.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
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
import 'package:cvms_desktop/features/report_and_analytics/widgets/detail_views/top_violations_detail_view.dart';
import 'package:cvms_desktop/features/report_and_analytics/widgets/detail_views/top_violators_detail_view.dart';
import 'package:cvms_desktop/features/report_and_analytics/widgets/detail_views/vehicle_distribution_detail_view.dart';
import 'package:cvms_desktop/features/report_and_analytics/widgets/detail_views/vehicle_logs_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/report_analytics_cubit.dart';

class ReportAndAnalyticsPage extends StatefulWidget {
  const ReportAndAnalyticsPage({super.key});

  @override
  State<ReportAndAnalyticsPage> createState() => _ReportAndAnalyticsPageState();
}

class _ReportAndAnalyticsPageState extends State<ReportAndAnalyticsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
            return Column(
              children: [
                Spacing.vertical(size: AppSpacing.medium),
                TabBar(
                  splashBorderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.medium,
                    vertical: 0,
                  ),
                  tabAlignment: TabAlignment.start,
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.grey,
                  indicatorColor: AppColors.primary,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Overview', height: 30),
                    Tab(text: 'Vehicle Distribution', height: 30),
                    Tab(text: 'Top Violations', height: 30),
                    Tab(text: 'Vehicle Logs', height: 30),
                    Tab(text: 'Top Violators', height: 30),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Overview Tab
                      Padding(
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
                                      onViewTap: () {
                                        _tabController.animateTo(1);
                                      },
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
                                      title:
                                          'College/Department Vehicle Distribution',
                                    ),
                                  ),
                                  Spacing.horizontal(size: AppSpacing.medium),
                                  Expanded(
                                    child: BarChartWidget(
                                      onViewTap: () {
                                        _tabController.animateTo(2);
                                      },
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
                                      onViewTap: () {
                                        _tabController.animateTo(3);
                                      },
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
                                      onViewTap: () {
                                        _tabController.animateTo(4);
                                      },
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
                      ),
                      // Vehicle Distribution Detail Tab
                      VehicleDistributionDetailView(
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
                      ),
                      // Top Violations Detail Tab
                      TopViolationsDetailView(
                        data: state.topViolations,
                        onBarChartPointTap: (details) {
                          CustomSnackBar.show(
                            context: context,
                            message:
                                'Bar Chart Point Clicked: ${details.pointIndex}',
                            type: SnackBarType.success,
                            duration: const Duration(seconds: 3),
                          );
                        },
                      ),
                      // Vehicle Logs Detail Tab
                      VehicleLogsDetailView(
                        data: state.weeklyTrend,
                        onLineChartPointTap: (details) {
                          CustomSnackBar.show(
                            context: context,
                            message:
                                'Line Chart Point Clicked: ${details.pointIndex}',
                            type: SnackBarType.success,
                            duration: const Duration(seconds: 3),
                          );
                        },
                      ),
                      // Top Violators Detail Tab
                      TopViolatorsDetailView(
                        data: state.topViolators,
                        onStackBarPointTapped: (details) {
                          CustomSnackBar.show(
                            context: context,
                            message:
                                'Stacked Bar Chart Point Clicked: ${details.pointIndex}',
                            type: SnackBarType.success,
                            duration: const Duration(seconds: 3),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
