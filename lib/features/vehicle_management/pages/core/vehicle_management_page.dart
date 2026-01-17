import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/navigation/bread_crumb_item.dart';
import 'package:cvms_desktop/features/shell/bloc/shell_cubit.dart';
import 'package:cvms_desktop/features/shell/scope/breadcrumb_scope.dart';
import 'package:cvms_desktop/features/vehicle_management/pages/views/add_vehicle.dart';
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
    return MultiBlocListener(
      listeners: [
        BlocListener<ShellCubit, ShellState>(
          listenWhen: (previous, current) {
            return previous.selectedIndex != current.selectedIndex;
          },
          listener: (context, shellState) {
            if (shellState.selectedIndex != 3) return;
            final vehicleState = context.read<VehicleCubit>().state;
            BreadcrumbScope.controllerOf(
              context,
            ).setBreadcrumbs(_buildBreadcrumbs(context, vehicleState));
          },
        ),
        BlocListener<VehicleCubit, VehicleState>(
          listener: (context, state) {
            final selectedIndex =
                context.read<ShellCubit>().state.selectedIndex;
            if (selectedIndex != 3) return;

            BreadcrumbScope.controllerOf(
              context,
            ).setBreadcrumbs(_buildBreadcrumbs(context, state));
          },
        ),
      ],
      child: BlocBuilder<VehicleCubit, VehicleState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.greySurface,
            body: _buildBody(context, state),
          );
        },
      ),
    );
  }

  List<BreadcrumbItem> _buildBreadcrumbs(
    BuildContext context,
    VehicleState state,
  ) {
    switch (state.viewMode) {
      case VehicleViewMode.list:
        return const [];

      case VehicleViewMode.addVehicle:
        return [BreadcrumbItem(label: 'Add Vehicle')];
    }
  }

  Widget _buildBody(BuildContext context, VehicleState state) {
    if (state.isLoading) {
      return Skeletonizer(
        enabled: state.isLoading,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),

          child: buildSkeletonTable(),
        ),
      );
    }

    // Animated view switching
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _buildView(context, state),
    );
  }

  Widget _buildView(BuildContext context, VehicleState state) {
    switch (state.viewMode) {
      case VehicleViewMode.list:
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: VehicleTable(
            title: "Vehicle Management",
            entries: state.filteredEntries,
            searchController: vehicleController,
            onAddVehicle: () {
              context.read<VehicleCubit>().startAddVehicle();
            },
          ),
        );

      case VehicleViewMode.addVehicle:
        return AddVehicleView(
          //view for multi step form
          onNext: () {
            context.read<VehicleCubit>().nextAddVehicleStep();
          },
          onCancel: () {
            context.read<VehicleCubit>().backToList();
          },
        );
    }
  }
}
