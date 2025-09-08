import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import '../bloc/vehicle_monitoring_cubit.dart';
import '../bloc/vehicle_monitoring_state.dart';
import '../models/vehicle_monitoring_entry.dart';
import '../widgets/tables/vehicle_monitoring_table.dart';
import '../widgets/dialogs/vehicle_monitoring_info_dialog.dart';

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

    // Mock data dawg
    final random = Random();
    final firstNames = ["John", "Maria", "Paolo", "Angela"];
    final lastNames = ["Reyes", "Cruz", "Patangan", "Medija"];

    String randomName() =>
        "${firstNames[random.nextInt(firstNames.length)]} ${lastNames[random.nextInt(lastNames.length)]}";

    final allEntries = List.generate(
      100,
      (i) => VehicleMonitoringEntry(
        i.isEven ? "inside" : "outside",
        name: randomName(),
        vehicle: i.isEven ? "Honda Beat" : "Yamaha Mio",
        plateNumber: "ABC-${100 + i}",
        duration: Duration(
          hours: 1 + random.nextInt(5),
          minutes: random.nextInt(60),
        ),
        entryTime:
            i.isEven
                ? DateTime.now().subtract(Duration(hours: random.nextInt(24)))
                : null,
        exitTime:
            i.isOdd
                ? DateTime.now().subtract(Duration(hours: random.nextInt(24)))
                : null,
      ),
    );
    // Mock data dawg

    // Load entries into cubit
    context.read<VehicleMonitoringCubit>().loadEntries(allEntries);

    // Listen to search controllers
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: BlocBuilder<
                      VehicleMonitoringCubit,
                      VehicleMonitoringState
                    >(
                      builder: (context, state) {
                        return VehicleMonitoringTable(
                          title: "Vehicles Entered",
                          entries: state.enteredFiltered,
                          searchController: enteredSearchController,
                          hasSearchQuery:
                              enteredSearchController.text.isNotEmpty,
                          onCellTap: (details) {
                            //exclude the header for showing the dialog
                            if (details.rowColumnIndex.rowIndex > 0) {
                              final entry =
                                  state.enteredFiltered[details
                                          .rowColumnIndex
                                          .rowIndex -
                                      1];
                              showDialog(
                                context: context,
                                builder:
                                    (_) => VehicleMonitoringInfoDialog(
                                      entry: entry,
                                    ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                  Spacing.horizontal(size: AppSpacing.medium),
                  Expanded(
                    child: BlocBuilder<
                      VehicleMonitoringCubit,
                      VehicleMonitoringState
                    >(
                      builder: (context, state) {
                        return VehicleMonitoringTable(
                          title: "Vehicles Exited",
                          entries: state.exitedFiltered,
                          searchController: exitedSearchController,
                          hasSearchQuery:
                              exitedSearchController.text.isNotEmpty,
                          onCellTap: (details) {
                            //exclude the header for showing the dialog
                            if (details.rowColumnIndex.rowIndex > 0) {
                              final entry =
                                  state.exitedFiltered[details
                                          .rowColumnIndex
                                          .rowIndex -
                                      1];
                              showDialog(
                                context: context,
                                builder:
                                    (_) => VehicleMonitoringInfoDialog(
                                      entry: entry,
                                    ),
                              );
                            }
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
