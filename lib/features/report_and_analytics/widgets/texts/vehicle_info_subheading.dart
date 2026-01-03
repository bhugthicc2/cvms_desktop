import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';

class VehicleInfoSubheading extends StatelessWidget {
  final double fontSize;
  final String label;
  final String value;
  final String? icon;
  final double iconSize;
  const VehicleInfoSubheading({
    super.key,
    this.fontSize = 14,
    required this.label,
    required this.value,
    this.icon,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(icon!, height: iconSize, width: iconSize),
          Spacing.horizontal(size: AppSpacing.small),
          Text(
            '$label: ',
            style: TextStyle(fontSize: fontSize, color: AppColors.grey),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
