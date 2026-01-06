import 'package:cvms_desktop/features/vehicle_logs_management/widgets/skeletons/table_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../bloc/vehicle_logs_cubit.dart';
import '../bloc/vehicle_logs_state.dart';
import '../models/vehicle_log_model.dart';
import '../widgets/tables/vehicle_logs_table.dart';
import '../widgets/dialogs/vehicle_logs_info_dialog.dart';

class VehicleLogsPage extends StatefulWidget {
  const VehicleLogsPage({super.key});

  @override
  State<VehicleLogsPage> createState() => _VehicleLogsPageState();
}

class _VehicleLogsPageState extends State<VehicleLogsPage> {
  final TextEditingController onsiteSearchController = TextEditingController();
  final TextEditingController offsiteSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    context.read<VehicleLogsCubit>().loadVehicleLogs();

    // Add search controller listener
    onsiteSearchController.addListener(() {
      context.read<VehicleLogsCubit>().filterEntries(
        onsiteSearchController.text,
      );
    });
  }

  @override
  void dispose() {
    onsiteSearchController.dispose();
    offsiteSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<VehicleLogsCubit, VehicleLogsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Skeletonizer(
                enabled: true,
                child: Row(children: [Expanded(child: buildSkeletonTable())]),
              );
            }

            return Row(
              children: [
                // Vehicles Onsite
                Expanded(
                  child: VehicleLogsTable(
                    title: "Vehicles Onsite",
                    logs: state.filteredEntries,
                    searchController: onsiteSearchController,
                    hasSearchQuery: onsiteSearchController.text.isNotEmpty,
                    onCellTap: (details) {
                      if (details.rowColumnIndex.rowIndex > 0) {
                        final log =
                            state.filteredEntries[details
                                    .rowColumnIndex
                                    .rowIndex -
                                1];
                        showDialog(
                          context: context,
                          builder: (_) => VehicleLogsInfoDialog(log: log),
                        );
                      }
                    },
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
