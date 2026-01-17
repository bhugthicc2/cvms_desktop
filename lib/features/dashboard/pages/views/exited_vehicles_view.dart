import 'package:cvms_desktop/features/dashboard/widgets/titles/custom_view_title.dart';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/bloc/vehicle_logs_cubit.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/widgets/tables/vehicle_logs_table.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/widgets/skeletons/table_skeleton.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/bloc/vehicle_logs_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExitedVehiclesView extends StatefulWidget {
  const ExitedVehiclesView({super.key});

  @override
  State<ExitedVehiclesView> createState() => _ExitedVehiclesViewState();
}

class _ExitedVehiclesViewState extends State<ExitedVehiclesView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize vehicle logs when the view is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleLogsCubit>().loadVehicleLogs();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomViewTitle(
              viewTitle: 'Exited Vehicles',
              onBackClick: () {
                context.read<DashboardCubit>().showOverview();
              },
            ),
            const SizedBox(height: AppSpacing.medium),
            Expanded(
              child: BlocBuilder<VehicleLogsCubit, VehicleLogsState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return Skeletonizer(
                      enabled: true,
                      child: buildSkeletonTable(),
                    );
                  }

                  if (state.error != null) {
                    return Center(
                      child: Text(
                        'Error: ${state.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  // Filter for exited vehicles only
                  final exitedVehicles =
                      state.filteredEntries
                          .where((log) => log.status.toLowerCase() == 'exited')
                          .toList();

                  if (exitedVehicles.isEmpty) {
                    return const Center(
                      child: Text(
                        'No exited vehicles found',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return VehicleLogsTable(
                    title: 'Exited Vehicles',
                    logs: exitedVehicles,
                    searchController: _searchController,
                    hasSearchQuery: _searchController.text.isNotEmpty,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
