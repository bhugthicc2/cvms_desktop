import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/app/custom_alert_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_date_filter.dart';
import 'package:cvms_desktop/core/widgets/navigation/bread_crumb_item.dart';
import 'package:cvms_desktop/core/widgets/skeleton/report_skeleton_loader.dart';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard/global/global_dashboard_cubit.dart';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard/individual/individual_dashboard_cubit.dart';
import 'package:cvms_desktop/features/dashboard/di/dashboard_dependencies.dart';
import 'package:cvms_desktop/features/dashboard/models/dashboard/vehicle_search_suggestion.dart';
import 'package:cvms_desktop/features/dashboard/models/report/date_range.dart';
import 'package:cvms_desktop/features/dashboard/pages/views/global_dashboard_view.dart';
import 'package:cvms_desktop/features/dashboard/pages/views/individual_report_view.dart';
import 'package:cvms_desktop/features/dashboard/pages/views/pdf_preview_view.dart';
import 'package:cvms_desktop/features/dashboard/repositories/dashboard/global_dashboard_repository.dart';
import 'package:cvms_desktop/features/dashboard/repositories/dashboard/individual_dashboard_repository.dart';
import 'package:cvms_desktop/features/dashboard/repositories/dashboard/vehicle_search_repository.dart';
import 'package:cvms_desktop/features/dashboard/services/vehicle_search_service.dart';
import 'package:cvms_desktop/features/dashboard/use_cases/pdf/global_pdf_export_usecase.dart';
import 'package:cvms_desktop/features/dashboard/use_cases/pdf/individual_pdf_export_usecase.dart';
import 'package:cvms_desktop/features/dashboard/widgets/sections/dashboard_controls_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/features/shell/scope/breadcrumb_scope.dart';
import 'package:cvms_desktop/features/shell/bloc/shell_cubit.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  List<BreadcrumbItem> _buildBreadcrumbs(
    DashboardViewMode viewMode, [
    GlobalDashboardState? state,
  ]) {
    switch (viewMode) {
      case DashboardViewMode.global:
        return []; // Root level - no breadcrumbs
      case DashboardViewMode.individual:
        final ownerName = state?.selectedVehicle?.ownerName ?? 'Unknown';
        return [
          BreadcrumbItem(label: '$ownerName\'s Report'),
        ]; //shows owner name as breadcrumb item label
      case DashboardViewMode.pdfPreview:
        // Check if PDF preview is from individual or global report
        if (state?.previousViewMode == DashboardViewMode.individual) {
          final ownerName = state?.selectedVehicle?.ownerName ?? 'Unknown';
          return [
            BreadcrumbItem(label: '$ownerName\'s Report'),
            BreadcrumbItem(label: 'PDF Report Preview', isActive: true),
          ];
        } else {
          // Global PDF report
          return [BreadcrumbItem(label: 'PDF Report Preview', isActive: true)];
        }
    }
  }

  /// Build main content based on view mode
  Widget _buildMainContent(BuildContext context, GlobalDashboardState state) {
    switch (state.viewMode) {
      case DashboardViewMode.global:
        return const GlobalDashboardView();
      case DashboardViewMode.individual:
        return BlocProvider(
          key: ValueKey(
            state.selectedVehicle?.vehicleId,
          ), // Key changes recreate cubit
          create:
              (_) => IndividualDashboardCubit(
                vehicleId: state.selectedVehicle!.vehicleId,
                repository: IndividualDashboardRepository(
                  FirebaseFirestore.instance,
                ),
              ),
          child: IndividualReportView(vehicleInfo: state.selectedVehicle!),
        );

      case DashboardViewMode.pdfPreview:
        return PdfPreviewView(
          pdfBytes: state.pdfBytes,
          onBackPressed: () {
            context.read<GlobalDashboardCubit>().backToPreviousView();
          },
          saveService: DashboardDependencies().saveService,
          printService: DashboardDependencies().printService,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => GlobalDashboardCubit(
            null,
            GlobalDashboardRepository(FirebaseFirestore.instance),

            GlobalPdfExportUseCase(
              assembler: DashboardDependencies.globalReportAssembler,
              pdfService: DashboardDependencies.pdfGenerationService,
              brandingConfig: DashboardDependencies.pdfBrandingConfig,
            ),
            IndividualPdfExportUseCase(
              assembler: DashboardDependencies.individualReportAssembler,
              pdfService: DashboardDependencies.pdfGenerationService,
              brandingConfig: DashboardDependencies.pdfBrandingConfig,
            ), // Realtime implementation step 20
          ),

      child: BlocListener<GlobalDashboardCubit, GlobalDashboardState>(
        listener: (context, state) {
          // Gating: Only publish breadcrumbs if this is the active page
          if (context.read<ShellCubit>().state.selectedIndex != 0) return;

          final breadcrumbs = _buildBreadcrumbs(state.viewMode, state);
          BreadcrumbScope.controllerOf(context).setBreadcrumbs(breadcrumbs);
        },
        child: BlocBuilder<GlobalDashboardCubit, GlobalDashboardState>(
          builder: (context, state) {
            if (!state.initialized) {
              return const Scaffold(
                backgroundColor: AppColors.greySurface,
                body: ReportSkeletonLoader(),
              );
            }

            if (state.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: //${state.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    ElevatedButton(
                      onPressed:
                          () =>
                              context.read<GlobalDashboardCubit>().clearError(),
                      child: const Text('Dismiss'),
                    ),
                  ],
                ),
              );
            }

            return Scaffold(
              backgroundColor: AppColors.greySurface,
              body: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOutCubic,
                      ),
                    ),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: Stack(
                  children: [
                    Container(
                      key: ValueKey(state.viewMode.toString()),
                      child:
                          state.viewMode == DashboardViewMode.pdfPreview
                              ? // PDF preview: full screen, no scroll
                              SizedBox(child: _buildMainContent(context, state))
                              : // Other views: with controls and scroll
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    // Controls section
                                    DashboardControlsSection(
                                      isLoading: state.loading,
                                      showBackButton:
                                          state.viewMode !=
                                          DashboardViewMode.global,
                                      dateFilterText: 'DATE FILTER',
                                      onExportPressed: () async {
                                        if (state.loading) {
                                          return; // Prevent multiple clicks
                                        }
                                        final range =
                                            await showCustomDatePicker(context);
                                        if (range == null) return;
                                        if (context.mounted) {
                                          context
                                              .read<GlobalDashboardCubit>()
                                              .generateReport(range: range);
                                        }
                                      },

                                      onSearchSuggestions: (query) async {
                                        // DASHBOARD SEARCH FUNCTIONALITY STEP 4
                                        final searchService =
                                            VehicleSearchService(
                                              VehicleSearchRepository(
                                                FirebaseFirestore.instance,
                                              ),
                                            );
                                        final suggestions = await searchService
                                            .getSuggestions(query);
                                        return suggestions;
                                      },

                                      onVehicleSelected: (
                                        VehicleSearchSuggestion suggestion,
                                      ) {
                                        context
                                            .read<GlobalDashboardCubit>()
                                            .showIndividualReport(
                                              suggestion.vehicleId,
                                            ); //navigate to individual report and display its dedicated report
                                      },

                                      onBackButtonPressed:
                                          state.viewMode ==
                                                  DashboardViewMode.individual
                                              ? () {
                                                // Nav back to global view
                                                context
                                                    .read<
                                                      GlobalDashboardCubit
                                                    >()
                                                    .backToGlobal();
                                              }
                                              : null,
                                    ),

                                    // Main content
                                    SizedBox(
                                      child: _buildMainContent(context, state),
                                    ),
                                  ],
                                ),
                              ),
                    ),
                    // // Loading overlay
                    // if (state.loading) ReportLoadingAnim(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<DateRange?> showCustomDatePicker(BuildContext context) async {
    DateRange? selectedRange;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return CustomAlertDialog(
          title: 'Pick a date',
          subTitle: 'Please select a date first before generating the report.',
          child: CustomDateFilter(
            onApply: (period) {
              if (period != null) {
                selectedRange = period;
              }
              Navigator.of(dialogContext).pop();
            },
          ),
        );
      },
    );

    return selectedRange;
  }
}
