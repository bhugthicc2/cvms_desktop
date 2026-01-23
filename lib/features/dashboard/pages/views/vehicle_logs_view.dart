import 'package:cvms_desktop/core/widgets/app/custom_view_title.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/bloc/vehicle_logs_cubit.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/bloc/vehicle_logs_state.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/widgets/tables/vehicle_logs_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/skeletons/table_skeleton.dart';
import 'package:skeletonizer/skeletonizer.dart';

class VehicleLogsView extends StatefulWidget {
  final VoidCallback onBackPressed;
  const VehicleLogsView({super.key, required this.onBackPressed});

  @override
  State<VehicleLogsView> createState() => _VehicleLogsViewState();
}

class _VehicleLogsViewState extends State<VehicleLogsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize vehicles when the view is created
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
              viewTitle: 'Vehicle Logs',
              onBackPressed: widget.onBackPressed,
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

                  if (state.filteredEntries.isEmpty) {
                    return const Center(
                      child: Text(
                        'No vehicles found',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return VehicleLogsTable(
                    title: 'All Vehicles',

                    searchController: _searchController,
                    logs: state.allLogs,
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
