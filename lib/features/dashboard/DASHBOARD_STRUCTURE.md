# Dashboard Feature Structure

## Overview
The Dashboard feature provides a comprehensive overview of the Campus Vehicle Management System with statistics cards and dual tables showing vehicles entered and exited. It includes action menus for vehicle operations and various dialogs for vehicle management.

## Directory Structure
```
lib/features/dashboard/
├── bloc/
│   ├── dashboard_cubit.dart
│   └── dashboard_state.dart
├── data/
│   └── vehicle_data_source.dart
├── models/
│   └── vehicle_entry.dart
├── pages/
│   └── dashboard_page.dart
└── widgets/
    ├── actions/
    │   └── vehicle_actions_menu.dart
    ├── dialogs/
    │   ├── custom_delete_dialog.dart
    │   ├── custom_view_dialog.dart
    │   ├── reprort_vehicle_dialog.dart
    │   └── update_status_dialog.dart
    ├── sections/
    │   └── dashboard_overview.dart
    └── tables/
        ├── table_header.dart
        ├── vehicle_table.dart
        └── vehicle_table_columns.dart
```

## Architecture Pattern
- **BLoC Pattern**: Uses Cubit for state management
- **Clean Architecture**: Separation of concerns with data, models, and presentation layers
- **Widget Composition**: Modular UI components for reusability

## File Details and Code

### 1. BLoC Layer

#### `bloc/dashboard_cubit.dart`
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/vehicle_entry.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardState.initial());

  void loadEntries(List<VehicleEntry> entries) {
    emit(
      state.copyWith(
        allEntries: entries,
        enteredFiltered: entries.where((e) => e.status == "inside").toList(),
        exitedFiltered: entries.where((e) => e.status == "outside").toList(),
      ),
    );
  }

  void filterEntered(String query) {
    final filtered =
        state.allEntries
            .where(
              (e) =>
                  e.status == "inside" &&
                  (e.name.toLowerCase().contains(query.toLowerCase()) ||
                      e.vehicle.toLowerCase().contains(query.toLowerCase()) ||
                      e.plateNumber.toLowerCase().contains(
                        query.toLowerCase(),
                      )),
            )
            .toList();

    emit(state.copyWith(enteredFiltered: filtered));
  }

  void filterExited(String query) {
    final filtered =
        state.allEntries
            .where(
              (e) =>
                  e.status == "outside" &&
                  (e.name.toLowerCase().contains(query.toLowerCase()) ||
                      e.vehicle.toLowerCase().contains(query.toLowerCase()) ||
                      e.plateNumber.toLowerCase().contains(
                        query.toLowerCase(),
                      )),
            )
            .toList();

    emit(state.copyWith(exitedFiltered: filtered));
  }
}
```

#### `bloc/dashboard_state.dart`
```dart
part of 'dashboard_cubit.dart';

class DashboardState {
  final List<VehicleEntry> allEntries;
  final List<VehicleEntry> enteredFiltered;
  final List<VehicleEntry> exitedFiltered;

  DashboardState({
    required this.allEntries,
    required this.enteredFiltered,
    required this.exitedFiltered,
  });

  factory DashboardState.initial() =>
      DashboardState(allEntries: [], enteredFiltered: [], exitedFiltered: []);

  DashboardState copyWith({
    List<VehicleEntry>? allEntries,
    List<VehicleEntry>? enteredFiltered,
    List<VehicleEntry>? exitedFiltered,
  }) {
    return DashboardState(
      allEntries: allEntries ?? this.allEntries,
      enteredFiltered: enteredFiltered ?? this.enteredFiltered,
      exitedFiltered: exitedFiltered ?? this.exitedFiltered,
    );
  }
}
```

### 2. Models Layer

#### `models/vehicle_entry.dart`
```dart
class VehicleEntry {
  final String name;
  final String vehicle;
  final String plateNumber;
  final Duration duration;
  final String status;

  VehicleEntry({
    required this.status,
    required this.name,
    required this.vehicle,
    required this.plateNumber,
    required this.duration,
  });

  String get formattedDuration {
    return "${duration.inHours}h ${duration.inMinutes % 60}m";
    //TODO: auto calcualtion of time in and current time =  duration
  }

