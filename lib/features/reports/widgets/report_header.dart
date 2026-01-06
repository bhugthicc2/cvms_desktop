import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/card_decor.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_grow.dart';
import 'package:cvms_desktop/core/widgets/app/search_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ReportHeader extends StatelessWidget {
  final VoidCallback onExportPDF;
  final VoidCallback onExportCSV;
  const ReportHeader({
    super.key,
    required this.onExportPDF,
    required this.onExportCSV,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          Text(
            'Vehicle Report',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const Spacer(),
          SearchField(
            hintText: 'Search vehicle...',
            searchFieldHeight: 40,
            searchFieldWidth: 300,
            controller: SearchController(),
          ),
          Spacing.horizontal(size: AppSpacing.medium),
          HoverGrow(
            cursor: SystemMouseCursors.click,
            onTap: onExportPDF,
            child: Container(
              height: 40,
              width: 40,
              padding: const EdgeInsets.all(8),
              decoration: cardDecoration(radii: 8),
              child: Center(
                child: Icon(
                  PhosphorIconsBold.filePdf,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          Spacing.horizontal(size: AppSpacing.medium),
          HoverGrow(
            cursor: SystemMouseCursors.click,
            onTap: onExportCSV,
            child: Container(
              height: 40,
              width: 40,
              padding: const EdgeInsets.all(8),
              decoration: cardDecoration(radii: 8),
              child: Center(
                child: Icon(
                  PhosphorIconsBold.fileCsv,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
