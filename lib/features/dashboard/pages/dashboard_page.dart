import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard_cubit.dart';
import 'package:cvms_desktop/features/dashboard/widgets/dialogs/custom_view_dialog.dart';
import 'package:cvms_desktop/features/dashboard/widgets/sections/dashboard_overview.dart';
import 'package:cvms_desktop/features/dashboard/widgets/tables/vehicle_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController enteredSearchController = TextEditingController();
  final TextEditingController exitedSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().startListening();

    enteredSearchController.addListener(() {
      context.read<DashboardCubit>().filterEntered(
        enteredSearchController.text,
      );
    });
    exitedSearchController.addListener(() {
      context.read<DashboardCubit>().filterExited(exitedSearchController.text);
    });
  }

  @override
  void dispose() {
    enteredSearchController.dispose();
    exitedSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          children: [
            const DashboardOverview(),
            Spacing.vertical(size: AppSpacing.medium),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: BlocBuilder<DashboardCubit, DashboardState>(
                      builder: (context, state) {
                        return VehicleTable(
                          title: "ENTERED",
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
                                    value: context.read<DashboardCubit>(),
                                    child: CustomViewDialog(
                                      title: "Edit Vehicle Information",
                                      vehicleId: vehId,
                                    ),
                                  ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Spacing.horizontal(size: AppSpacing.medium),
                  Expanded(
                    child: BlocBuilder<DashboardCubit, DashboardState>(
                      builder: (context, state) {
                        return VehicleTable(
                          title: "EXITED",
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
                                    value: context.read<DashboardCubit>(),
                                    child: CustomViewDialog(
                                      title: "Edit Vehicle Information",
                                      vehicleId: vehId,
                                    ),
                                  ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