  int get durationInMinutes => duration.inMinutes;
}
```

### 3. Data Layer

#### `data/vehicle_data_source.dart`
```dart
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/features/dashboard/models/vehicle_entry.dart';
import 'package:cvms_desktop/features/dashboard/widgets/actions/vehicle_actions_menu.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class VehicleEntryDataSource extends DataGridSource {
  final List<VehicleEntry> _originalVehicleEntries;
  final Function(VehicleEntry, int)? onActionTap;
  final BuildContext? context;

  VehicleEntryDataSource({
    required List<VehicleEntry> vehicleEntries,
    this.onActionTap,
    this.context,
  }) : _originalVehicleEntries = vehicleEntries {
    _vehicleEntries =
        vehicleEntries
            .map<DataGridRow>(
              (e) => DataGridRow(
                cells: [
                  DataGridCell<int>(
                    columnName: 'index',
                    value: vehicleEntries.indexOf(e) + 1,
                  ),
                  DataGridCell<String>(columnName: 'name', value: e.name),
                  DataGridCell<String>(columnName: 'vehicle', value: e.vehicle),
                  DataGridCell<String>(
                    columnName: 'plateNumber',
                    value: e.plateNumber,
                  ),
                  DataGridCell<String>(
                    columnName: 'duration',
                    value: e.formattedDuration,
                  ),
                  DataGridCell<String>(columnName: 'actions', value: ''),
                ],
              ),
            )
            .toList();
  }

  List<DataGridRow> _vehicleEntries = [];

  @override
  List<DataGridRow> get rows => _vehicleEntries;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final int rowIndex = _vehicleEntries.indexOf(row);
    final bool isEven = rowIndex % 2 == 0;

    return DataGridRowAdapter(
      color:
          isEven
              ? AppColors.white
              : AppColors.dividerColor.withValues(alpha: 0.2),
      cells:
          row.getCells().map<Widget>((e) {
            if (e.columnName == 'actions') {
              return Container(
                alignment: Alignment.center,
                child:
                    context != null
                        ? VehicleActionsMenu(
                          vehicleEntry: _originalVehicleEntries[rowIndex],
                          rowIndex: rowIndex,
                          context: context!,
                        )
                        : InkWell(
                          onTap: () {
                            if (onActionTap != null) {
                              final vehicleEntry =
                                  _originalVehicleEntries[rowIndex];
                              onActionTap!(vehicleEntry, rowIndex);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.more_horiz,
                              size: 20,
                              color: AppColors.grey,
                            ),
                          ),
                        ),
              );
            }
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                e.value.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: AppFontSizes.small,
                  fontFamily: 'Sora',
                ),
              ),
            );
          }).toList(),
    );
  }
}
```

### 4. Pages Layer

#### `pages/dashboard_page.dart`
```dart
import 'dart:math';
import 'package:cvms_desktop/features/dashboard/widgets/dialogs/custom_view_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard_cubit.dart';
import 'package:cvms_desktop/features/dashboard/models/vehicle_entry.dart';
import 'package:cvms_desktop/features/dashboard/widgets/sections/dashboard_overview.dart';
import 'package:cvms_desktop/features/dashboard/widgets/tables/vehicle_table.dart';

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

    // Mock data generation
    final random = Random();
    final firstNames = ["John", "Maria", "Paolo", "Angela"];
    final lastNames = ["Reyes", "Cruz", "Patangan", "Medija"];

    String randomName() =>
        "${firstNames[random.nextInt(firstNames.length)]} ${lastNames[random.nextInt(lastNames.length)]}";

    final allEntries = List.generate(
      300,
      (i) => VehicleEntry(
        name: randomName(),
        vehicle: i.isEven ? "Honda Beat" : "Yamaha Mio",
        plateNumber: "ABC-${100 + i}",
        duration: Duration(
          hours: 1 + random.nextInt(5),
          minutes: random.nextInt(60),
        ),
        status: i.isEven ? "inside" : "outside",
      ),
    );

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
                                    (_) => CustomViewDialog(
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
                                    (_) => CustomViewDialog(
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
```

## Key Features

### 1. **Dashboard Overview Statistics**
- Entered Vehicles count with blue-violet gradient
- Exited Vehicles count with light blue gradient  
- Total Violations count with yellow-orange gradient
- Total Vehicles count with purple-blue gradient

### 2. **Dual Table Display**
- **Vehicles Entered**: Shows vehicles currently inside
- **Vehicles Exited**: Shows vehicles that have left
- Side-by-side layout with independent search

### 3. **Vehicle Actions Menu**
- Edit Details with primary color
- Update Status with success color
- Report Vehicle with error color
- Delete Vehicle with error color

### 4. **Interactive Dialogs**
- **Custom View Dialog**: Comprehensive vehicle information form
- **Update Status Dialog**: Change vehicle status (inside/outside)
- **Report Vehicle Dialog**: Report violations with dropdown
- **Delete Dialog**: Confirmation for vehicle deletion

### 5. **Real-time Search**
- Independent search for each table
- Searches across name, vehicle type, and plate number
- Instant filtering as user types

## Dependencies
- `flutter_bloc`: State management
- `syncfusion_flutter_datagrid`: Data table functionality
- `phosphor_flutter`: Icons
- Custom core widgets and themes

## Usage
The Dashboard feature serves as the main landing page providing overview statistics and quick access to vehicle management operations.
