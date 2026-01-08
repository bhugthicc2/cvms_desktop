import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class VehicleInfoText extends StatelessWidget {
  const VehicleInfoText({
    super.key,
    required this.label,
    required this.value,
    this.isPrimary = false,
    this.isHighlighted = false,
    this.statusColor,
  });

  final String label;
  final String value;

  // ADV
  final bool isPrimary;
  final bool isHighlighted;
  final Color? statusColor;

  @override
  Widget build(BuildContext context) {
    final valueColor =
        statusColor ?? (isPrimary ? AppColors.darkBlue : AppColors.darkBlue);

    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.grey,
            fontSize: isPrimary ? 14 : 14,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Spacer(),
        _buildValue(valueColor),
      ],
    );
  }

  Widget _buildValue(Color color) {
    if (isHighlighted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.darkBlue.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          value,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColors.darkBlue,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      );
    }

    return Text(
      value,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: color,
        fontSize: isPrimary ? 14 : 14,
        fontWeight: isPrimary ? FontWeight.w700 : FontWeight.bold,
      ),
    );
  }
}
