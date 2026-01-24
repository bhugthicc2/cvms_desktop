import 'package:cvms_desktop/core/theme/app_dimensions.dart';
import 'package:cvms_desktop/core/theme/sidebar_theme.dart';
import 'package:flutter/material.dart';

class CustomSidebarHeader extends StatelessWidget {
  final bool isExpanded;

  const CustomSidebarHeader({super.key, required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    final sidebarTheme = SidebarTheme.fromCubit(context);

    return Container(
      height: AppDimensions.headerHeight,
      decoration: BoxDecoration(
        //color: sidebarTheme.headerBackground,
        border: Border(
          bottom: BorderSide(color: sidebarTheme.headerBorder, width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 50 * 0.25,
        vertical: sidebarTheme.headerPadding,
      ),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              "assets/images/jrmsu-logo.png",
              width: isExpanded ? 30 : 25,
              height: isExpanded ? 30 : 25,
              fit: BoxFit.cover,
            ),
          ),
          AnimatedSize(
            duration: sidebarTheme.expansionAnimationDuration,
            child: AnimatedOpacity(
              duration: sidebarTheme.opacityAnimationDuration,
              opacity: isExpanded ? 1.0 : 0.0,
              child:
                  isExpanded
                      ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: sidebarTheme.iconTextSpacing * 0.8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "JRMSU-K",
                                style: sidebarTheme.logoTextStyle,
                              ),
                              Text("CVMS", style: sidebarTheme.headerTextStyle),
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
