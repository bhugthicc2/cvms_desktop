import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/reports/widgets/app/pdf_preview_app_bar.dart';
import 'package:cvms_desktop/features/reports/widgets/editor/pdf_editor_widget.dart';
import 'package:cvms_desktop/features/reports/bloc/pdf/pdf_editor_cubit.dart';
import 'package:cvms_desktop/features/reports/widgets/viewer/pdf_viewer_widget.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/core/widgets/navigation/custom_breadcrumb.dart';
import 'dart:typed_data';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard_state.dart';
import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';
import 'package:cvms_desktop/features/reports/models/fleet_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:lottie/lottie.dart';

class PdfReportPage extends StatefulWidget {
  final VoidCallback? onBackPressed;
  final FleetSummary? fleetSummary;
  final List<ChartDataModel>? vehicleDistribution;
  final List<ChartDataModel>? yearLevelBreakdown;
  final List<ChartDataModel>? cityBreakdown;
  final List<ChartDataModel>? studentWithMostViolations;
  final List<ChartDataModel> logsData;
  final TimeRange selectedTimeRange;
  final Uint8List? vehicleDistributionChartBytes;
  final Uint8List? yearLevelBreakdownChartBytes;
  final Uint8List? studentwithMostViolationChartBytes;
  final Uint8List? cityBreakdownChartBytes;
  final Uint8List? vehicleLogsDistributionChartBytes;
  final Uint8List? violationDistributionPerCollegeChartBytes;
  final Uint8List? top5ViolationByTypeChartBytes;
  final Uint8List? fleetLogsChartBytes;

  const PdfReportPage({
    super.key,
    this.onBackPressed,
    this.fleetSummary,
    this.vehicleDistribution,
    this.yearLevelBreakdown,
    this.cityBreakdown,
    this.studentWithMostViolations,
    this.logsData = const [],
    this.selectedTimeRange = TimeRange.days7,
    this.vehicleDistributionChartBytes,
    this.yearLevelBreakdownChartBytes,
    this.studentwithMostViolationChartBytes,
    this.cityBreakdownChartBytes,
    this.vehicleLogsDistributionChartBytes,
    this.violationDistributionPerCollegeChartBytes,
    this.top5ViolationByTypeChartBytes,
    this.fleetLogsChartBytes,
  });

  @override
  State<PdfReportPage> createState() => _PdfReportPageState();
}

class _PdfReportPageState extends State<PdfReportPage> {
  void _navigateToReports() {
    // todo Implement navigation to reports section
    widget.onBackPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => PdfEditorCubit(
            fleetSummary: widget.fleetSummary,
            vehicleDistribution: widget.vehicleDistribution,
            yearLevelBreakdown: widget.yearLevelBreakdown,
            cityBreakdown: widget.cityBreakdown,
            studentWithMostViolations: widget.studentWithMostViolations,
            logsData: widget.logsData,
            selectedTimeRange: widget.selectedTimeRange,
            vehicleDistributionChartBytes: widget.vehicleDistributionChartBytes,
            yearLevelBreakdownChartBytes: widget.yearLevelBreakdownChartBytes,
            studentwithMostViolationChartBytes:
                widget.studentwithMostViolationChartBytes,
            cityBreakdownChartBytes: widget.cityBreakdownChartBytes,
            vehicleLogsDistributionChartBytes:
                widget.vehicleLogsDistributionChartBytes,
            violationDistributionPerCollegeChartBytes:
                widget.violationDistributionPerCollegeChartBytes,
            top5ViolationByTypeChartBytes: widget.top5ViolationByTypeChartBytes,
            fleetLogsChartBytes: widget.fleetLogsChartBytes,
          )..generatePdf(),
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
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset(
              renderCache: RenderCache.raster,
              'assets/anim/report_loadin_anim.json',
              width: 280,
            ),
          ),
          Spacing.vertical(size: AppSpacing.small),
          Text(
            'Loading...',
            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
              fontSize: AppFontSizes.large,
            ),
          ),
          Text(
            'Please wait while we generate you report.',
            style: TextStyle(
              color: AppColors.black,
              fontSize: AppFontSizes.medium,
            ),
          ),
        ],
      );
    }

    if (state is PdfSaving) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Lottie.asset(
                renderCache: RenderCache.raster,
                'assets/anim/loading_anim.json',
                width: 200,
                height: 200,
              ),
            ),
            SizedBox(height: 16),
            Text('Saving PDF...'),
          ],
        ),
      );
    }

    if (state is PdfPrinting) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Lottie.asset(
                renderCache: RenderCache.raster,
                'assets/anim/loading_anim.json',
                width: 200,
                height: 200,
              ),
            ),
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
