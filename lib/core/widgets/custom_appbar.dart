import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_icon_sizes.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Color backgroundColor;
  final Color iconColor;

  const CustomAppBar({
    super.key,
    this.title,
    this.onBackPressed,
    this.actions,
    this.backgroundColor = Colors.transparent,
    this.iconColor = AppColors.black,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      leading: IconButton(
        icon: PhosphorIcon(
          PhosphorIconsRegular.caretLeft,
          size: AppIconSizes.xLarge,
          color: iconColor,
          semanticLabel: 'Back',
        ),
        tooltip: 'Back',
        onPressed: onBackPressed ?? () => Navigator.pop(context),
      ),
      title: title != null ? Text(title!) : null,
      titleTextStyle: TextStyle(
        fontSize: AppFontSizes.xxLarge,
        color: AppColors.black,
      ),
      actions: actions,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
