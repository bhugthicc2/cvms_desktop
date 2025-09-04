import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/features/dashboard/models/vehicle_entry.dart';
import 'package:cvms_desktop/features/dashboard/widgets/dashboard_overview.dart';
import 'package:cvms_desktop/features/dashboard/widgets/vehicle_table.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // sample data brooooo
    final firstNames = [
      "John",
      "Jessa",
      "Vincent Jay",
      "Maria",
      "Paolo",
      "Venus",
      "Angela",
      "Carlo",
      "Ellah Mhay",
      "Marjorie",
      "Jesie",
    ];
    final lastNames = [
      "Abadilla",
      "Reyes",
      "Cruz",
      "Dela Cruz",
      "Belono-ac",
      "Patangan",
      "Salasayo",
      "Belonghilot",
      "Medija",
      "Gapol",
      "Lumacad",
    ];

    final random = Random();

    String randomName() {
      final first = firstNames[random.nextInt(firstNames.length)];
      final last = lastNames[random.nextInt(lastNames.length)];
      return "$first $last";
    }

    final entries = List.generate(
      100,
      (i) => VehicleEntry(
        name: randomName(),
        vehicle: "Honda Beat",
        plateNumber: "ABC-${100 + i}",
        duration: Duration(
          hours: 1 + random.nextInt(5),
          minutes: random.nextInt(60),
        ),
      ),
    );

    // end code sample data brooooo

    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const DashboardOverview(),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: VehicleTable(
                      title: 'Vehicles Entered',
                      entries: entries,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: VehicleTable(
                      title: 'Vehicles Exited',
                      entries: entries,
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
