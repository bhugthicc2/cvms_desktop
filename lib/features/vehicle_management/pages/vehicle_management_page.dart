import 'dart:convert';
import 'dart:math';

import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/features/vehicle_management/models/vehicle_entry.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/vehicle_table.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/vehicle_cubit.dart';
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

    // Mock data dawg
    final random = Random();
    final firstNames = ["John", "Maria", "Paolo", "Angela"];
    final lastNames = ["Reyes", "Cruz", "Patangan", "Medija"];

    String randomName() =>
        "${firstNames[random.nextInt(firstNames.length)]} ${lastNames[random.nextInt(lastNames.length)]}";

    final allEntries = List.generate(
      100,
      (i) => VehicleEntry(
        name: randomName(),
        vehicle: i.isEven ? "Honda Beat" : "Yamaha Mio",
        schoolID: "KC-22-A-002${100 + i}",
        plateNumber: "ABC-${100 + i}",
        vehicleModel: "Mioi-${100 + i}",
        vehicleType: "Two-Wheeled",
        vehicleColor: "Red",
        status: "inside",
        violationStatus: "Resolved",
      ),
    );
    // Mock data dawg

    // Load entries into cubit
    context.read<VehicleCubit>().loadEntries(allEntries);

    // Listen to search controllers
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
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<VehicleCubit, VehicleState>(
          builder: (context, state) {
            return VehicleTable(
              onCellTap: (details) async {
                //todo
                final dataIndex = details.rowColumnIndex.rowIndex - 1;
                if (dataIndex < 0 ||
                    dataIndex >= state.filteredEntries.length) {
                  return;
                }
                final entry = state.filteredEntries[dataIndex];
                final controller = await DesktopMultiWindow.createWindow(
                  jsonEncode({
                    'type': 'viewEntry',
                    'data': {
                      'name': entry.name,
                      'vehicle': entry.vehicle,
                      'schoolID': entry.schoolID,
                      'plateNumber': entry.plateNumber,
                      'vehicleModel': entry.vehicleModel,
                      'vehicleType': entry.vehicleType,
                      'vehicleColor': entry.vehicleColor,
                      'status': entry.status,
                      'violationStatus': entry.violationStatus,
                    },
                  }),
                );
                controller
                  ..setFrame(const Offset(200, 200) & const Size(800, 500))
                  ..center()
                  ..setTitle('View Entry')
                  ..show();
              },
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
