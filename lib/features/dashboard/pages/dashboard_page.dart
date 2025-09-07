import 'dart:math';
import 'package:cvms_desktop/features/dashboard/widgets/custom_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard_cubit.dart';
import 'package:cvms_desktop/features/dashboard/models/vehicle_entry.dart';
import 'package:cvms_desktop/features/dashboard/widgets/dashboard_overview.dart';
import 'package:cvms_desktop/features/dashboard/widgets/vehicle_table.dart';

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

    // Mock data dawg
    final random = Random();
    final firstNames = ["John", "Maria", "Paolo", "Angela"];
    final lastNames = ["Reyes", "Cruz", "Patangan", "Medija"];

    String randomName() =>
        "${firstNames[random.nextInt(firstNames.length)]} ${lastNames[random.nextInt(lastNames.length)]}";

    final allEntries = List.generate(
      300,
      (i) => VehicleEntry(
        i.isEven ? "inside" : "outside",
        name: randomName(),
        vehicle: i.isEven ? "Honda Beat" : "Yamaha Mio",
        plateNumber: "ABC-${100 + i}",
        duration: Duration(
          hours: 1 + random.nextInt(5),
          minutes: random.nextInt(60),
        ),
      ),
    );
    // Mock data dawg

    // Load entries into cubit
    context.read<DashboardCubit>().loadEntries(allEntries);

    // Listen to search controllers
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
                          title: "Vehicles Entered",
                          entries: state.enteredFiltered,
                          searchController: enteredSearchController,
                          hasSearchQuery:
                              enteredSearchController.text.isNotEmpty,
                          onCellTap: (details) {
                            if (details.rowColumnIndex.rowIndex > 0) {
                              showDialog(
                                context: context,
                                builder:
                                    (_) => CustomFormDialog(
                                      title: 'Vehicle Information',
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
                    child: BlocBuilder<DashboardCubit, DashboardState>(
                      builder: (context, state) {
                        return VehicleTable(
                          title: "Vehicles Exited",
                          entries: state.exitedFiltered,
                          searchController: exitedSearchController,
                          hasSearchQuery:
                              exitedSearchController.text.isNotEmpty,
                          onCellTap: (details) {
                            if (details.rowColumnIndex.rowIndex > 0) {
                              showDialog(
                                context: context,
                                builder:
                                    (_) => CustomFormDialog(
                                      title: 'Vehicle Information',
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
