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
import 'package:cvms_desktop/features/report_and_analytics/widgets/charts/overview/bar_chart_widget.dart';
import 'package:cvms_desktop/features/report_and_analytics/widgets/charts/overview/donut_chart_widget.dart';
import 'package:cvms_desktop/features/report_and_analytics/widgets/charts/overview/line_chart_widget.dart';
import 'package:cvms_desktop/features/report_and_analytics/widgets/charts/overview/stacked_bar_widget.dart';
import 'package:cvms_desktop/features/report_and_analytics/pages/vehicle_report_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/report_analytics_cubit.dart';

class ReportAndAnalyticsPage extends StatefulWidget {
  final TabController? tabController;

  const ReportAndAnalyticsPage({super.key, this.tabController});

  @override
  State<ReportAndAnalyticsPage> createState() => _ReportAndAnalyticsPageState();
}

class _ReportAndAnalyticsPageState extends State<ReportAndAnalyticsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        widget.tabController ?? TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    if (widget.tabController == null) {
      _tabController.dispose();
    }
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
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.medium),
              child: Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      //clipBehavior: Clip.none,
                      controller: _tabController,
                      children: [
                        // Tab 0: Overview (original content)
                        Column(
                          children: [
                            const DashboardOverview(angle: 0.005), //stats card
                            Spacing.vertical(size: AppSpacing.medium),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: DonutChartWidget(
                                      onViewTap: () {
                                        // Optional: Adjust for 2-tab setup, e.g., stay on overview
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
                                        // Optional: Adjust for 2-tab setup
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
                                        // Optional: Adjust for 2-tab setup
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
                                        // Optional: Adjust for 2-tab setup
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
                        // Tab 1: Vehicle Report
                        const VehicleReportPage(),
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
