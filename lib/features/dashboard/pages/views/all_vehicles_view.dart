import 'package:cvms_desktop/core/widgets/app/custom_view_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/features/vehicle_management/bloc/vehicle_cubit.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/tables/vehicle_table.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/skeletons/table_skeleton.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AllVehiclesView extends StatefulWidget {
  final VoidCallback onBackPressed;
  const AllVehiclesView({super.key, required this.onBackPressed});

  @override
  State<AllVehiclesView> createState() => _AllVehiclesViewState();
}

class _AllVehiclesViewState extends State<AllVehiclesView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize vehicles when the view is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleCubit>().listenVehicles();
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
              viewTitle: 'All Vehicles',
              onBackPressed: widget.onBackPressed,
            ),

            const SizedBox(height: AppSpacing.medium),
            Expanded(
              child: BlocBuilder<VehicleCubit, VehicleState>(
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

                  return VehicleTable(
                    title: 'All Vehicles',
                    entries: state.filteredEntries,
                    searchController: _searchController,
                    onAddVehicle: () {
                      // TODO: Navigate to add vehicle
                    },
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
