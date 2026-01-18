import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/card_decor.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/core/widgets/skeleton/report_skeleton_loader.dart';
import 'package:cvms_desktop/features/dashboard/bloc/reports/reports_cubit.dart';
import 'package:cvms_desktop/features/dashboard/bloc/reports/reports_state.dart';
import 'package:cvms_desktop/features/dashboard/pages/pdf_report_page.dart';
import 'package:cvms_desktop/features/dashboard/widgets/app/report_header_section.dart';
import 'package:cvms_desktop/features/dashboard/widgets/content/date_filter_content.dart';
import 'package:cvms_desktop/features/dashboard/widgets/sections/charts/global_charts_section.dart';
import 'package:cvms_desktop/features/dashboard/widgets/sections/charts/individual_charts_section.dart';
import 'package:cvms_desktop/features/dashboard/widgets/sections/stats/global/global_stats_section.dart';
import 'package:cvms_desktop/features/dashboard/widgets/sections/stats/individual/individual_stats_and_info_section.dart';
import 'package:cvms_desktop/features/dashboard/widgets/sections/table/vehicle_logs_table_section.dart';
import 'package:cvms_desktop/features/dashboard/widgets/sections/table/violations_table_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';

class DashboardPageContent extends StatefulWidget {
  const DashboardPageContent({super.key});

  @override
  State<DashboardPageContent> createState() => _DashboardPageContentState();
}

class _DashboardPageContentState extends State<DashboardPageContent> {
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
    await context.read<ReportsCubit>().exportToPdf(
      vehicleDistributionController: _vehicleDistributionController,
      yearLevelBreakdownController: _yearLevelBreakdownController,
      studentWithMostViolationsController: _studentWithMostViolationsController,
      cityBreakdownController: _cityBreakdownController,
      vehicleLogsDistributionController: _vehicleLogsDistributionController,
      violationDistributionPerCollegeController:
          _violationDistributionPerCollegeController,
      top5ViolationByTypeController: _top5ViolationByTypeController,
      fleetLogsController: _fleetLogsController,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: BlocBuilder<ReportsCubit, ReportsState>(
        builder: (context, state) {
          if (state.loading) {
            return const ReportSkeletonLoader();
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
                        () => context.read<ReportsCubit>().loadGlobalReport(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return state.viewMode == ReportViewMode.pdfPreview
              ? Container(
                decoration: cardDecoration(),
                child: PdfReportPage(
                  fleetSummary: state.fleetSummary,
                  vehicleDistribution: state.vehicleDistribution,
                  yearLevelBreakdown: state.yearLevelBreakdown,
                  cityBreakdown: state.cityBreakdown,
                  studentWithMostViolations: state.studentWithMostViolations,
                  logsData: state.logsData,
                  selectedTimeRange: state.selectedTimeRange,
                  vehicleDistributionChartBytes:
                      state.vehicleDistributionChartBytes,
                  yearLevelBreakdownChartBytes:
                      state.yearLevelBreakdownChartBytes,
                  studentwithMostViolationChartBytes:
                      state.studentwithMostViolationChartBytes,
                  cityBreakdownChartBytes: state.cityBreakdownChartBytes,
                  vehicleLogsDistributionChartBytes:
                      state.vehicleLogsDistributionChartBytes,
                  violationDistributionPerCollegeChartBytes:
                      state.violationDistributionPerCollegeChartBytes,
                  top5ViolationByTypeChartBytes:
                      state.top5ViolationByTypeChartBytes,
                  fleetLogsChartBytes: state.fleetLogsChartBytes,
                  onBackPressed:
                      () => context.read<ReportsCubit>().hidePdfPreview(),
                ),
              )
              : _buildMainLayout(context, state);
        },
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
                        ? GlobalStatsSection(summary: summary)
                        : const IndividualStatsAndInfoSection(),
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
