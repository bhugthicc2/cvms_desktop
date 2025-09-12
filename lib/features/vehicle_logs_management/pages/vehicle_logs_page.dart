import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import '../bloc/vehicle_logs_cubit.dart';
import '../bloc/vehicle_logs_state.dart';
import '../widgets/tables/vehicle_logs_table.dart';
import '../widgets/dialogs/vehicle_logs_info_dialog.dart';

class VehicleLogsPage extends StatefulWidget {
  const VehicleLogsPage({super.key});

  @override
  State<VehicleLogsPage> createState() => _VehicleLogsPageState();
}

class _VehicleLogsPageState extends State<VehicleLogsPage> {
  final TextEditingController insideSearchController = TextEditingController();
  final TextEditingController outsideSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    context.read<VehicleLogsCubit>().loadVehicleLogs();
  }

  @override
  void dispose() {
    insideSearchController.dispose();
    outsideSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Vehicles Inside
            Expanded(
              child: BlocBuilder<VehicleLogsCubit, VehicleLogsState>(
                builder: (context, state) {
                  return VehicleLogsTable(
                    title: "Vehicles Inside",
                    logs: state.allLogs,
                    searchController: insideSearchController,
                    hasSearchQuery: insideSearchController.text.isNotEmpty,
                    onCellTap: (details) {
                      if (details.rowColumnIndex.rowIndex > 0) {
                        final log =
                            state.allLogs[details.rowColumnIndex.rowIndex - 1];
                        showDialog(
                          context: context,
                          builder: (_) => VehicleLogsInfoDialog(log: log),
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
    );
  }
}
