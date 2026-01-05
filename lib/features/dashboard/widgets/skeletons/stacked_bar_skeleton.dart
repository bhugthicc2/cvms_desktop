import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/features/dashboard/widgets/utils/card_decor.dart';
import 'package:cvms_desktop/features/dashboard/widgets/titles/custom_chart_title.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StackedBarSkeleton extends StatelessWidget {
  final double height;
  final VoidCallback onViewTap;
  final String title;

  const StackedBarSkeleton({
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
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Title section with View All button
          if (title.isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: CustomChartTitle(title: title, onViewTap: onViewTap),
            ),

          // Horizontal bar chart content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  5, // Match real chart's 5 bars
                  (i) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          // Student name
                          Skeleton.leaf(
                            child: Container(
                              height: 16,
                              width: 80,
                              decoration: BoxDecoration(
                                color: AppColors.grey,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Horizontal bar with dynamic width
                          Skeleton.leaf(
                            child: Container(
                              height: 50,
                              width:
                                  _getBarWidth(i) *
                                  500, // Dynamic width with base width
                              decoration: BoxDecoration(
                                color: AppColors.grey,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Returns dynamic width values for bars to create varying lengths
  double _getBarWidth(int index) {
    // Width percentages that create realistic bar lengths
    switch (index) {
      case 0:
        return 0.9; // Longest bar
      case 1:
        return 0.7; // Medium-long bar
      case 2:
        return 0.5; // Medium bar
      case 3:
        return 0.3; // Short bar
      case 4:
        return 0.2; // Shortest bar
      default:
        return 0.5;
    }
  }
}
