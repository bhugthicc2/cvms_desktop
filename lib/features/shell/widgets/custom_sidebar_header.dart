import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';

class CustomSidebarHeader extends StatelessWidget {
  final bool isExpanded;

  const CustomSidebarHeader({super.key, required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              "assets/images/jrmsu-logo.png",
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),

          if (isExpanded) ...[
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "JRMSU-K",
                  style: TextStyle(
                    color: AppColors.warning,
                    fontWeight: FontWeight.bold,
                    fontSize: AppFontSizes.large,
                  ),
                ),
                Text(
                  "CLOUD-BASED VMS",
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: AppFontSizes.small,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
