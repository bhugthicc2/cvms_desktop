import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/custom_window_buttons.dart';
import 'package:cvms_desktop/core/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class AuthWindowTitlebar extends StatelessWidget {
  const AuthWindowTitlebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: WindowTitleBarBox(
        // ignore: sized_box_for_whitespace
        child: Container(
          height: AppDimensions.headerHeight,
          child: Row(
            children: [
              Expanded(
                child: MoveWindow(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  ),
                ),
              ),
              CustomWindowButtons(
                iconColor: AppColors.white,
                maximizeColor: AppColors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
