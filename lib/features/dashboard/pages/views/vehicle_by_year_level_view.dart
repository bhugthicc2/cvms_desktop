import 'package:cvms_desktop/core/widgets/app/custom_dropdown.dart';
import 'package:cvms_desktop/core/widgets/app/custom_view_title.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/activity_logs/widgets/skeletons/table_skeleton.dart';
import 'package:cvms_desktop/features/vehicle_management/bloc/vehicle_cubit.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/tables/vehicle_table.dart';
import 'package:flutter/material.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class VehicleByYearLevelView extends StatefulWidget {
  final VoidCallback onBackPressed;
  const VehicleByYearLevelView({super.key, required this.onBackPressed});

  @override
  State<VehicleByYearLevelView> createState() => _VehicleByYearLevelViewState();
}

class _VehicleByYearLevelViewState extends State<VehicleByYearLevelView> {
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
              viewTitle: 'Vehicles by Year Level',
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
                    additionalHeaderItem: _buildYearLevelDropdown(),
                    hasImportBtn: false,
                    title: 'Vehicles by Year Level',
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

  Widget? _buildYearLevelDropdown() {
    return Expanded(
      child: Row(
        children: [
          Spacing.horizontal(size: AppSpacing.medium),
          Expanded(
            child: CustomDropdown(
              items: [
                'All',
                '1st',
                '2nd',
                '3rd',
                '4th',
              ], //todo should be dynamic based on the fetched college
              initialValue: 'All',
              onChanged: (value) {
                context.read<VehicleCubit>().filterByYearLevel(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
