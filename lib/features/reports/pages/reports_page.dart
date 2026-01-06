import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/card_decor.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/reports/widgets/report_header.dart';
import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

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
                  height: 260,
                  child: Row(
                    children: [
                      // LEFT: 2x2 stat cards
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: cardDecoration(),
                                    ),
                                  ),
                                  Spacing.horizontal(size: AppSpacing.medium),
                                  Expanded(
                                    child: Container(
                                      decoration: cardDecoration(),
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
                                    child: Container(
                                      decoration: cardDecoration(),
                                    ),
                                  ),
                                  Spacing.horizontal(size: AppSpacing.medium),
                                  Expanded(
                                    child: Container(
                                      decoration: cardDecoration(),
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
                        child: Container(decoration: cardDecoration()),
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
                      Expanded(child: Container(decoration: cardDecoration())),
                      Spacing.horizontal(size: AppSpacing.medium),
                      Expanded(child: Container(decoration: cardDecoration())),
                    ],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Spacing.vertical(size: AppSpacing.medium),
            ),

            // VIOLATION HISTORY TABLE
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(right: AppSpacing.medium),
                child: Container(
                  height: 400, // table viewport
                  decoration: cardDecoration(),
                  child: const Center(child: Text('Violation History Table')),
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
                  height: 400,
                  decoration: cardDecoration(),
                  child: const Center(child: Text('Vehicle Logs Table')),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Spacing.vertical(size: AppSpacing.medium),
            ),
          ],
        ),
      ),
    );
  }
}
