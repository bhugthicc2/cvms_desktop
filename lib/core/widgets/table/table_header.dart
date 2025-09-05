import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';
import '../app/search_field.dart';

class TableHeader extends StatelessWidget {
  final String title;
  final TextEditingController? searchController;

  const TableHeader({super.key, required this.title, this.searchController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          if (searchController != null)
            Expanded(
              child: SizedBox(
                height: 40,
                child: SearchField(controller: searchController!),
              ),
            ),
        ],
      ),
    );
  }
}
