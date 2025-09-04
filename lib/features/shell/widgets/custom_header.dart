import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:cvms_desktop/core/theme/app_dimensions.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/spacing.dart';
import 'package:cvms_desktop/core/widgets/custom_window_buttons.dart';
import 'package:flutter/material.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onMenuPressed;

  const CustomHeader({
    super.key,
    required this.title,
    this.actions,
    this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.headerHeight,
      padding: const EdgeInsets.only(left: 20),
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
          InkWell(
            onTap: onMenuPressed,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(PhosphorIconsRegular.list, size: 22),
            ),
          ),
          Spacing.horizontal(size: AppSpacing.medium),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: AppFontSizes.large,
              height: 1.0,
            ),
          ),
          Expanded(child: MoveWindow()),
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
