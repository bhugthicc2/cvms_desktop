import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/card_decor.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard/widgets/charts/bar_chart_widget.dart';
import 'package:cvms_desktop/features/dashboard/widgets/charts/donut_chart_widget.dart';
import 'package:cvms_desktop/features/dashboard/widgets/charts/line_chart_widget.dart';
import 'package:cvms_desktop/features/dashboard/data/firestore_analytics_repository.dart';
import 'package:cvms_desktop/features/dashboard/extensions/time_range_extensions.dart';
import 'package:cvms_desktop/features/reports/pages/pdf_report_page.dart';
import 'package:cvms_desktop/features/reports/utils/mvp_progress_calculator.dart';
import 'package:cvms_desktop/features/reports/widgets/sections/global_stats_card_section.dart';
import 'package:cvms_desktop/features/reports/widgets/sections/report_header_section.dart';
import 'package:cvms_desktop/features/reports/widgets/sections/report_table_header.dart';
import 'package:cvms_desktop/features/reports/widgets/sections/stats_card_section.dart';
import 'package:cvms_desktop/features/reports/widgets/sections/vehicle_info_section.dart';
import 'package:cvms_desktop/features/reports/widgets/tables/violation/global_violation_history_table.dart';
import 'package:cvms_desktop/features/reports/widgets/tables/vehicle_logs/global_vehicle_logs_table.dart';
import 'package:cvms_desktop/features/reports/widgets/tables/violation/violation_history_table.dart';
import 'package:cvms_desktop/features/reports/widgets/tables/vehicle_logs/vehicle_logs_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/reports/reports_cubit.dart';
import '../bloc/reports/reports_state.dart';
import '../models/fleet_summary.dart';
import '../data/mock_data.dart'; // Isolated mocks

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: BlocBuilder<ReportsCubit, ReportsState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
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
                onExportPDF:
                    () => context.read<ReportsCubit>().showPdfPreview(),
                onExportCSV: () {}, // TODO
              ),
            ),
          ),

          // Stats/Info Sliver (branch)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.medium),
              child: SizedBox(
                height: isGlobal ? 90 : 255,
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
                height: isGlobal ? 530 : 320,
                child:
                    isGlobal && summary != null
                        ? GlobalChartsSection(summary: summary)
                        : const IndividualChartsSection(),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Spacing.vertical(size: AppSpacing.medium),
          ),
          // Violations Table Sliver (branch)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.medium),
              child: ViolationsTableSection(isGlobal: isGlobal),
            ),
          ),
          const SliverToBoxAdapter(
            child: Spacing.vertical(size: AppSpacing.medium),
          ),
          // Logs Table Sliver (branch)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.medium),
              child: VehicleLogsTableSection(isGlobal: isGlobal),
            ),
          ),
          const SliverToBoxAdapter(
            child: Spacing.vertical(size: AppSpacing.medium),
          ),
        ],
      ),
    );
  }
}

// Extracted: Global Stats + Donut (SRP: Builds stats + dept distro only)
class GlobalStatsSection extends StatelessWidget {
  const GlobalStatsSection({super.key, required this.summary});

  final FleetSummary summary;

  @override
  Widget build(BuildContext context) {
    return GlobalStatsCardSection(
      statsCard1Label: 'Total Fleet Violations',
      statsCard1Value: summary.totalViolations,
      statsCard2Label: 'Active Fleet Violations',
      statsCard2Value: summary.activeViolations,
      statsCard3Label: 'Total Vehicles',
      statsCard3Value: summary.totalVehicles,
      statsCard4Label: 'Total Entries/Exits',
      statsCard4Value: summary.totalEntriesExits,
    );
  }
}

// Extracted: Individual Stats + Info (SRP: Builds individual cards + vehicle only)
class IndividualStatsAndInfoSection extends StatelessWidget {
  const IndividualStatsAndInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final registeredDate = DateTime(2025, 5, 23);
    final expiryDate = DateTime(2026, 12, 2);
    final mvpProgress = MvpProgressCalculator.calculateProgress(
      registeredDate: registeredDate,
      expiryDate: expiryDate,
    );

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: const StatsCardSection(
            statsCard1Label: 'Days Until Expiration',
            statsCard1Value: 150,
            statsCard2Label: 'Active Violations',
            statsCard2Value: 22,
            statsCard3Label: 'Total Violations',
            statsCard3Value: 230,
            statsCard4Label: 'Total Entries/Exits',
            statsCard4Value: 540,
          ),
        ),
        Spacing.horizontal(size: AppSpacing.medium),
        Expanded(
          flex: 2,
          child: VehicleInfoSection(
            title: 'Vehicle Information',
            onViewTap: () {},
            vehicleModel: 'Toyota Avanza',
            plateNumber: 'WXY-9012',
            vehicleType: 'Four-wheeled',
            ownerName: 'Mila Hernandez',
            department: 'CAF-SOE',
            status: 'Offsite',
            mvpProgress: mvpProgress,
            mvpRegisteredDate: registeredDate,
            mvpExpiryDate: expiryDate,
          ),
        ),
      ],
    );
  }
}

