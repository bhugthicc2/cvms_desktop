import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/navigation/pdf_preview_app_bar.dart';
import 'package:flutter/material.dart';

class PdfPreviewView extends StatelessWidget {
  final VoidCallback onBackPressed;
  const PdfPreviewView({super.key, required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      appBar: PdfPreviewAppBar(
        title: 'PDF Report Preview',
        breadcrumbs: [],
        onBackPressed: onBackPressed,
        onDownLoadPressed: () {},
        onPrintPressed: () {},
        onEditPressed: () {},
        toggleFitMode: () {},
        isFitToWidth: false,
        isChart: true,
      ),
      body: SizedBox(
        height: 200,
        width: 300,
        child: const Center(child: Text('TODO: PDF Preview Content')),
      ),
    );
  }
}
