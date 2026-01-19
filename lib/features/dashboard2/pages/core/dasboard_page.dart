import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/navigation/bread_crumb_item.dart';
import 'package:cvms_desktop/core/widgets/skeleton/report_skeleton_loader.dart';
import 'package:cvms_desktop/features/dashboard2/bloc/dashboard_cubit.dart';
import 'package:cvms_desktop/features/dashboard2/models/vehicle_search_suggestion.dart';
import 'package:cvms_desktop/features/dashboard2/pages/views/global_dashboard_view.dart';
import 'package:cvms_desktop/features/dashboard2/pages/views/individual_report_view.dart';
import 'package:cvms_desktop/features/dashboard2/pages/views/pdf_preview_view.dart';
import 'package:cvms_desktop/features/dashboard2/repositories/global_dashboard_repository.dart';
import 'package:cvms_desktop/features/dashboard2/repositories/vehicle_search_repository.dart';
import 'package:cvms_desktop/features/dashboard2/services/vehicle_search_service.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/sections/dashboard_controls_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/features/shell/scope/breadcrumb_scope.dart';
import 'package:cvms_desktop/features/shell/bloc/shell_cubit.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  List<BreadcrumbItem> _buildBreadcrumbs(DashboardViewMode viewMode) {
    switch (viewMode) {
      case DashboardViewMode.global:
        return []; // Root level - no breadcrumbs
      case DashboardViewMode.individual:
        return [BreadcrumbItem(label: 'Individual Report')];
      case DashboardViewMode.pdfPreview:
        return [BreadcrumbItem(label: 'PDF Preview', isActive: true)];
    }
  }

  /// Build main content based on view mode
  Widget _buildMainContent(BuildContext context, DashboardState state) {
    switch (state.viewMode) {
      case DashboardViewMode.global:
        return const GlobalDashboardView();
      case DashboardViewMode.individual:
        return IndividualReportView(vehicle: state.selectedVehicle!);
      case DashboardViewMode.pdfPreview:
        return PdfPreviewView(
          onBackPressed: () {
            // Navigate back to previous view (individual or global)
            context.read<DashboardCubit>().backToPreviousView();
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => DashboardCubit(
            GlobalDashboardRepository(
              FirebaseFirestore.instance,
            ), // Realtime implementation step 20
          ),
      child: BlocListener<DashboardCubit, DashboardState>(
        listener: (context, state) {
          // Gating: Only publish breadcrumbs if this is the active page
          if (context.read<ShellCubit>().state.selectedIndex != 1) return;

          final breadcrumbs = _buildBreadcrumbs(state.viewMode);
          BreadcrumbScope.controllerOf(context).setBreadcrumbs(breadcrumbs);
        },
        child: BlocBuilder<DashboardCubit, DashboardState>(
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
                      'Error: ${state.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    ElevatedButton(
                      onPressed:
                          () => context.read<DashboardCubit>().clearError(),
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
                child: Container(
                  key: ValueKey(state.viewMode.toString()),
                  //todo pdf preview should not be affected by the scrollview
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Controls section (not for PDF preview)
                        if (state.viewMode != DashboardViewMode.pdfPreview)
                          DashboardControlsSection(
                            showBackButton:
                                state.viewMode != DashboardViewMode.global,
                            dateFilterText: 'DATE FILTER',
                            onExportPressed: () {
                              // todo Export report
                              // Navigate to PDF preview
                              context.read<DashboardCubit>().showPdfPreview();
                            },
                            onSearchSuggestions: (query) async {
                              // DASHBOARD SEARCH FUNCTIONALITY STEP 4
                              final searchService = VehicleSearchService(
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
                              context.read<DashboardCubit>().showIndividualReport(
                                suggestion.vehicleId,
                              ); //navigate to individual report and display its dedicated report
                            },

                            onBackButtonPressed:
                                state.viewMode == DashboardViewMode.individual
                                    ? () {
                                      // Nav back to global view
                                      context
                                          .read<DashboardCubit>()
                                          .backToGlobal();
                                    }
                                    : null,
                          ),

                        // Main content
                        SizedBox(child: _buildMainContent(context, state)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
