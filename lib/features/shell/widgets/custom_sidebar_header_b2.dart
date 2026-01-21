import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_dimensions.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';

class CustomSidebarHeader extends StatelessWidget {
  final bool isExpanded;

  const CustomSidebarHeader({super.key, required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 180,
      // decoration: BoxDecoration(
      //   border: Border(
      //     bottom: BorderSide(
      //       color: AppColors.lineColor.withValues(alpha: 0.4),
      //       width: 1,
      //     ),
      //   ),
      // ),
      padding: const EdgeInsets.symmetric(horizontal: 50 * 0.25, vertical: 9),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacing.vertical(size: AppSpacing.xSmall),
          ClipOval(
            child: Image.asset(
              "assets/images/jrmsu-logo.png",
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          Spacing.vertical(size: AppSpacing.xSmall),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isExpanded ? 1.0 : 0.0,
              child:
                  isExpanded
                      ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "JRMSU-K",
                                style: TextStyle(
                                  color: AppColors.yellow,
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppFontSizes.xLarge,
                                ),
                              ),
                              Text(
                                " CVMS",
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w100,
                                  fontSize: AppFontSizes.xLarge,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                      : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