// Extracted: Global Charts Row (SRP: Builds bar/line + donut logic only)
class GlobalChartsSection extends StatefulWidget {
  const GlobalChartsSection({super.key, required this.summary});

  final FleetSummary summary;

  @override
  State<GlobalChartsSection> createState() => _GlobalChartsSectionState();
}

class _GlobalChartsSectionState extends State<GlobalChartsSection> {
  @override
  Widget build(BuildContext context) {
    final deptData =
        widget.summary.departmentLogData.isNotEmpty
            ? widget.summary.departmentLogData
            : ReportMockData.vehicleLogsCollegeData; // Fallback mock if null
    final typesData =
        widget.summary.topViolationTypes
            .map(
              (t) =>
                  ChartDataModel(category: t.type, value: t.count.toDouble()),
            )
            .toList();

    return BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  //Vehicle Logs Distribution per College
                  Expanded(
                    child: DonutChartWidget(
                      explode: true,
                      showPercentageInSlice: false,
                      onViewTap: () {},
                      onDonutChartPointTap: (details) {},
                      data: deptData,
                      title: 'Vehicle Logs Distribution per College',
                      radius: '100%',
                      innerRadius: '55%',
                    ),
                  ),
                  Spacing.horizontal(size: AppSpacing.medium),
                  //Violation distribution per college
                  Expanded(
                    child: DonutChartWidget(
                      explode: true,
                      showPercentageInSlice: false,
                      onViewTap: () {},
                      onDonutChartPointTap: (details) {},
                      // In the violation donut:
                      data:
                          widget.summary.deptViolationData.isNotEmpty
                              ? widget.summary.deptViolationData
                              : ReportMockData
                                  .vehicleLogsCollegeData, // Fallback if no data.
                      title: 'Violation Distribution per College',
                      radius: '100%',
                      innerRadius: '55%',
                    ),
                  ),
                ],
              ),
            ),
            Spacing.vertical(size: AppSpacing.medium),
            Expanded(
              child: Row(
                children: [
                  //todo may be add a filter for resolved and pending?c
                  Expanded(
                    child: BarChartWidget(
                      onViewTap: () {},
                      onBarChartPointTap: (details) {},
                      data: typesData,
                      title: 'Top 5 Violations by Type',
                    ),
                  ),
                  Spacing.horizontal(size: AppSpacing.medium),
                  //vehicle logs for the last 7 days for now
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
                            context.read<ReportsCubit>().changeTimeRange(
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
                      data:
                          state.logsData.isNotEmpty
                              ? state.logsData
                              : ReportMockData
                                  .vehicleLogsData, // fallback to mock
                      title: 'Fleet Logs for the last',
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// Extracted: Individual Charts Row (SRP: Builds individual bar/line only)
class IndividualChartsSection extends StatelessWidget {
  const IndividualChartsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BarChartWidget(
            onViewTap: () {},
            onBarChartPointTap: (details) {},
            data: ReportMockData.violationTypeData,
            title: 'Violation by Type',
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
              initialValue: '7 days',
              onChanged: (value) {}, // Stub—wire if needed
            ),
            onViewTap: () {},
            onLineChartPointTap: (details) {},
            data: ReportMockData.vehicleLogsData,
            title: 'Vehicle Logs for the last',
          ),
        ),
      ],
    );
  }
}

// Extracted: Violations Table Section (SRP: Builds table + header only)
class ViolationsTableSection extends StatelessWidget {
  const ViolationsTableSection({super.key, required this.isGlobal});

  final bool isGlobal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.medium,
        AppSpacing.medium,
        AppSpacing.medium,
        0,
      ),
      height: 400,
      decoration: cardDecoration(),
      child: Column(
        children: [
          ReportTableHeader(
            tableTitle:
                isGlobal ? 'Global Violation History' : 'Violation History',
            onTap: () {},
          ),
          Spacing.vertical(size: AppSpacing.medium),
          Expanded(
            child:
                isGlobal
                    ? const GlobalViolationHistoryTable(
                      istableHeaderDark: false,
                      allowSorting: true,
                    )
                    : const ViolationHistoryTable(
                      istableHeaderDark: false,
                      allowSorting: true,
                    ),
          ),
        ],
      ),
    );
  }
}

// Extracted: Vehicle Logs Table Section (SRP: Builds table + header only)
class VehicleLogsTableSection extends StatelessWidget {
  const VehicleLogsTableSection({super.key, required this.isGlobal});

  final bool isGlobal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.medium,
        AppSpacing.medium,
        AppSpacing.medium,
        0,
      ),
      height: 400,
      decoration: cardDecoration(),
      child: Column(
        children: [
          ReportTableHeader(
            tableTitle: isGlobal ? 'Global Vehicle Logs' : 'Vehicle Logs',
            onTap: () {},
          ),
          Spacing.vertical(size: AppSpacing.medium),
          Expanded(
            child:
                isGlobal
                    ? const GlobalVehicleLogsTable(
                      istableHeaderDark: false,
                      allowSorting: true,
                    )
                    : const VehicleLogsTable(
                      istableHeaderDark: false,
                      allowSorting: true,
                    ),
          ),
        ],
      ),
    );
  }
}
