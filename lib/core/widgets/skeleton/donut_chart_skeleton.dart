import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/card_decor.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/core/widgets/titles/custom_chart_title.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DonutChartSkeleton extends StatelessWidget {
  final double height;

  const DonutChartSkeleton({super.key, this.height = double.infinity});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: cardDecoration(),
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        children: [
          // Title section with View All button
          Align(
            alignment: Alignment.centerLeft,
            child: CustomChartTitle(title: 'College Department Distribution'),
          ),

          const SizedBox(height: 8),

          // Main content
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Donut chart section
                Expanded(
                  child: Skeleton.leaf(
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width:
                              48, // Matches innerRadius: '60%' of 160px (96px inner, 64px outer)
                        ),
                      ),
                    ),
                  ),
                ),
                //spacing
                const Spacing.horizontal(size: AppSpacing.medium),
                // Legend section
                Expanded(
                  child: Container(
                    width: 180,
                    padding: const EdgeInsets.only(right: AppSpacing.medium),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          6, // Match real chart's 6 items
                          (_) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                // Color dot - match real chart's 10x10 size
                                Skeleton.leaf(
                                  child: SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                // Category label - match real chart's ellipsis behavior
                                Expanded(
                                  child: Skeleton.leaf(
                                    child: SizedBox(
                                      height: 20,
                                      width: double.infinity,
                                      child: Text(
                                        'Sample College',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                // Value - match real chart's left alignment
                                Expanded(
                                  child: Skeleton.leaf(
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Text(
                                        '23',
                                        style: TextStyle(fontSize: 14),
                                      ),
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
          ),
        ],
      ),
    );
  }
}
