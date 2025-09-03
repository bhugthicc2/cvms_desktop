import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/custom_window_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomWindowButtons extends StatelessWidget {
  final Color iconColor;
  final Color? minimizeColor;
  final Color? maximizeColor;
  final Color? closeColor;

  const CustomWindowButtons({
    super.key,
    required this.iconColor,
    required this.maximizeColor,
    this.minimizeColor,
    this.closeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomWindowIconButton(
          iconColor: minimizeColor ?? AppColors.white,
          icon: PhosphorIconsRegular.minus,
          tooltip: "Minimize",
          onPressed: () => appWindow.minimize(),
        ),
        CustomWindowIconButton(
          iconColor: maximizeColor ?? AppColors.white,
          icon: PhosphorIconsRegular.cornersOut,
          tooltip: "Maximize / Restore",
          onPressed: () {
            if (appWindow.isMaximized) {
              appWindow.restore();
            } else {
              appWindow.maximize();
            }
          },
        ),
        CustomWindowIconButton(
          iconColor: closeColor ?? AppColors.white,
          icon: PhosphorIconsRegular.x,
          tooltip: "Close",
          hoverColor: Colors.red.withValues(alpha: 0.2),
          onPressed: () => appWindow.close(),
        ),
      ],
    );
  }
}
