import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';

class LivePill extends StatelessWidget {
  const LivePill({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            height: 6,
            width: 6,
            decoration: BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          Spacing.horizontal(size: 6),
          const Text(
            "LIVE",
            style: TextStyle(
              color: AppColors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
