import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_grow.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final String icon;
  const CustomIconButton({super.key, required this.onTap, required this.icon});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HoverGrow(
      onTap: onTap,
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.all(8),
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Image.asset(icon, height: 20, width: 20),
      ),
    );
  }
}
