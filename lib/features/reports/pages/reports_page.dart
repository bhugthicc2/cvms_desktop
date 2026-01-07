import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/card_decor.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown.dart';
import 'package:cvms_desktop/core/widgets/layout/custom_divider.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard/widgets/button/custom_view_button.dart';
import 'package:cvms_desktop/features/dashboard/widgets/charts/bar_chart_widget.dart';
import 'package:cvms_desktop/features/dashboard/widgets/charts/line_chart_widget.dart';
import 'package:cvms_desktop/features/reports/widgets/report_header.dart';
import 'package:cvms_desktop/features/reports/widgets/report_table_header.dart';
import 'package:cvms_desktop/features/reports/widgets/tables/violation/violation_history_table.dart';
import 'package:cvms_desktop/features/reports/widgets/tables/vehicle_logs/vehicle_logs_table.dart';
import 'package:cvms_desktop/features/reports/widgets/vehicle_info_text.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/widgets/layout/stats_card.dart';

class ReportsPage extends StatelessWidget {
  ReportsPage({super.key});

  //mock data
  final List<ChartDataModel> violationTypeData = [
    ChartDataModel(category: 'Speeding', value: 35),
    ChartDataModel(category: 'Over Speed', value: 30),
    ChartDataModel(category: 'Illegal Parking', value: 20),
    ChartDataModel(category: 'No License', value: 15),
  ];

  final List<ChartDataModel> vehicleLogsData = [
    ChartDataModel(category: 'Mon', value: 120, date: DateTime(2024, 1, 1)),
    ChartDataModel(category: 'Tue', value: 150, date: DateTime(2024, 1, 2)),
    ChartDataModel(category: 'Wed', value: 90, date: DateTime(2024, 1, 3)),
    ChartDataModel(category: 'Thu', value: 170, date: DateTime(2024, 1, 4)),
    ChartDataModel(category: 'Fri', value: 200, date: DateTime(2024, 1, 5)),
    ChartDataModel(category: 'Sat', value: 140, date: DateTime(2024, 1, 6)),
    ChartDataModel(category: 'Sun', value: 110, date: DateTime(2024, 1, 7)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: Padding(
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
                    child: ReportHeader(
                      onExportPDF: () {
                        //todo handle export PDF
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
                  height: 230,
                  child: Row(
                    children: [
                      // LEFT: 2x2 stat cards
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 110,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: StatsCard(
                                        angle: 0,
                                        color: AppColors.white,
                                        icon: PhosphorIconsBold.calendarMinus,
                                        label: "Days Until Expiration",
                                        value: 150,
                                        gradient: AppColors.greenWhite,
                                        iconColor: AppColors.chartGreenv2,
                                      ),
                                    ),
                                    Spacing.horizontal(size: AppSpacing.medium),
                                    Expanded(
                                      child: StatsCard(
                                        angle: 0,
                                        color: AppColors.orange,
                                        icon: PhosphorIconsBold.calendarMinus,
                                        label: "Active Violations",
                                        value: 22,
                                        gradient: AppColors.yellowOrange,
                                        iconColor: AppColors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Spacing.vertical(size: AppSpacing.medium),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: StatsCard(
                                      angle: 0,
                                      color: AppColors.white,
                                      icon: PhosphorIconsBold.calendarMinus,
                                      label: "Total Violations",
                                      value: 230,
                                      gradient: AppColors.purpleBlue,
                                      iconColor: AppColors.primary,
                                    ),
                                  ),
                                  Spacing.horizontal(size: AppSpacing.medium),
                                  Expanded(
                                    child: StatsCard(
                                      angle: 0,
                                      color: AppColors.white,
                                      icon: PhosphorIconsBold.calendarMinus,
                                      label: "Total Entries/Exits",
                                      value: 540,
                                      gradient: AppColors.pinkWhite,
                                      iconColor: AppColors.donutPink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Spacing.horizontal(size: AppSpacing.medium),

                      // RIGHT: Vehicle Info
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: cardDecoration(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //title
                              Padding(
                                padding: const EdgeInsets.all(
                                  AppSpacing.medium,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Vehicle Information",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    CustomViewButton(
                                      onTap: () {
                                        //todo view all the vehicle info
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  AppSpacing.xLarge,
                                  0,
                                  AppSpacing.xLarge,
                                  AppSpacing.medium,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          VehicleInfoText(
                                            label: "Vehicle Make",
                                            value: "Honda",
                                          ),
                                          Spacing.vertical(
                                            size: AppSpacing.small,
                                          ),
                                          VehicleInfoText(
                                            label: "Vehicle Model",
                                            value: "Beat",
                                          ),
                                          Spacing.vertical(
                                            size: AppSpacing.small,
                                          ),
                                          VehicleInfoText(
                                            label: "Vehicle Type",
                                            value: "Two-wheeled",
                                          ),
                                          Spacing.vertical(
                                            size: AppSpacing.small,
                                          ),
                                          VehicleInfoText(
                                            label: "Vehicle Color",
                                            value: "Red",
                                          ),
                                          Spacing.vertical(
                                            size: AppSpacing.small,
                                          ),
                                          VehicleInfoText(
                                            label: "Plate Number",
                                            value: "231421d",
                                          ),
                                          Spacing.vertical(
                                            size: AppSpacing.small,
                                          ),
                                          VehicleInfoText(
                                            label: "Date Registered",
                                            value: "Dec. 23, 2025",
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacing.horizontal(size: AppSpacing.medium),
                                    CustomDivider(),
                                    Spacing.horizontal(size: AppSpacing.medium),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          VehicleInfoText(
                                            label: "Owner",
                                            value: "Otenciano Mautganon",
                                          ),
                                          Spacing.vertical(
                                            size: AppSpacing.small,
                                          ),
                                          VehicleInfoText(
                                            label: "College",
                                            value: "CCS",
                                          ),
                                          Spacing.vertical(
                                            size: AppSpacing.small,
                                          ),
                                          VehicleInfoText(
                                            label: "Year Level",
                                            value: "1st Year",
                                          ),
                                          Spacing.vertical(
                                            size: AppSpacing.small,
                                          ),
                                          VehicleInfoText(
                                            label: "Course",
                                            value: "BS Computer Science",
                                          ),
                                          Spacing.vertical(
                                            size: AppSpacing.small,
                                          ),
                                          VehicleInfoText(
                                            label: "Block",
                                            value: "A",
                                          ),
                                          Spacing.vertical(
                                            size: AppSpacing.small,
                                          ),
                                          VehicleInfoText(
                                            label: "Date Expired",
                                            value: "May 23, 2026",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Spacing.vertical(size: AppSpacing.medium),
            ),

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
                    AppSpacing.small,
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

            SliverToBoxAdapter(
              child: Spacing.vertical(size: AppSpacing.medium),
            ),

            // VEHICLE LOGS TABLE
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(right: AppSpacing.medium),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.medium,
                    AppSpacing.small,
                    AppSpacing.medium,
                    0,
                  ),
                  height: 400, // table viewport
                  decoration: cardDecoration(),
                  child: Column(
                    children: [
                      ReportTableHeader(
                        tableTitle: 'Vehicle Logs',
                        onTap: () {},
                      ),
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
      ),
    );
  }
}
