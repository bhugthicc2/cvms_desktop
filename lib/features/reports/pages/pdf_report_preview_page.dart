import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/reports/widgets/sections/pdf_preview_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';

class PdfReportPreviewContent extends StatelessWidget {
  final VoidCallback? onBackPressed;

  const PdfReportPreviewContent({super.key, this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      appBar: PdfPreviewAppBar(
        title: "PDF Report Preview",
        onBackPressed: () {
          onBackPressed?.call();
        },
        onDownLoadPressed: () {
          //todo
        },
        onPrintPressed: () {
          //todo
        },
      ),
      body: SizedBox(
        height: double.infinity,
        child: Column(
          children: [
            //Divider
            Spacing.vertical(size: AppSpacing.xSmall - 2),
            // PDF
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: AppColors.white,
                      child: const Center(child: Text("PDF Preview Area")),
                    ),
                  ),
                  Spacing.horizontal(size: AppSpacing.xSmall - 2),
                  Expanded(
                    child: Container(
                      color: AppColors.white,
                      child: const Center(child: Text("PDF Controls")),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
