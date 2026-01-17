//ISSUE:
// StateError (Bad state: Cannot emit new states after calling close)
// happens during switching screens when the reports page is on loading state

import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/card_decor.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/reports/pages/views/pdf_report_page.dart';
import 'package:cvms_desktop/features/reports/widgets/loader/report_loader.dart';
import 'package:cvms_desktop/features/reports/widgets/sections/stats/global_stats_section.dart';
import 'package:cvms_desktop/features/reports/widgets/sections/stats/individual_stats_and_info_section.dart';
import 'package:cvms_desktop/features/reports/widgets/sections/charts/global_charts_section.dart';
import 'package:cvms_desktop/features/reports/widgets/sections/charts/individual_charts_section.dart';
import 'package:cvms_desktop/features/reports/widgets/sections/table/violations_table_section.dart';
import 'package:cvms_desktop/features/reports/widgets/sections/table/vehicle_logs_table_section.dart';

import 'package:cvms_desktop/features/reports/widgets/app/report_header_section.dart';
import 'package:cvms_desktop/features/shell/scope/breadcrumb_scope.dart';
import 'package:cvms_desktop/features/shell/bloc/shell_cubit.dart';
import 'package:cvms_desktop/core/widgets/navigation/bread_crumb_item.dart';
import 'package:cvms_desktop/core/widgets/animation/animated_switcher.dart'
    as custom;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';
import '../../bloc/reports/reports_cubit.dart';
import '../../bloc/reports/reports_state.dart';
import '../../widgets/content/date_filter_content.dart';

class ReportsPage extends StatelessWidget {
  static const int reportsPageIndex = 6;
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ReportsPageContent();
  }
}

class _ReportsPageContent extends StatefulWidget {
  const _ReportsPageContent();

  @override
  State<_ReportsPageContent> createState() => _ReportsPageContentState();
}

class _ReportsPageContentState extends State<_ReportsPageContent> {
  final ScreenshotController _vehicleDistributionController =
      ScreenshotController();
  final ScreenshotController _yearLevelBreakdownController =
      ScreenshotController();
  final ScreenshotController _studentWithMostViolationsController =
      ScreenshotController();
  final ScreenshotController _cityBreakdownController = ScreenshotController();
  final ScreenshotController _vehicleLogsDistributionController =
      ScreenshotController();
  final ScreenshotController _violationDistributionPerCollegeController =
      ScreenshotController();
  final ScreenshotController _top5ViolationByTypeController =
      ScreenshotController();
  final ScreenshotController _fleetLogsController = ScreenshotController();

  Future<void> _handleExportPdf(BuildContext context) async {
    await context.read<ReportsCubit>().captureChartsAndShowPdfPreview(
      vehicleDistributionCapture:
          () => _vehicleDistributionController.capture(),
      yearLevelBreakdownCapture: () => _yearLevelBreakdownController.capture(),
      studentWithMostViolationsCapture:
          () => _studentWithMostViolationsController.capture(),
      cityBreakdownCapture: () => _cityBreakdownController.capture(),
      vehicleLogsDistributionCapture:
          () => _vehicleLogsDistributionController.capture(),
      violationDistributionPerCollegeCapture:
          () => _violationDistributionPerCollegeController.capture(),
      top5ViolationByTypeCapture:
          () => _top5ViolationByTypeController.capture(),
      fleetLogsCapture: () => _fleetLogsController.capture(),
    );
  }

