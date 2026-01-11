import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/reports/widgets/sections/pdf_preview_app_bar.dart';
import 'package:cvms_desktop/features/reports/widgets/content/pdf_editor_content.dart';
import 'package:cvms_desktop/features/reports/widgets/content/pdf_previewer_content.dart';
import 'package:cvms_desktop/features/reports/bloc/pdf_editor_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';

class PdfReportPage extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const PdfReportPage({super.key, this.onBackPressed});

  @override
  State<PdfReportPage> createState() => _PdfReportPageState();
}

class _PdfReportPageState extends State<PdfReportPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PdfEditorCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.greySurface,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(35),
              child: BlocBuilder<PdfEditorCubit, PdfEditorState>(
                builder: (context, state) {
                  return PdfPreviewAppBar(
                    title:
                        state is PdfEditorEditMode
                            ? "PDF Editor"
                            : "PDF Report Preview",
                    onBackPressed: () {
                      widget.onBackPressed?.call();
                    },
                    onDownLoadPressed: () {
                      //todo
                    },
                    onPrintPressed: () {
                      //todo
                    },
                    onEditPressed: () {
                      context.read<PdfEditorCubit>().toggleEditMode();
                    },
                  );
                },
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(left: AppSpacing.xSmall - 2),
              child: SizedBox(
                height: double.infinity,
                child: Column(
                  children: [
                    //Divider
                    Spacing.vertical(size: AppSpacing.xSmall - 2),
                    // PDF
                    Expanded(
                      child: Row(
                        children: [
                          //pdf preview/edit section
                          Expanded(
                            flex: 2,
                            child: Container(
                              color: AppColors.white,
                              child:
                                  BlocBuilder<PdfEditorCubit, PdfEditorState>(
                                    builder: (context, state) {
                                      return state is PdfEditorEditMode
                                          ? const PdfEditorContent()
                                          : const PdfPreviewerContent();
                                    },
                                  ),
                            ),
                          ),
                          // Spacing.horizontal(size: AppSpacing.xSmall - 2),
                          // Expanded(
                          //   child: Container(
                          //     color: AppColors.white,
                          //     child: const Center(child: Text("PDF Controls")),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
