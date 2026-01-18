import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/dashboard_cubit.dart';

class DashboardNavigationBar extends StatelessWidget {
  const DashboardNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              _buildNavigationButton(
                context,
                'Global Dashboard',
                state.viewMode == DashboardViewMode.global,
                () => context.read<DashboardCubit>().showGlobalDashboard(),
              ),
              const SizedBox(width: 16),
              _buildNavigationButton(
                context,
                'Individual Report',
                state.viewMode == DashboardViewMode.individual,
                () => context.read<DashboardCubit>().showIndividualReport(),
              ),
              const SizedBox(width: 16),
              _buildNavigationButton(
                context,
                'PDF Preview',
                state.viewMode == DashboardViewMode.pdfPreview,
                () => context.read<DashboardCubit>().showPdfPreview(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavigationButton(
    BuildContext context,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isActive ? Theme.of(context).primaryColor : Colors.grey[200],
        foregroundColor: isActive ? Colors.white : Colors.grey[700],
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label),
    );
  }
}
