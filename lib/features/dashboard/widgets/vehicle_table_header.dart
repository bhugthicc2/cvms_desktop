import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/spacing.dart';
import 'package:cvms_desktop/features/dashboard/widgets/search_field.dart';
import 'package:flutter/material.dart';

class VehicleTableHeader extends StatelessWidget {
  final TextEditingController searchController;
  final String title;

  const VehicleTableHeader({
    super.key,
    required this.searchController,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Sora',
              fontWeight: FontWeight.bold,
              fontSize: AppFontSizes.small,
              color: AppColors.tableHeaderColor,
            ),
          ),
          Spacing.horizontal(size: AppSpacing.medium),
          Expanded(
            child: SizedBox(
              height: 40,
              child: SearchField(searchController: searchController),
            ),
          ),
        ],
      ),
    );
  }
}
