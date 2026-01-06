import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/skeletons/table_skeleton.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/tables/vehicle_table.dart';
import 'package:cvms_desktop/features/vehicle_management/models/vehicle_entry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/vehicle_cubit.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class VehicleManagementPage extends StatefulWidget {
  const VehicleManagementPage({super.key});

  @override
  State<VehicleManagementPage> createState() => _VehicleManagementPageState();
}

class _VehicleManagementPageState extends State<VehicleManagementPage> {
  final TextEditingController vehicleController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<VehicleCubit>().listenVehicles();

    vehicleController.addListener(() {
      context.read<VehicleCubit>().filterEntries(vehicleController.text);
    });
  }

  @override
  void dispose() {
    vehicleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: BlocBuilder<VehicleCubit, VehicleState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Skeletonizer(
                enabled: state.isLoading,
                child: buildSkeletonTable(),
              );
            }

            return VehicleTable(
              title: "Vehicle Management",
              entries: state.filteredEntries,
              searchController: vehicleController,
            );
          },
        ),
      ),
    );
  }
}
