import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/card_decor.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/dashboard/data/firestore_analytics_repository.dart';
import 'package:cvms_desktop/features/reports/pages/pdf_report_page.dart';
import 'package:cvms_desktop/features/reports/widgets/sections/stats/global_stats_section.dart';
import 'package:cvms_desktop/features/reports/widgets/sections/stats/individual_stats_and_info_section.dart';
import 'package:cvms_desktop/features/reports/widgets/sections/charts/global_charts_section.dart';
import 'package:cvms_desktop/features/reports/widgets/sections/charts/individual_charts_section.dart';
import 'package:cvms_desktop/features/reports/widgets/sections/table/violations_table_section.dart';
import 'package:cvms_desktop/features/reports/widgets/sections/table/vehicle_logs_table_section.dart';
import 'package:cvms_desktop/features/reports/widgets/app/report_header_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../bloc/reports/reports_cubit.dart';
import '../bloc/reports/reports_state.dart';
import '../widgets/content/date_filter_content.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              ReportsCubit(analyticsRepo: FirestoreAnalyticsRepository()),
      child: const _ReportsPageContent(),
    );
  }
}

class _ReportsPageContent extends StatelessWidget {
  const _ReportsPageContent();

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
                  debugPrint(
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
            return Center(
              child: Lottie.asset(
                renderCache: RenderCache.raster,
                'assets/anim/loading_anim.json',
                width: 200,
                height: 200,
              ),
            );
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

          return state.showPdfPreview
              ? Container(
                decoration: cardDecoration(),
                child: PdfReportPage(
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
    final isGlobal = state.isGlobalMode;
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
                onExportPDF:
                    () => context.read<ReportsCubit>().showPdfPreview(),
                onExportCSV: () {}, // todo
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
                        ? GlobalChartsSection(summary: summary)
                        : const IndividualChartsSection(),
              ),
            ),
          ),

          // Violations Table Sliver (branch)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.medium),
              child: ViolationsTableSection(
                // isGlobal: isGlobal,
                isGlobal: false,
              ), //partially removed the global table
            ),
          ),
          const SliverToBoxAdapter(
            child: Spacing.vertical(size: AppSpacing.medium),
          ),
          // Logs Table Sliver (branch)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.medium),
              child: VehicleLogsTableSection(
                // isGlobal: isGlobal,
                isGlobal: false,
              ), //partially removed the global table
            ),
          ),
        ],
      ),
    );
  }
}
