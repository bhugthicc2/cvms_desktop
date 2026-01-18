import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/core/widgets/skeleton/dashboard_overview_skeleton.dart';
import 'package:cvms_desktop/core/widgets/skeleton/donut_chart_skeleton.dart';
import 'package:cvms_desktop/core/widgets/skeleton/stacked_bar_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReportSkeletonLoader extends StatelessWidget {
  const ReportSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Skeletonizer(
        child: Column(
          children: [
            //Action bar (search, filter, etc.)
            SizedBox(
              child: Row(
                children: [
                  //search bar
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Search by plate no., owner, school ID, or model',
                          ),
                          Spacer(),
                          Icon(Icons.search),
                        ],
                      ),
                    ),
                  ),

                  const Spacing.horizontal(size: AppSpacing.medium),
                  //report date filter
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today),
                        Spacing.horizontal(size: AppSpacing.small),
                        Text('Date Filter'),
                      ],
                    ),
                  ),

                  const Spacing.horizontal(size: AppSpacing.medium),
                  //generate report button
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(child: Text('Generate Report')),
                  ),
                ],
              ),
            ),
            const Spacing.vertical(size: AppSpacing.medium),
            //stats card
            buildSkeletonDashOverview(),
            Spacing.vertical(size: AppSpacing.medium),
            //charts
            Expanded(
              child: Row(
                children: [
                  Expanded(child: DonutChartSkeleton()),
                  const Spacing.horizontal(size: AppSpacing.medium),
                  Expanded(child: DonutChartSkeleton()),
                ],
              ),
            ),
            Spacing.vertical(size: AppSpacing.medium),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: StackedBarSkeleton()),
                  const Spacing.horizontal(size: AppSpacing.medium),
                  Expanded(child: StackedBarSkeleton()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
