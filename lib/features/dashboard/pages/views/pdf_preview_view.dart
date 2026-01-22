import 'dart:typed_data';

import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard/global/global_dashboard_cubit.dart';
import 'package:cvms_desktop/features/dashboard/pdf/components/viewer/pdf_viewer_widget.dart';
import 'package:cvms_desktop/features/dashboard/pdf/utils/pdf_file_name_builder.dart';
import 'package:cvms_desktop/features/dashboard/services/pdf/pdf_print_service.dart';
import 'package:cvms_desktop/features/dashboard/services/pdf/pdf_save_service.dart';
import 'package:cvms_desktop/features/dashboard/widgets/navigation/pdf_preview_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';

class PdfPreviewView extends StatelessWidget {
  final VoidCallback onBackPressed;
  final Uint8List? pdfBytes;
  final PdfSaveService? saveService;
  final PdfPrintService? printService;
  const PdfPreviewView({
    super.key,
    required this.onBackPressed,
    this.pdfBytes,
    this.saveService,
    this.printService,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalDashboardCubit, GlobalDashboardState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.greySurface,
          appBar: PdfPreviewAppBar(
            breadcrumbs: [],
            onBackPressed: onBackPressed,
            onDownLoadPressed: () async {
              debugPrint(
                "DEBUG PDF PREVIEW VIEW DOWNLOAD CLICKED CLICKEDDDD!!!!",
              );
              if (pdfBytes == null) return;

              final fileName =
                  state.viewMode == DashboardViewMode.global
                      ? PdfFileNameBuilder.globalReport(DateTime.now())
                      : PdfFileNameBuilder.individualVehicleReport(
                        plateNumber: 'ABC-123', // pull from selected vehicle
                      );

              await saveService?.savePdf(
                pdfBytes: pdfBytes!,
                suggestedFileName: fileName,
              );
            },

            onPrintPressed: () async {
              debugPrint("DEBUG PDF PREVIEW VIEW PRINT CLICKED CLICKEDDDD!!!!");
              if (pdfBytes == null) return;

              await printService?.printPdf(
                pdfBytes: pdfBytes!,
                pageFormat: PdfPageFormat.a4, // can be dynamic later
              );
            },
            onEditPressed: () {},
            toggleFitMode: () {},
            isFitToWidth: false,
            isChart: true,
          ),
          body:
              pdfBytes == null || pdfBytes!.isEmpty
                  ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No PDF generated',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  )
                  : PdfViewerWidget(pdfBytes: pdfBytes!),
        );
      },
    );
  }
}
