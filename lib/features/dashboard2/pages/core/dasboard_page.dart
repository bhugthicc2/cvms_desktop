import 'package:cvms_desktop/core/widgets/navigation/bread_crumb_item.dart';
import 'package:cvms_desktop/features/dashboard2/bloc/dashboard_cubit.dart';
import 'package:cvms_desktop/features/dashboard2/pages/views/global_dashboard_view.dart';
import 'package:cvms_desktop/features/dashboard2/pages/views/individual_report_view.dart';
import 'package:cvms_desktop/features/dashboard2/pages/views/pdf_preview_view.dart';
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
        return [
          BreadcrumbItem(label: 'Individual Report'),
          BreadcrumbItem(label: 'PDF Preview', isActive: true),
        ];
    }
  }

  Widget _buildView(DashboardViewMode viewMode) {
    switch (viewMode) {
      case DashboardViewMode.global:
        return const GlobalDashboardView();
      case DashboardViewMode.individual:
        return const IndividualReportView();
      case DashboardViewMode.pdfPreview:
        return const PdfPreviewView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit(),
      child: BlocListener<DashboardCubit, DashboardState>(
        listener: (context, state) {
          // Gating: Only publish breadcrumbs if this is the active page
          if (context.read<ShellCubit>().state.selectedIndex != 1) return;

          final breadcrumbs = _buildBreadcrumbs(state.viewMode);
          BreadcrumbScope.controllerOf(context).setBreadcrumbs(breadcrumbs);
        },
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
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

            return _buildView(state.viewMode);
          },
        ),
      ),
    );
  }
}
