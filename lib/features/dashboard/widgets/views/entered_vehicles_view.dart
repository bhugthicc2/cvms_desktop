import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/bloc/vehicle_logs_cubit.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/widgets/tables/vehicle_logs_table.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/widgets/skeletons/table_skeleton.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/bloc/vehicle_logs_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EnteredVehiclesView extends StatefulWidget {
  const EnteredVehiclesView({super.key});

  @override
  State<EnteredVehiclesView> createState() => _EnteredVehiclesViewState();
}

class _EnteredVehiclesViewState extends State<EnteredVehiclesView> {
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
            Text(
              'Entered Vehicles',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
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

                  // Filter for entered vehicles only
                  final enteredVehicles =
                      state.filteredEntries
                          .where((log) => log.status.toLowerCase() == 'entered')
                          .toList();

                  if (enteredVehicles.isEmpty) {
                    return const Center(
                      child: Text(
                        'No entered vehicles found',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return VehicleLogsTable(
                    title: 'Entered Vehicles',
                    logs: enteredVehicles,
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
