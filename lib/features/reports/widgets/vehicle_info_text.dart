import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class VehicleInfoText extends StatelessWidget {
  const VehicleInfoText({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.grey,
            fontSize: 14,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: AppColors.darkBlue,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
