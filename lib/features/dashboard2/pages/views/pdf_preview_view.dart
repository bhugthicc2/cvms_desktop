import 'dart:typed_data';

import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/features/dashboard2/pdf/components/viewer/pdf_viewer_widget.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/navigation/pdf_preview_app_bar.dart';
import 'package:flutter/material.dart';

class PdfPreviewView extends StatelessWidget {
  final VoidCallback onBackPressed;
  final Uint8List? pdfBytes;
  const PdfPreviewView({super.key, required this.onBackPressed, this.pdfBytes});

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
      body:
          pdfBytes == null || pdfBytes!.isEmpty
              ? const Center(
                child: Text(
                  'No PDF generated',
                  style: TextStyle(color: Colors.red),
                ),
              )
              : PdfViewerWidget(pdfBytes: pdfBytes!),
    );
  }
}
