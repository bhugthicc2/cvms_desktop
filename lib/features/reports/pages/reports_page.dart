import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/card_decor.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard/widgets/charts/bar_chart_widget.dart';
import 'package:cvms_desktop/features/dashboard/widgets/charts/line_chart_widget.dart';
import 'package:cvms_desktop/features/reports/pages/pdf_report_page.dart';
import 'package:cvms_desktop/features/reports/utils/mvp_progress_calculator.dart';
import 'package:cvms_desktop/features/reports/widgets/sections/report_header_section.dart';
import 'package:cvms_desktop/features/reports/widgets/sections/report_table_header.dart';
import 'package:cvms_desktop/features/reports/widgets/sections/stats_card_section.dart';
import 'package:cvms_desktop/features/reports/widgets/sections/vehicle_info_section.dart';
import 'package:cvms_desktop/features/reports/widgets/tables/violation/violation_history_table.dart';
import 'package:cvms_desktop/features/reports/widgets/tables/vehicle_logs/vehicle_logs_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/reports_cubit.dart';
import '../bloc/reports_state.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportsCubit(),
      child: _ReportsPageContent(),
    );
  }
}

class _ReportsPageContent extends StatelessWidget {
  _ReportsPageContent();

  //mock data
  final List<ChartDataModel> violationTypeData = [
    ChartDataModel(category: 'Speeding', value: 100),
    ChartDataModel(category: 'Horn', value: 200),
    ChartDataModel(category: 'Muffler', value: 92),
    ChartDataModel(category: 'Over Speed', value: 30),
    ChartDataModel(category: 'Illegal Parking', value: 140),
    ChartDataModel(category: 'No License', value: 15),
  ];

  final List<ChartDataModel> vehicleLogsData = [
    ChartDataModel(category: 'Mon', value: 120, date: DateTime(2026, 1, 1)),
    ChartDataModel(category: 'Tue', value: 150, date: DateTime(2026, 1, 2)),
    ChartDataModel(category: 'Wed', value: 90, date: DateTime(2026, 1, 3)),
    ChartDataModel(category: 'Thu', value: 170, date: DateTime(2026, 1, 4)),
    ChartDataModel(category: 'Fri', value: 200, date: DateTime(2026, 1, 5)),
    ChartDataModel(category: 'Sat', value: 140, date: DateTime(2026, 1, 6)),
    ChartDataModel(category: 'Sun', value: 110, date: DateTime(2026, 1, 7)),
  ];

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
              child: Text(
                'Error: ${state.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return state.showPdfPreview
              ? Container(
                decoration: cardDecoration(),
                child: PdfReportPage(
                  onBackPressed: () {
                    context.read<ReportsCubit>().hidePdfPreview();
                  },
                ),
              )
              : _buildReportsContent(context);
        },
      ),
    );
  }

  Widget _buildReportsContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.medium),
      child: CustomScrollView(
        slivers: [
          // HEADER
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    0,
                    AppSpacing.medium,
                    AppSpacing.medium,
                    AppSpacing.medium,
                  ),
                  child: ReportHeaderSection(
                    onExportPDF: () {
                      // Show PDF preview locally
                      context.read<ReportsCubit>().showPdfPreview();
                    },
                    onExportCSV: () {
                      //todo handle export CSV
                    },
                  ),
                ),
              ],
            ),
          ),

          // STAT CARDS + VEHICLE INFO
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.medium),
              child: SizedBox(
                height: 255,
                child: Row(
                  children: [
                    // LEFT: 2x2 stat cards
                    Expanded(
                      flex: 2,
                      child: StatsCardSection(
                        //card1
                        statsCard1Label: "Days Until Expiration",
                        statsCard1Value: 150,
                        //card2
                        statsCard2Label: "Active Violations",
                        statsCard2Value: 22,
                        //card3
                        statsCard3Label: "Total Violations",
                        statsCard3Value: 230,
                        //card4
                        statsCard4Label: "Total Entries/Exits",
                        statsCard4Value: 540,
                      ),
                    ),

                    Spacing.horizontal(size: AppSpacing.medium),

                    // RIGHT: Vehicle Info
                    Expanded(
                      flex: 2,
                      child: Builder(
                        builder: (context) {
                          final registeredDate = DateTime(
                            2025,
                            5,
                            23,
                          ); //yyyy, mm, dd
                          final expiryDate = DateTime(
                            2026,
                            12,
                            2,
                          ); //yyyy, mm, dd
                          final mvpProgress =
                              MvpProgressCalculator.calculateProgress(
                                registeredDate: registeredDate,
                                expiryDate: expiryDate,
                              );

                          return VehicleInfoSection(
                            title: "Vehicle Information",
                            onViewTap: () {},

                            // Vehicle
                            vehicleModel: "Toyota Avanza",
                            plateNumber: "WXY-9012",
                            vehicleType: "Four-wheeled",

                            // Owner & Access
                            ownerName: "Mila Hernandez",
                            department: "CAF-SOE",
                            status: "Offsite",

                            // MVP
                            mvpProgress: mvpProgress,
                            mvpRegisteredDate: registeredDate,
                            mvpExpiryDate: expiryDate,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(child: Spacing.vertical(size: AppSpacing.medium)),

          // CHARTS SECTION (fixed height)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.medium),
              child: SizedBox(
                height: 320,
                child: Row(
                  children: [
                    Expanded(
                      child: BarChartWidget(
                        onViewTap: () {},
                        onBarChartPointTap: (details) {},
                        data:
                            violationTypeData, //todo add a hardcoded data for now
                        title: 'Violation by Type',
                      ),
                    ), //violation by type bar chart
                    Spacing.horizontal(size: AppSpacing.medium),
                    Expanded(
                      child: LineChartWidget(
                        customWidget: CustomDropdown(
                          color: AppColors.donutBlue,
                          fontSize: 14,
                          verticalPadding: 0,
                          items: const ['7 days', 'Month', 'Year'],
                          initialValue: '7 days',
                          onChanged: (value) {
                            //todo
                          },
                        ),
                        onViewTap: () {},
                        onLineChartPointTap: (details) {},
                        data:
                            vehicleLogsData, //todo add a hardcoded data for now
                        title: 'Vehicle Logs for the last',
                      ),
                    ), //vehicle logs line chart (weekly, monthly and yearly)
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Spacing.vertical(size: AppSpacing.medium),
          ), //space
          // VIOLATION HISTORY TABLE
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.medium),
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.medium,
                  AppSpacing.medium,
                  AppSpacing.medium,
                  0,
                ),
                height: 400, // table viewport
                decoration: cardDecoration(),
                child: Column(
                  children: [
                    ReportTableHeader(
                      tableTitle: 'Violation History',
                      onTap: () {},
                    ),
                    Spacing.vertical(size: AppSpacing.medium),
                    const Expanded(
                      child: ViolationHistoryTable(
                        istableHeaderDark: false,
                        allowSorting: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(child: Spacing.vertical(size: AppSpacing.medium)),

          // VEHICLE LOGS TABLE
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.medium),
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.medium,
                  AppSpacing.medium,
                  AppSpacing.medium,
                  0,
                ),
                height: 400, // table viewport
                decoration: cardDecoration(),
                child: Column(
                  children: [
                    ReportTableHeader(tableTitle: 'Vehicle Logs', onTap: () {}),
                    Spacing.vertical(size: AppSpacing.medium),
                    const Expanded(
                      child: VehicleLogsTable(
                        istableHeaderDark: false,
                        allowSorting: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Spacing.vertical(size: AppSpacing.medium),
          ), //space
        ],
      ),
    );
  }
}
