import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_dimensions.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';

class CustomSidebarHeader extends StatelessWidget {
  final bool isExpanded;

  const CustomSidebarHeader({super.key, required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.headerHeight,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.lineColor, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              "assets/images/jrmsu-logo.png",
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "JRMSU-K",
                                style: TextStyle(
                                  color: AppColors.yellow,
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppFontSizes.xxLarge,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  "CLOUD-BASED VMS",
                                  style: TextStyle(
                                    color: AppColors.sidebarheaderSub,
                                    fontSize: AppFontSizes.xSmall,
                                  ),
                                  overflow: TextOverflow.ellipsis,
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
