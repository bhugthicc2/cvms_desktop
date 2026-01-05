import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/features/dashboard/widgets/utils/card_decor.dart';
import 'package:cvms_desktop/features/dashboard/widgets/titles/custom_chart_title.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LineChartSkeleton extends StatelessWidget {
  final double height;
  final VoidCallback onViewTap;
  final String title;

  const LineChartSkeleton({
    super.key,
    this.height = double.infinity,
    required this.onViewTap,
    this.title = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: cardDecoration(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          // Title section with dropdown and View All button
          Align(
            alignment: Alignment.centerLeft,
            child: CustomChartTitle(
              title: 'Vehicle Logs for the last 7 days',
              onViewTap: onViewTap,
            ),
          ),

          // Line chart area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Skeleton.leaf(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),

          // X-axis labels
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                7,
                (index) => Skeleton.leaf(
                  child: Container(
                    width: 20,
                    height: 12,
                    color: AppColors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
