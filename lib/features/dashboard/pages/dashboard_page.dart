import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/core/widgets/skeleton/dashboard_overview_skeleton.dart';
import 'package:cvms_desktop/features/dashboard/widgets/skeletons/bar_chart_skeleton.dart';
import 'package:cvms_desktop/features/dashboard/widgets/skeletons/donut_chart_skeleton.dart';
import 'package:cvms_desktop/features/dashboard/widgets/skeletons/line_chart_skeleton.dart';
import 'package:cvms_desktop/features/dashboard/widgets/skeletons/stacked_bar_skeleton.dart';
import 'package:cvms_desktop/features/dashboard/widgets/sections/dashboard_overview.dart';
import 'package:cvms_desktop/features/dashboard/widgets/views/entered_vehicles_view.dart';
import 'package:cvms_desktop/features/dashboard/widgets/views/exited_vehicles_view.dart';
import 'package:cvms_desktop/features/dashboard/widgets/views/violations_view.dart';
import 'package:cvms_desktop/features/dashboard/widgets/views/all_vehicles_view.dart';
import 'package:cvms_desktop/features/vehicle_monitoring/bloc/vehicle_monitoring_cubit.dart';
import 'package:cvms_desktop/features/vehicle_monitoring/data/vehicle_monitoring_repository.dart';
import 'package:cvms_desktop/features/vehicle_management/bloc/vehicle_cubit.dart';
import 'package:cvms_desktop/features/vehicle_management/data/vehicle_repository.dart';
import 'package:cvms_desktop/features/vehicle_management/data/vehicle_violation_repository.dart';
import 'package:cvms_desktop/features/violation_management/bloc/violation_cubit.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/bloc/vehicle_logs_cubit.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/data/vehicle_logs_repository.dart';
import 'package:cvms_desktop/features/auth/data/auth_repository.dart';
import 'package:cvms_desktop/features/auth/data/user_repository.dart';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard_state.dart';
import 'package:cvms_desktop/features/dashboard/data/firestore_analytics_repository.dart';
import 'package:cvms_desktop/core/widgets/charts/bar_chart_widget.dart';
import 'package:cvms_desktop/core/widgets/charts/donut_chart_widget.dart';
import 'package:cvms_desktop/core/widgets/charts/line_chart_widget.dart';
import 'package:cvms_desktop/core/widgets/charts/stacked_bar_widget.dart';
import 'package:cvms_desktop/features/dashboard/extensions/time_range_extensions.dart';
import 'package:cvms_desktop/features/shell/bloc/shell_cubit.dart';
import 'package:cvms_desktop/features/shell/scope/breadcrumb_scope.dart';
import 'package:cvms_desktop/core/widgets/navigation/bread_crumb_item.dart';
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
  Widget _buildOverviewView(BuildContext context, DashboardState state) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        children: [
          DashboardOverview(
            onEnteredVehiclesClick: () {
              context.read<DashboardCubit>().showEnteredVehicles();
            },
            onExitedVehiclesClick: () {
              context.read<DashboardCubit>().showExitedVehicles();
            },
            onViolationsClick: () {
              context.read<DashboardCubit>().showViolations();
            },
            onAllVehiclesClick: () {
              context.read<DashboardCubit>().showAllVehicles();
            },
          ),
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
                    title: 'Vehicle Distribution per College',
                  ),
                ),
                Spacing.horizontal(size: AppSpacing.medium),
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
                          context.read<DashboardCubit>().changeTimeRange(
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
                    data: state.weeklyTrend,
                    title: 'Vehicle Logs for the last',
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
  }

  List<BreadcrumbItem> _buildBreadcrumbs(
    BuildContext context,
    DashboardState state,
  ) {
    switch (state.viewMode) {
      case DashboardViewMode.overview:
        return const [];
      case DashboardViewMode.enteredVehicles:
        return [const BreadcrumbItem(label: 'Entered Vehicles')];
      case DashboardViewMode.exitedVehicles:
        return [const BreadcrumbItem(label: 'Exited Vehicles')];
      case DashboardViewMode.violations:
        return [const BreadcrumbItem(label: 'Violations')];
      case DashboardViewMode.allVehicles:
        return [const BreadcrumbItem(label: 'All Vehicles')];
    }
  }

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
        // Provide VehicleCubit for AllVehiclesView
        BlocProvider(
          create:
              (_) => VehicleCubit(
                VehicleRepository(),
                AuthRepository(),
                UserRepository(),
                VehicleViolationRepository(),
                VehicleLogsRepository(),
              ),
        ),
        // Provide ViolationCubit for ViolationsView
        BlocProvider(create: (_) => ViolationCubit()),
        // Provide VehicleLogsCubit for Entered/ExitedVehiclesView
        BlocProvider(create: (_) => VehicleLogsCubit(VehicleLogsRepository())),
      ],
      child: Scaffold(
        backgroundColor: AppColors.greySurface,
        body: MultiBlocListener(
          listeners: [
            // Listen to shell index changes to restore breadcrumbs
            BlocListener<ShellCubit, ShellState>(
              listenWhen: (previous, current) {
                return previous.selectedIndex != current.selectedIndex;
              },
              listener: (context, shellState) {
                if (shellState.selectedIndex != 0)
                  return; // Dashboard is index 0

                final dashboardState = context.read<DashboardCubit>().state;
                BreadcrumbScope.controllerOf(
                  context,
                ).setBreadcrumbs(_buildBreadcrumbs(context, dashboardState));
              },
            ),
            // Listen to dashboard state changes to update breadcrumbs
            BlocListener<DashboardCubit, DashboardState>(
              listener: (context, dashboardState) {
                final selectedIndex =
                    context.read<ShellCubit>().state.selectedIndex;
                if (selectedIndex != 0)
                  return; // Only update breadcrumbs if on dashboard page

                BreadcrumbScope.controllerOf(
                  context,
                ).setBreadcrumbs(_buildBreadcrumbs(context, dashboardState));
              },
            ),
          ],
          child: BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
              if (state.loading) {
                return Skeletonizer(
                  enabled: true,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.medium),
                    child: Column(
                      children: [
                        buildSkeletonDashOverview(),
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

              // Switch between different views based on viewMode
              switch (state.viewMode) {
                case DashboardViewMode.overview:
                  return _buildOverviewView(context, state);
                case DashboardViewMode.enteredVehicles:
                  return const EnteredVehiclesView();
                case DashboardViewMode.exitedVehicles:
                  return const ExitedVehiclesView();
                case DashboardViewMode.violations:
                  return const ViolationsView();
                case DashboardViewMode.allVehicles:
                  return const AllVehiclesView();
              }
            },
          ),
        ),
      ),
    );
  }
}
