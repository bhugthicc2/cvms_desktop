import 'dart:typed_data';

import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
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
              if (pdfBytes == null) return;

              final fileName =
                  state.previousViewMode == DashboardViewMode.global
                      ? PdfFileNameBuilder.globalReport(DateTime.now())
                      : PdfFileNameBuilder.individualVehicleReport(
                        plateNumber:
                            state
                                .selectedVehicle!
                                .ownerName, // pull from selected vehicle
                      );

              try {
                final savedPath = await saveService?.savePdf(
                  pdfBytes: pdfBytes!,
                  suggestedFileName: fileName,
                );

                if (context.mounted) {
                  if (savedPath != null) {
                    CustomSnackBar.showSuccess(
                      context,
                      'PDF saved to: $savedPath',
                    );
                  } else {
                    CustomSnackBar.showInfo(
                      context,
                      'Save operation was cancelled',
                    );
                  }
                }
              } catch (e) {
                if (context.mounted) {
                  CustomSnackBar.showError(
                    context,
                    'Failed to save PDF: ${e.toString()}',
                  );
                }
              }
            },

            onPrintPressed: () async {
              if (pdfBytes == null) return;

              try {
                await printService?.printPdf(
                  pdfBytes: pdfBytes!,
                  pageFormat: PdfPageFormat.a4, // can be dynamic later
                );
                if (context.mounted) {
                  CustomSnackBar.showSuccess(
                    context,
                    'PDF sent to printer successfully',
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  CustomSnackBar.showError(
                    context,
                    'Failed to print PDF: ${e.toString()}',
                  );
                }
              }
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
