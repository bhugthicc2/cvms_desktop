import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/navigation/custom_breadcrumb.dart';
import 'package:cvms_desktop/features/vehicle_management/pages/add_vehicle/add_vehicle_review.dart';
import 'package:cvms_desktop/features/vehicle_management/pages/add_vehicle/add_vehicle_step1.dart';
import 'package:cvms_desktop/features/vehicle_management/pages/add_vehicle/add_vehicle_step2.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/skeletons/table_skeleton.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/tables/vehicle_table.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../bloc/vehicle_cubit.dart';
import 'package:flutter/material.dart';

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
      body: BlocBuilder<VehicleCubit, VehicleState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, VehicleState state) {
    if (state.isLoading) {
      return Skeletonizer(
        enabled: state.isLoading,
        child: buildSkeletonTable(),
      );
    }

    switch (state.viewMode) {
      case VehicleViewMode.list:
        return VehicleTable(
          title: "Vehicle Management",
          entries: state.filteredEntries,
          searchController: vehicleController,
          onAddVehicle: () {
            context.read<VehicleCubit>().showAddVehicleStep1();
          },
        );

      case VehicleViewMode.addVehicleStep1:
        return AddVehicleStep1(
          onNext: () => context.read<VehicleCubit>().goToStep2(),
          onCancel: () => context.read<VehicleCubit>().backToList(),
        );

      case VehicleViewMode.addVehicleStep2:
        return AddVehicleStep2(
          onNext: () => context.read<VehicleCubit>().goToReview(),
          onBack: () => context.read<VehicleCubit>().showAddVehicleStep1(),
        );

      case VehicleViewMode.addVehicleReview:
        return AddVehicleReview(
          onSubmit: () {
            context.read<VehicleCubit>().backToList();
          },
          onBack: () => context.read<VehicleCubit>().goToStep2(),
        );
    }
  }

  List<BreadcrumbItem> buildBreadcrumbs(
    BuildContext context,
    VehicleState state,
  ) {
    final cubit = context.read<VehicleCubit>();

    final items = <BreadcrumbItem>[];

    if (state.viewMode == VehicleViewMode.addVehicleStep1) {
      items.add(
        BreadcrumbItem(label: 'Add Vehicle', onTap: cubit.showAddVehicleStep1),
      );
    }

    if (state.viewMode == VehicleViewMode.addVehicleStep2) {
      items.addAll([
        BreadcrumbItem(label: 'Add Vehicle', onTap: cubit.showAddVehicleStep1),
        BreadcrumbItem(label: 'Step 2'),
      ]);
    }

    if (state.viewMode == VehicleViewMode.addVehicleReview) {
      items.addAll([
        BreadcrumbItem(label: 'Add Vehicle', onTap: cubit.showAddVehicleStep1),
        BreadcrumbItem(label: 'Step 2', onTap: cubit.goToStep2),
        BreadcrumbItem(label: 'Review'),
      ]);
    }

    return items;
  }
}
