# CVMS Desktop Application - Bulk Mode Toggle Functionality Tutorial

## Overview

This tutorial explains how the bulk mode toggle functionality works in the CVMS (Campus Vehicle Management System) desktop application. Bulk mode allows users to select multiple entries from tables and perform batch operations on them, such as exporting, updating status, reporting violations, or deleting multiple items at once.

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Bulk Mode Components](#bulk-mode-components)
3. [Step-by-Step Bulk Mode Flow](#step-by-step-bulk-mode-flow)
4. [State Management](#state-management)
5. [UI Components](#ui-components)
6. [Selection Logic](#selection-logic)
7. [Bulk Operations](#bulk-operations)
8. [Implementation Examples](#implementation-examples)
9. [Best Practices](#best-practices)

## Architecture Overview

The bulk mode system follows this architecture:

```
UI Layer (Toggle Button) → BLoC Layer (Cubit) → State Management → Selection Logic → Bulk Operations
```

### Key Components:

- **Toggle Button**: UI component to enable/disable bulk mode
- **Cubit**: State management for bulk mode and selections
- **State**: Immutable state containing bulk mode status and selected entries
- **Checkboxes**: Individual and select-all checkboxes for entry selection
- **Toggle Actions**: Action buttons for bulk operations

## Bulk Mode Components

### 1. Toggle Button (`lib/features/vehicle_management/widgets/tables/table_header.dart`)

```dart
//TOGGLE BULK MODE BUTTON
Expanded(
  child: CustomVehicleButton(
    icon: PhosphorIconsBold.package,
    textColor: state.isBulkModeEnabled ? AppColors.white : AppColors.black,
    label: state.isBulkModeEnabled ? "Exit Bulk" : "Bulk Mode",
    backgroundColor: state.isBulkModeEnabled ? AppColors.warning : AppColors.white,
    onPressed: () {
      context.read<VehicleCubit>().toggleBulkMode();
    },
  ),
),
```

**Features:**

- Dynamic text: "Bulk Mode" / "Exit Bulk"
- Dynamic colors: White background / Warning background
- Toggles bulk mode state when pressed

### 2. Toggle Actions (`lib/features/vehicle_management/widgets/actions/toggle_actions.dart`)

```dart
class ToggleActions extends StatelessWidget {
  final String exportValue;
  final String reportValue;
  final String updateValue;
  final String deleteValue;
  final VoidCallback onExport;
  final VoidCallback onUpdate;
  final VoidCallback onReport;
  final VoidCallback onDelete;
}
```

**Available Actions:**

- **Export QR Codes**: Export selected entries as QR codes
- **Update Status**: Bulk update status of selected entries
- **Report Selected**: Report violations for selected entries
- **Delete Selected**: Delete selected entries

### 3. Custom Toggle Buttons (`lib/features/vehicle_management/widgets/buttons/custom_toggle_buttons.dart`)

```dart
class CustomToggleButtons extends StatelessWidget {
  final String title;
  final String value;  // Shows count of selected items
  final VoidCallback onTap;
  final Color? color;
}
```

**Features:**

- Shows action title and count: "Export QR Codes (5)"
- Color-coded by action type
- Disabled when no items selected

## Step-by-Step Bulk Mode Flow

### Step 1: Enable Bulk Mode

1. User clicks "Bulk Mode" button in table header
2. `toggleBulkMode()` method called in cubit
3. State updated with `isBulkModeEnabled: true`
4. UI rebuilds to show checkboxes and toggle actions

### Step 2: Select Entries

1. Checkboxes appear in first column of table
2. User can select individual entries using row checkboxes
3. User can select all entries using header checkbox
4. Selection state managed in `selectedEntries` list

### Step 3: Perform Bulk Operations

1. Toggle actions appear below table header
2. User clicks desired action button
3. Bulk operation performed on selected entries
4. Success/error feedback shown to user

### Step 4: Exit Bulk Mode

1. User clicks "Exit Bulk" button
2. Bulk mode disabled, selections cleared
3. UI returns to normal view

## State Management

### State Structure

```dart
class VehicleState {
  final List<VehicleEntry> allEntries;        // Original data
  final List<VehicleEntry> filteredEntries;  // Filtered data
  final List<VehicleEntry> selectedEntries;  // Selected for bulk operations
  final bool isBulkModeEnabled;              // Bulk mode status
  // ... other properties
}
```

### State Updates

```dart
// Toggle bulk mode
void toggleBulkMode() {
  final newBulkMode = !state.isBulkModeEnabled;
  emit(state.copyWith(
    isBulkModeEnabled: newBulkMode,
    selectedEntries: newBulkMode ? [] : state.selectedEntries, // Clear selections when enabling
  ));
}

// Select individual entry
void selectEntry(VehicleEntry entry) {
  if (!state.isBulkModeEnabled) return; // Only work in bulk mode

  final currentSelected = List<VehicleEntry>.from(state.selectedEntries);
  if (currentSelected.contains(entry)) {
    currentSelected.remove(entry); // Deselect if already selected
  } else {
    currentSelected.add(entry); // Select if not selected
  }

  emit(state.copyWith(selectedEntries: currentSelected));
}

// Select all entries
void selectAllEntries() {
  if (!state.isBulkModeEnabled) return;

  final allFiltered = state.filteredEntries;
  final currentSelected = List<VehicleEntry>.from(state.selectedEntries);

  final allSelected = allFiltered.every(
    (entry) => currentSelected.contains(entry),
  );

  if (allSelected) {
    // Deselect all if all are selected
    currentSelected.removeWhere((entry) => allFiltered.contains(entry));
  } else {
    // Select all if not all are selected
    for (final entry in allFiltered) {
      if (!currentSelected.contains(entry)) {
        currentSelected.add(entry);
      }
    }
  }

  emit(state.copyWith(selectedEntries: currentSelected));
}
```

## UI Components

### 1. Conditional Checkbox Column

```dart
// In VehicleTableColumns
static List<GridColumn> getColumns({bool showCheckbox = false}) {
  final columns = <GridColumn>[];

  if (showCheckbox) {
    columns.add(
      GridColumn(
        columnName: 'checkbox',
        width: 50,
        label: Container(
          alignment: Alignment.center,
          child: BlocBuilder<VehicleCubit, VehicleState>(
            builder: (context, state) {
              final allFiltered = state.filteredEntries;
              final allSelected = allFiltered.isNotEmpty &&
                  allFiltered.every(
                    (entry) => state.selectedEntries.contains(entry),
                  );

              return CustomCheckbox(
                value: allSelected,
                onChanged: (value) {
                  context.read<VehicleCubit>().selectAllEntries();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // ... other columns
}
```

### 2. Individual Row Checkboxes

```dart
// In VehicleDataSource
Widget _buildCellWidget(DataGridCell cell, VehicleEntry entry) {
  switch (cell.columnName) {
    case 'checkbox':
      return BlocBuilder<VehicleCubit, VehicleState>(
        builder: (context, state) {
          final isSelected = state.selectedEntries.contains(entry);
          return Container(
            alignment: Alignment.center,
            child: CustomCheckbox(
              value: isSelected,
              onChanged: (value) {
                context.read<VehicleCubit>().selectEntry(entry);
              },
            ),
          );
        },
      );
    // ... other cases
  }
}
```

### 3. Conditional Toggle Actions

```dart
// In VehicleTable
if (state.isBulkModeEnabled) ...[
  Spacing.vertical(size: AppFontSizes.medium),
  ToggleActions(
    exportValue: state.selectedEntries.length.toString(),
    reportValue: state.selectedEntries.length.toString(),
    deleteValue: state.selectedEntries.length.toString(),
    updateValue: state.selectedEntries.length.toString(),
    onExport: () {
      context.read<VehicleCubit>().bulkExportAsPng();
    },
    onUpdate: () {
      // Show update status dialog
    },
    onReport: () {
      // Show report violations dialog
    },
    onDelete: () {
      // Show delete confirmation dialog
    },
  ),
],
```

## Selection Logic

### Individual Selection

- **Toggle Behavior**: Click to select, click again to deselect
- **State Check**: Only works when bulk mode is enabled
- **Visual Feedback**: Checkbox shows selected state
- **List Management**: Adds/removes entries from `selectedEntries` list

### Select All Logic

- **Smart Toggle**: Selects all if none/some selected, deselects all if all selected
- **Filtered Scope**: Only selects entries currently visible (respects search/filters)
- **Header Checkbox**: Shows checked state when all visible entries are selected
- **Partial Selection**: Header checkbox shows indeterminate state when some entries selected

### Selection Persistence

- **Mode Switching**: Selections cleared when exiting bulk mode
- **Filter Changes**: Selections persist when applying filters
- **Search Changes**: Selections persist when searching

## Bulk Operations

### 1. Bulk Export (`bulkExportAsPng`)

```dart
Future<void> bulkExportAsPng() async {
  if (state.selectedEntries.isEmpty) return;

  try {
    emit(state.copyWith(isExporting: true, error: null));

    // Ask user to select directory
    final String? directoryPath = await getDirectoryPath();
    if (directoryPath == null) return;

    // Export each selected vehicle
    for (final entry in state.selectedEntries) {
      final pngBytes = await VehicleCardRenderer.renderCardToPng(
        plateNumber: entry.plateNumber,
        qrData: CryptoService.withDefaultKey().encryptVehicleId(entry.vehicleID),
      );

      final filePath = path.join(directoryPath, 'vehicle_pass_${entry.ownerName}.png');
      await File(filePath).writeAsBytes(pngBytes);
    }

    emit(state.copyWith(isExporting: false, exportedFilePath: directoryPath));
  } catch (e) {
    emit(state.copyWith(isExporting: false, error: e.toString()));
  }
}
```

### 2. Bulk Update Status (`bulkUpdateStatus`)

```dart
Future<void> bulkUpdateStatus(String status) async {
  if (state.selectedEntries.isEmpty) return;

  try {
    final vehicleIds = state.selectedEntries.map((entry) => entry.vehicleID).toList();
    await repository.bulkUpdateStatus(vehicleIds, status);

    emit(state.copyWith(selectedEntries: [])); // Clear selections
    await loadVehicles(); // Reload data
  } catch (e) {
    rethrow;
  }
}
```

### 3. Bulk Delete (`bulkDeleteVehicles`)

```dart
Future<void> bulkDeleteVehicles() async {
  if (state.selectedEntries.isEmpty) return;

  try {
    final vehicleIds = state.selectedEntries.map((entry) => entry.vehicleID).toList();
    await repository.bulkDeleteVehicles(vehicleIds);

    emit(state.copyWith(selectedEntries: [])); // Clear selections
    await loadVehicles(); // Reload data
  } catch (e) {
    rethrow;
  }
}
```

### 4. Bulk Report Violations (`bulkReportViolations`)

```dart
Future<void> bulkReportViolations({
  required String violationType,
  String? reason,
}) async {
  if (state.selectedEntries.isEmpty) return;

  try {
    final violations = state.selectedEntries.map((vehicle) {
      return ViolationEntry(
        violationID: "",
        dateTime: Timestamp.now(),
        reportedBy: reporterName,
        plateNumber: vehicle.plateNumber,
        vehicleID: vehicle.vehicleID,
        owner: vehicle.ownerName,
        violation: violationType,
        status: "pending",
      );
    }).toList();

    await violationRepository.bulkReportViolations(violations);
    emit(state.copyWith(selectedEntries: [])); // Clear selections
  } catch (e) {
    rethrow;
  }
}
```

## Implementation Examples

### Vehicle Management Bulk Mode

**Toggle Button:**

```dart
CustomVehicleButton(
  icon: PhosphorIconsBold.package,
  textColor: state.isBulkModeEnabled ? AppColors.white : AppColors.black,
  label: state.isBulkModeEnabled ? "Exit Bulk" : "Bulk Mode",
  backgroundColor: state.isBulkModeEnabled ? AppColors.warning : AppColors.white,
  onPressed: () => context.read<VehicleCubit>().toggleBulkMode(),
)
```

**Toggle Actions:**

```dart
ToggleActions(
  exportValue: state.selectedEntries.length.toString(),
  reportValue: state.selectedEntries.length.toString(),
  deleteValue: state.selectedEntries.length.toString(),
  updateValue: state.selectedEntries.length.toString(),
  onExport: () => context.read<VehicleCubit>().bulkExportAsPng(),
  onUpdate: () => _showUpdateStatusDialog(),
  onReport: () => _showReportDialog(),
  onDelete: () => _showDeleteDialog(),
)
```

### Vehicle Logs Bulk Mode

**Toggle Button:**

```dart
CustomVehicleLogsButton(
  textColor: state.isBulkModeEnabled ? AppColors.white : AppColors.black,
  label: state.isBulkModeEnabled ? "Exit Bulk Mode" : "Bulk Mode",
  backgroundColor: state.isBulkModeEnabled ? AppColors.warning : AppColors.white,
  onPressed: () => context.read<VehicleLogsCubit>().toggleBulkMode(),
)
```

**Note**: Vehicle logs bulk mode is partially implemented with TODO placeholders for bulk operations.

## Best Practices

### 1. State Management

- **Clear Selections**: Always clear selections after bulk operations
- **Validation**: Check if bulk mode is enabled before selection operations
- **Immutability**: Use `List.of()` to create new selection lists
- **Error Handling**: Properly handle errors in bulk operations

### 2. User Experience

- **Visual Feedback**: Clear indication of bulk mode state
- **Selection Count**: Show number of selected items in action buttons
- **Confirmation Dialogs**: Ask for confirmation before destructive operations
- **Progress Indicators**: Show progress for long-running operations

### 3. Performance

- **Efficient Selection**: Use `contains()` for selection checks
- **Batch Operations**: Perform operations in batches for large datasets
- **Memory Management**: Clear selections when not needed
- **Async Operations**: Handle async bulk operations properly

### 4. Code Organization

- **Reusable Components**: Create reusable bulk action components
- **Consistent Patterns**: Use same pattern across all features
- **Separation of Concerns**: Keep UI, business logic, and data layers separate
- **Error Boundaries**: Proper error handling and user feedback

## Implementation Checklist

When implementing bulk mode in a new feature:

- [ ] Add `isBulkModeEnabled` and `selectedEntries` to state
- [ ] Implement `toggleBulkMode()` method in cubit
- [ ] Implement `selectEntry()` and `selectAllEntries()` methods
- [ ] Add conditional checkbox column to table
- [ ] Add individual row checkboxes to data source
- [ ] Add toggle button to table header
- [ ] Add conditional toggle actions widget
- [ ] Implement bulk operation methods
- [ ] Add confirmation dialogs for destructive operations
- [ ] Test selection/deselection behavior
- [ ] Test bulk operations with various selection counts
- [ ] Verify error handling and user feedback

## Troubleshooting

### Common Issues:

1. **Checkboxes not appearing**: Check if `showCheckbox` parameter is passed correctly
2. **Selections not working**: Verify bulk mode is enabled before selection
3. **State not updating**: Check if `copyWith` method includes selection fields
4. **Bulk operations failing**: Verify selected entries are not empty
5. **UI not rebuilding**: Ensure BlocBuilder is properly wrapping components

### Debug Tips:

1. Add print statements in selection methods to track state changes
2. Check state values in BlocBuilder to verify selection state
3. Test with small datasets first
4. Verify bulk operation parameters are correct
5. Check error messages in console for failed operations

## Advanced Features

### Future Enhancements:

1. **Selection Persistence**: Save selections across page refreshes
2. **Partial Selection Indicators**: Show indeterminate state for partial selections
3. **Selection Filters**: Filter selections by criteria
4. **Bulk Import**: Import multiple items at once
5. **Selection Analytics**: Track most used bulk operations

This tutorial provides a comprehensive guide to understanding and implementing bulk mode functionality in the CVMS desktop application. The pattern is consistent across features and can be easily extended to new functionality.
