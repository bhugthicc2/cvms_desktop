import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_grow.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomViewButton extends StatelessWidget {
  final VoidCallback onTap;
  final double iconSize;
  final String buttonTxt;
  const CustomViewButton({
    super.key,
    required this.onTap,
    this.buttonTxt = 'View All',
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return HoverGrow(
      onTap: onTap,
      child: Row(
        children: [
          Text(buttonTxt, style: TextStyle(color: AppColors.donutBlue)),
          Icon(
            PhosphorIconsBold.arrowUpRight,
            size: iconSize,
            color: AppColors.donutBlue,
          ),
        ],
      ),
    );
  }
}
