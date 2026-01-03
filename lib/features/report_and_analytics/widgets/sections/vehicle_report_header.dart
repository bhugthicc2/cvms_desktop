import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/search_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/report_and_analytics/widgets/button/custom_icon_button.dart';
import 'package:flutter/material.dart';

class VehicleReportHeader extends StatelessWidget {
  final String title;
  final String titleIcon;
  final String subtitle;
  final TextEditingController searchController;
  final VoidCallback onExportPdf;
  final VoidCallback onExportCsv;
  const VehicleReportHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.titleIcon = 'assets/icons/stencil/report.png',
    required this.searchController,
    required this.onExportPdf,
    required this.onExportCsv,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(titleIcon, height: 26, width: 26),
            Spacing.horizontal(size: AppSpacing.small),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: AppColors.grey),
                ),
              ],
            ),
          ],
        ),
        SearchField(
          controller: searchController,
          searchFieldHeight: 40,
          searchFieldWidth: MediaQuery.of(context).size.width * 0.3,
        ),
        Row(
          children: [
            CustomIconButton(
              onTap: onExportPdf,
              icon: 'assets/icons/stencil/export_pdf.png',
            ), //export to pdf
            Spacing.horizontal(size: AppSpacing.small),
            CustomIconButton(
              onTap: onExportCsv,
              icon: 'assets/icons/stencil/export_csv.png',
            ), //export to csv
          ],
        ),
      ],
    );
  }
}
