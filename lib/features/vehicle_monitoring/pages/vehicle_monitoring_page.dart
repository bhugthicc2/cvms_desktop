import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/skeleton/dashboard_overview_skeleton.dart';
import 'package:cvms_desktop/features/vehicle_monitoring/widgets/sections/dashboard_overview.dart';
import 'package:cvms_desktop/features/vehicle_monitoring/widgets/skeletons/table_skeleton.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/vehicle_monitoring/bloc/vehicle_monitoring_cubit.dart';
import 'package:cvms_desktop/features/vehicle_monitoring/widgets/dialogs/custom_view_dialog.dart';
import 'package:cvms_desktop/features/vehicle_monitoring/widgets/tables/vehicle_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class VehicleMonitoringPage extends StatefulWidget {
  const VehicleMonitoringPage({super.key});

  @override
  State<VehicleMonitoringPage> createState() => _VehicleMonitoringPageState();
}

class _VehicleMonitoringPageState extends State<VehicleMonitoringPage> {
  final TextEditingController enteredSearchController = TextEditingController();
  final TextEditingController exitedSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<VehicleMonitoringCubit>().startListening();

    enteredSearchController.addListener(() {
      context.read<VehicleMonitoringCubit>().filterEntered(
        enteredSearchController.text,
      );
    });
    exitedSearchController.addListener(() {
      context.read<VehicleMonitoringCubit>().filterExited(
        exitedSearchController.text,
      );
    });
  }

  @override
  void dispose() {
    enteredSearchController.dispose();
    exitedSearchController.dispose();
    super.dispose();
  }

  // Helper method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: BlocBuilder<VehicleMonitoringCubit, VehicleMonitoringState>(
          builder: (context, state) {
            if (state.loading) {
              return Skeletonizer(
                enabled: true,
                child: Column(
                  children: [
                    buildSkeletonDashOverview(),

                    Spacing.vertical(size: AppSpacing.medium),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: buildSkeletonTable("ONSITE"),
                          ), // Dummy widget
                          Spacing.horizontal(size: AppSpacing.medium),
                          Expanded(child: buildSkeletonTable("OFFSITE")),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                const DashboardOverview(),
                Spacing.vertical(size: AppSpacing.medium),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: VehicleTable(
                          title: "ONSITE",
                          entries: state.enteredFiltered,
                          searchController: enteredSearchController,
                          hasSearchQuery:
                              enteredSearchController.text.isNotEmpty,
                          onCellTap: (details) {
                            final rowIndex =
                                details.rowColumnIndex.rowIndex - 1;
                            if (rowIndex < 0 ||
                                rowIndex >= state.enteredFiltered.length) {
                              return;
                            }

                            final vehId =
                                state.enteredFiltered[rowIndex].vehicleId;
                            showDialog(
                              context: context,
                              builder:
                                  (_) => BlocProvider.value(
                                    value:
                                        context.read<VehicleMonitoringCubit>(),
                                    child: CustomViewDialog(
                                      title: "Edit Vehicle Information",
                                      vehicleId: vehId,
                                    ),
                                  ),
                            );
                          },
                        ),
                      ),
                      Spacing.horizontal(size: AppSpacing.medium),
                      Expanded(
                        child: VehicleTable(
                          title: "OFFSITE",
                          entries: state.exitedFiltered,
                          searchController: exitedSearchController,
                          hasSearchQuery:
                              exitedSearchController.text.isNotEmpty,
                          onCellTap: (details) {
                            final rowIndex =
                                details.rowColumnIndex.rowIndex - 1;
                            if (rowIndex < 0 ||
                                rowIndex >= state.exitedFiltered.length) {
                              return;
                            }
                            final vehId =
                                state.exitedFiltered[rowIndex].vehicleId;
                            showDialog(
                              context: context,
                              builder:
                                  (_) => BlocProvider.value(
                                    value:
                                        context.read<VehicleMonitoringCubit>(),
                                    child: CustomViewDialog(
                                      title: "Edit Vehicle Information",
                                      vehicleId: vehId,
                                    ),
                                  ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
