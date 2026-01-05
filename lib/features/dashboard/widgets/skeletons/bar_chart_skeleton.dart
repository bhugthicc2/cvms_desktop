import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/features/dashboard/widgets/utils/card_decor.dart';
import 'package:cvms_desktop/features/dashboard/widgets/titles/custom_chart_title.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BarChartSkeleton extends StatelessWidget {
  final double height;
  final VoidCallback onViewTap;
  final String title;

  const BarChartSkeleton({
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

          // Bar chart content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(
                  4, // Match real chart's 4 bars
                  (i) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Value label on top of bar
                          Skeleton.leaf(
                            child: Container(
                              height: 16,
                              width: 20,
                              decoration: BoxDecoration(
                                color: AppColors.grey,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Bar with dynamic height
                          Skeleton.leaf(
                            child: Container(
                              height: _getBarHeight(
                                i,
                              ), // Dynamic height in pixels
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.grey,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Category label
                          Skeleton.leaf(
                            child: Container(
                              height: 12,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.grey,
                                borderRadius: BorderRadius.circular(2),
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

  // Returns dynamic height values for bars to create varying heights
  double _getBarHeight(int index) {
    // Height values in pixels that create realistic bar heights
    switch (index) {
      case 0:
        return 200; // Tallest bar
      case 1:
        return 150; // Medium-tall bar
      case 2:
        return 100; // Short bar
      case 3:
        return 210; // Shortest bar
      default:
        return 80;
    }
  }
}