  void _showDateFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 600,
            height: 500,
            padding: const EdgeInsets.all(24),
            child: DateFilterContent(
              onApply: (DatePeriod? period) {
                Navigator.of(context).pop();
                if (period != null) {
                  // TODO: Apply date filter to reports
                  CustomSnackBar.showSuccess(
                    context,
                    'Date filter applied: ${period.start} to ${period.end}',
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  List<BreadcrumbItem> _buildBreadcrumbs(
    BuildContext context,
    ReportsState state,
  ) {
    switch (state.viewMode) {
      case ReportViewMode.global:
        return []; // Root view - no breadcrumbs

      case ReportViewMode.pdfPreview:
        return [const BreadcrumbItem(label: 'PDF Preview')];
      default:
        return [];
    }
  }

  Widget _buildView(BuildContext context, ReportsState state) {
    switch (state.viewMode) {
      case ReportViewMode.global:
      case ReportViewMode.individual:
        return _buildMainLayout(context, state);
      case ReportViewMode.pdfPreview:
        return Container(
          decoration: cardDecoration(),
          child: PdfReportPage(
            fleetSummary: state.fleetSummary,
            vehicleDistribution: state.vehicleDistribution,
            yearLevelBreakdown: state.yearLevelBreakdown,
            cityBreakdown: state.cityBreakdown,
            studentWithMostViolations: state.studentWithMostViolations,
            logsData: state.logsData,
            selectedTimeRange: state.selectedTimeRange,
            vehicleDistributionChartBytes: state.vehicleDistributionChartBytes,
            yearLevelBreakdownChartBytes: state.yearLevelBreakdownChartBytes,
            studentwithMostViolationChartBytes:
                state.studentwithMostViolationChartBytes,
            cityBreakdownChartBytes: state.cityBreakdownChartBytes,
            vehicleLogsDistributionChartBytes:
                state.vehicleLogsDistributionChartBytes,
            violationDistributionPerCollegeChartBytes:
                state.violationDistributionPerCollegeChartBytes,
            top5ViolationByTypeChartBytes: state.top5ViolationByTypeChartBytes,
            fleetLogsChartBytes: state.fleetLogsChartBytes,
            onBackPressed: () => context.read<ReportsCubit>().hidePdfPreview(),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: BlocListener<ShellCubit, ShellState>(
        listenWhen: (previous, current) {
          return previous.selectedIndex != current.selectedIndex;
        },
        listener: (context, shellState) {
          if (shellState.selectedIndex == ReportsPage.reportsPageIndex &&
              mounted) {
            // Reports page became active, restore breadcrumbs
            final reportsState = context.read<ReportsCubit>().state;
            final breadcrumbs = _buildBreadcrumbs(context, reportsState);
            BreadcrumbScope.controllerOf(context).setBreadcrumbs(breadcrumbs);
          }
        },
        child: BlocListener<ReportsCubit, ReportsState>(
          listener: (context, state) {
            // Add navigation gating - only update breadcrumbs if reports page is active
            if (context.read<ShellCubit>().state.selectedIndex !=
                ReportsPage.reportsPageIndex) {
              return;
            }

            // Build breadcrumbs based on view mode
            final breadcrumbs = _buildBreadcrumbs(context, state);
            BreadcrumbScope.controllerOf(context).setBreadcrumbs(breadcrumbs);
          },
          child: BlocBuilder<ReportsCubit, ReportsState>(
            builder: (context, state) {
              if (state.loading) {
                return const ReportLoader();
              }

              if (state.error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${state.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      ElevatedButton(
                        onPressed:
                            () =>
                                context.read<ReportsCubit>().loadGlobalReport(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              // Animated view switching
              return custom.AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildView(context, state),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMainLayout(BuildContext context, ReportsState state) {
    final isGlobal = state.viewMode == ReportViewMode.global;
    final summary = state.fleetSummary;

    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.medium),
      child: CustomScrollView(
        slivers: [
          // Header Sliver (shared)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                0,
                AppSpacing.medium,
                AppSpacing.medium,
                AppSpacing.medium,
              ),
              child: ReportHeaderSection(
                dateSelected:
                    'DATE FILTER', //todo display the current selected date range show date filter text by default
                onDateFilter: () {
                  _showDateFilterDialog(context);
                },
                onBackButtonClicked: () {
                  context.read<ReportsCubit>().navigateToGlobal();
                  debugPrint('Back button clicked');
                },
                onExportPDF: () => _handleExportPdf(context),
                onExportCSV: () {}, // todo
                isGlobal: isGlobal, //todo
              ),
            ),
          ),

          // Stats/Info Sliver (branch)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.medium),
              child: SizedBox(
                height: isGlobal ? 80 : 255,
                child:
                    isGlobal && summary != null
                        ? GlobalStatsSection(
                          summary: summary,
                          onStatCard1Click: () {
                            //todo nav to total violations view
                          },
                          onStatCard2Click: () {
                            //todo nav to total pending violations view
                          },
                          onStatCard3Click: () {
                            //todo nav to total vehicles view
                          },
                          onStatCard4Click: () {
                            //todo nav to total entrance/exits view
                          },
                        )
                        : IndividualStatsAndInfoSection(
                          onStatCard1Click: () {
                            //todo nav to MVP status (days until expiration) view
                          },
                          onStatCard2Click: () {
                            //todo nav to active violations view
                          },
                          onStatCard3Click: () {
                            //todo nav to total violations view
                          },
                          onStatCard4Click: () {
                            //todo nav to total entrance/exits view
                          },
                        ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Spacing.vertical(size: AppSpacing.medium),
          ),
          // Charts Sliver (branch)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.medium),
              child: SizedBox(
                height: isGlobal ? 1080 : 320,
                child:
                    isGlobal && summary != null
                        ? GlobalChartsSection(
                          summary: summary,
                          vehicleDistributionController:
                              _vehicleDistributionController,
                          yearLevelBreakdownController:
                              _yearLevelBreakdownController,
                          studentWithMostViolationsController:
                              _studentWithMostViolationsController,
                          cityBreakdownController: _cityBreakdownController,
                          vehicleLogsDistributionController:
                              _vehicleLogsDistributionController,
                          violationDistributionPerCollegeController:
                              _violationDistributionPerCollegeController,
                          top5ViolationByTypeController:
                              _top5ViolationByTypeController,
                          fleetLogsController: _fleetLogsController,
                        )
                        : const IndividualChartsSection(),
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: Spacing.vertical(size: AppSpacing.medium),
          ),
          // Violations Table Sliver (individual only)
          if (!isGlobal)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(right: AppSpacing.medium),
                child: ViolationsTableSection(isGlobal: isGlobal),
              ),
            ),
          if (!isGlobal)
            const SliverToBoxAdapter(
              child: Spacing.vertical(size: AppSpacing.medium),
            ),
          // Logs Table Sliver (individual only)
          if (!isGlobal)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(right: AppSpacing.medium),
                child: VehicleLogsTableSection(isGlobal: isGlobal),
              ),
            ),
          if (!isGlobal)
            const SliverToBoxAdapter(
              child: Spacing.vertical(size: AppSpacing.medium),
            ),
        ],
      ),
    );
  }
}
