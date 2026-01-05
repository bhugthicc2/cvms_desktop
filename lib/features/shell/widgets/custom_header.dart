import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:cvms_desktop/core/theme/app_dimensions.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_grow.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_window_buttons.dart';
import 'package:flutter/material.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final String currentUser;
  final List<Widget>? actions;
  final VoidCallback? onMenuPressed;

  const CustomHeader({
    super.key,
    required this.title,
    this.actions,
    this.onMenuPressed,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.headerHeight,
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.dividerColor, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        textBaseline: TextBaseline.alphabetic,
        children: [
          HoverGrow(
            hoverScale: 1.1,
            onTap: onMenuPressed,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(PhosphorIconsRegular.list, size: 20),
            ),
          ),
          Spacing.horizontal(size: AppSpacing.medium - 5),
          Text(
            title,
            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
              fontSize: AppFontSizes.medium,
              height: 1.0,
            ),
          ),
          Expanded(child: MoveWindow()),
          
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                CircleAvatar(child: Image.asset('assets/images/profile.png')),
                Text(
                  currentUser,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: AppFontSizes.small,
                    height: 1.0,
                  ),
                ),
                Spacing.horizontal(size: AppSpacing.medium),
                Container(
                  height: AppDimensions.headerHeight * 0.4,
                  width: 1,
                  decoration: BoxDecoration(
                    color: AppColors.dividerColor.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
          CustomWindowButtons(
            iconColor: AppColors.black,
            maximizeColor: AppColors.primary,
            minimizeColor: AppColors.primary,
            closeColor: AppColors.error,
          ),
        ],
      ),
    );
  }
}
