import 'package:cvms_desktop/features/reports/widgets/app/pdf_preview_app_bar.dart';
import 'package:cvms_desktop/features/reports/widgets/editor/pdf_editor_widget.dart';
import 'package:cvms_desktop/features/reports/bloc/pdf/pdf_editor_cubit.dart';
import 'package:cvms_desktop/features/reports/widgets/viewer/pdf_viewer_widget.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/core/widgets/navigation/custom_breadcrumb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';

class PdfReportPage extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const PdfReportPage({super.key, this.onBackPressed});

  @override
  State<PdfReportPage> createState() => _PdfReportPageState();
}

class _PdfReportPageState extends State<PdfReportPage> {
  void _navigateToDashboard() {
    // TODO: Implement navigation to dashboard
    widget.onBackPressed?.call();
  }

  void _navigateToReports() {
    // TODO: Implement navigation to reports section
    widget.onBackPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PdfEditorCubit()..generatePdf(),
      child: BlocListener<PdfEditorCubit, PdfEditorState>(
        listener: (context, state) {
          if (state is PdfSaveSuccess) {
            CustomSnackBar.showSuccess(context, state.message);
            // Return to preview mode after showing success
            Future.delayed(const Duration(milliseconds: 500), () {
              if (context.mounted) {
                context.read<PdfEditorCubit>().returnToPreviewMode();
              }
            });
          } else if (state is PdfError && !state.message.contains('print')) {
            // Only show non-print errors in snackbar (print errors show in dialog)
            CustomSnackBar.showError(context, state.message);
          }
        },
        child: BlocBuilder<PdfEditorCubit, PdfEditorState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: AppColors.greySurface,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(35),
                child: BlocBuilder<PdfEditorCubit, PdfEditorState>(
                  builder: (context, state) {
                    final isEditMode = state is PdfEditorEditMode;
                    final breadcrumbs = [
                      BreadcrumbItem(
                        label: 'Vehicle reports',
                        onTap: _navigateToReports,
                      ),
                      BreadcrumbItem(
                        label: isEditMode ? 'PDF Editor' : 'PDF Report Preview',
                        isActive: true,
                      ),
                    ];

                    return PdfPreviewAppBar(
                      title: isEditMode ? "PDF Editor" : "PDF Report Preview",
                      breadcrumbs: breadcrumbs,
                      onBackPressed: () {
                        widget.onBackPressed?.call();
                      },
                      isFitToWidth: true, //todo
                      toggleFitMode: () {
                        //todo
                      },
                      onDownLoadPressed: () {
                        context.read<PdfEditorCubit>().savePdfToFile();
                      },
                      onPrintPressed: () {
                        context.read<PdfEditorCubit>().printPdf();
                      },
                      onEditPressed: () {
                        context.read<PdfEditorCubit>().toggleEditMode();
                      },
                    );
                  },
                ),
              ),
              body: _buildBody(state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(PdfEditorState state) {
    if (state is PdfLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is PdfSaving) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Saving PDF...'),
          ],
        ),
      );
    }

    if (state is PdfPrinting) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Preparing print dialog...'),
          ],
        ),
      );
    }

    if (state is PdfSaveSuccess && state.pdfBytes != null) {
      return PdfViewerWidget(pdfBytes: state.pdfBytes!);
    }

    if (state is PdfEditorPreviewMode && state.pdfBytes != null) {
      return PdfViewerWidget(pdfBytes: state.pdfBytes!);
    }

    if (state is PdfEditorEditMode) {
      return const PdfEditorWidget();
    }

    if (state is PdfError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${state.message}',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<PdfEditorCubit>().generatePdf(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return const SizedBox();
  }
}
