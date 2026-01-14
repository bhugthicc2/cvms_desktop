# CVMS Desktop Application - Dropdown Filter Functionality Tutorial

## Overview

This tutorial explains how the dropdown filter functionality works in the CVMS (Campus Vehicle Management System) desktop application. The system includes two main dropdown filters: **Vehicle Status Filter** and **Vehicle Type Filter**, both working alongside the search functionality to provide comprehensive data filtering.

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Dropdown Components](#dropdown-components)
3. [Step-by-Step Filter Flow](#step-by-step-filter-flow)
4. [Filter Implementation Details](#filter-implementation-details)
5. [Combined Filtering Logic](#combined-filtering-logic)
6. [State Management](#state-management)
7. [UI Integration](#ui-integration)
8. [Best Practices](#best-practices)

## Architecture Overview

The dropdown filter system follows this architecture:

```
UI Layer (CustomDropdown) → BLoC Layer (Cubit) → State Management → Filtering Logic
```

### Key Components:

- **CustomDropdown**: Reusable UI component for filter selection
- **VehicleCubit**: State management for filter logic
- **VehicleState**: Immutable state containing filter values
- **Filtering Logic**: Combined filtering with search and other filters

## Dropdown Components

### 1. CustomDropdown Widget (`lib/core/widgets/app/custom_dropdown.dart`)

```dart
class CustomDropdown extends StatefulWidget {
  final List<String> items;           // Filter options
  final String initialValue;          // Default selected value
  final ValueChanged<String> onChanged; // Callback when selection changes
  final double borderRadius;          // Visual styling
  final Color? backgroundColor;       // Background color
  final Color? color;                 // Text color
}
```

**Features:**

- Responsive design that adapts to container width
- Customizable styling (colors, border radius, padding)
- Built-in shadow effects for depth
- Font scaling based on container size
- Proper overflow handling with ellipsis

### 2. Filter Configuration

**Vehicle Status Filter:**

```dart
CustomDropdown(
  items: ['All', 'Inside', 'Outside'],
  initialValue: 'All',
  onChanged: (value) {
    context.read<VehicleCubit>().filterByStatus(value);
  },
)
```

**Vehicle Type Filter:**

```dart
CustomDropdown(
  items: ['All', 'two-wheeled', 'four-wheeled'],
  initialValue: 'All',
  onChanged: (value) {
    context.read<VehicleCubit>().filterByType(value);
  },
)
```

## Step-by-Step Filter Flow

### Step 1: User Interaction

1. User clicks on dropdown arrow
2. Dropdown menu opens showing available options
3. User selects a filter option (e.g., "Inside", "two-wheeled")
4. Dropdown closes and shows selected value

### Step 2: State Update

1. `CustomDropdown` triggers `onChanged` callback
2. Page calls cubit's filter method (`filterByStatus` or `filterByType`)
3. Cubit updates state with new filter value
4. Triggers `_applyFilters()` method

### Step 3: Filtering Logic

1. Cubit applies the new filter to current data
2. Combines with existing search query and other filters
3. Updates `filteredEntries` with results
4. Emits new state

### Step 4: UI Update

1. BlocBuilder rebuilds UI with new state
2. Table displays filtered results
3. Dropdown shows current selection
4. Pagination updates automatically

## Filter Implementation Details

### Vehicle Status Filter

**Location**: `lib/features/vehicle_management/widgets/tables/table_header.dart`

```dart
//VEHICLE STATUS FILTER
Expanded(
  child: CustomDropdown(
    items: ['All', 'Inside', 'Outside'],
    initialValue: 'All',
    onChanged: (value) {
      context.read<VehicleCubit>().filterByStatus(value);
    },
  ),
),
```

**Filter Logic in VehicleCubit:**

```dart
void filterByStatus(String status) {
  emit(state.copyWith(statusFilter: status));
  _applyFilters();
}
```

**Applied Filtering:**

```dart
if (state.statusFilter != 'All') {
  filtered = filtered
      .where((e) => e.status == state.statusFilter.toLowerCase())
      .toList();
}
```

### Vehicle Type Filter

**Location**: `lib/features/vehicle_management/widgets/tables/table_header.dart`

```dart
//VEHICLE TYPE FILTER
Expanded(
  child: CustomDropdown(
    items: ['All', 'two-wheeled', 'four-wheeled'],
    initialValue: 'All',
    onChanged: (value) {
      context.read<VehicleCubit>().filterByType(value);
    },
  ),
),
```

**Filter Logic in VehicleCubit:**

```dart
void filterByType(String type) {
  emit(state.copyWith(typeFilter: type));
  _applyFilters();
}
```

**Applied Filtering:**

```dart
if (state.typeFilter != 'All') {
  filtered = filtered
      .where((e) => e.vehicleType == state.typeFilter)
      .toList();
}
```

## Combined Filtering Logic

The `_applyFilters()` method in VehicleCubit combines all filters:

```dart
void _applyFilters() {
  var filtered = state.allEntries;

  // 1. Apply search filter first
  if (state.searchQuery.isNotEmpty) {
    final q = state.searchQuery.toLowerCase();
    filtered = filtered.where((e) {
      return e.ownerName.toLowerCase().contains(q) ||
             e.schoolID.toLowerCase().contains(q) ||
             e.plateNumber.toLowerCase().contains(q) ||
             e.vehicleType.toLowerCase().contains(q) ||
             e.vehicleModel.toLowerCase().contains(q) ||
             e.vehicleColor.toLowerCase().contains(q) ||
             e.licenseNumber.toLowerCase().contains(q) ||
             e.orNumber.toLowerCase().contains(q) ||
             e.crNumber.toLowerCase().contains(q) ||
             e.status.toLowerCase().contains(q);
    }).toList();
  }

  // 2. Apply status filter
  if (state.statusFilter != 'All') {
    filtered = filtered
        .where((e) => e.status == state.statusFilter.toLowerCase())
        .toList();
  }

  // 3. Apply type filter
  if (state.typeFilter != 'All') {
    filtered = filtered
        .where((e) => e.vehicleType == state.typeFilter)
        .toList();
  }

  emit(state.copyWith(filteredEntries: filtered));
}
```

### Filter Order and Logic:

1. **Search Filter**: Applied first, searches across all text fields
2. **Status Filter**: Applied second, filters by vehicle status (Inside/Outside)
3. **Type Filter**: Applied third, filters by vehicle type (two-wheeled/four-wheeled)

## State Management

### VehicleState Structure

```dart
class VehicleState {
  final List<VehicleEntry> allEntries;        // Original data
  final List<VehicleEntry> filteredEntries;  // Filtered results
  final String searchQuery;                   // Search term
  final String statusFilter;                  // Status filter value
  final String typeFilter;                    // Type filter value
  // ... other properties
}
```

### Filter State Updates

```dart
// Status filter update
VehicleState copyWith({
  String? statusFilter,
  // ... other parameters
}) {
  return VehicleState(
    statusFilter: statusFilter ?? this.statusFilter,
    // ... other assignments
  );
}

// Type filter update
VehicleState copyWith({
  String? typeFilter,
  // ... other parameters
}) {
  return VehicleState(
    typeFilter: typeFilter ?? this.typeFilter,
    // ... other assignments
  );
}
```

## UI Integration

### Table Header Layout

```dart
Row(
  children: [
    // Search Field
    if (searchController != null)
      SizedBox(
        width: _searchWidthFor(context),
        height: 40,
        child: SearchField(controller: searchController!),
      ),

    Spacing.horizontal(size: AppSpacing.medium),

    Expanded(
      child: Row(
        children: [
          // Vehicle Status Filter
          Expanded(
            child: CustomDropdown(
              items: ['All', 'Inside', 'Outside'],
              initialValue: 'All',
              onChanged: (value) {
                context.read<VehicleCubit>().filterByStatus(value);
              },
            ),
          ),

          Spacing.horizontal(size: AppSpacing.medium),

          // Vehicle Type Filter
          Expanded(
            child: CustomDropdown(
              items: ['All', 'two-wheeled', 'four-wheeled'],
              initialValue: 'All',
              onChanged: (value) {
                context.read<VehicleCubit>().filterByType(value);
              },
            ),
          ),

          // ... other buttons
        ],
      ),
    ),
  ],
)
```

### Responsive Design

The dropdowns use `Expanded` widgets to share available space equally:

```dart
Expanded(
  child: CustomDropdown(...), // Takes equal width
)
```

## Filter Behavior Examples

### Example 1: Status Filter Only

- **User Action**: Select "Inside" from status dropdown
- **Result**: Shows only vehicles with status "inside"
- **State**: `statusFilter = "Inside"`, `filteredEntries` contains only inside vehicles

### Example 2: Type Filter Only

- **User Action**: Select "two-wheeled" from type dropdown
- **Result**: Shows only two-wheeled vehicles
- **State**: `typeFilter = "two-wheeled"`, `filteredEntries` contains only two-wheeled vehicles

### Example 3: Combined Filters

- **User Action**: Search for "John" + Select "Inside" + Select "two-wheeled"
- **Result**: Shows only two-wheeled vehicles owned by "John" that are currently inside
- **State**: All three filters applied sequentially

### Example 4: Reset to All

- **User Action**: Select "All" from any dropdown
- **Result**: That filter is removed, other filters remain active
- **State**: Filter value set to "All", filtering logic skips that condition

## Best Practices

### 1. Filter Design

- **"All" Option**: Always include "All" as the first option to reset filters
- **Consistent Order**: Keep filter order consistent across the application
- **Clear Labels**: Use descriptive labels that match the data model

### 2. Performance Optimization

- **Efficient Filtering**: Apply filters in logical order (search first, then specific filters)
- **State Updates**: Only emit new state when filter values actually change
- **Memory Management**: Use `List.of()` to create new filtered lists

### 3. User Experience

- **Visual Feedback**: Show current filter state clearly
- **Responsive Design**: Dropdowns adapt to available space
- **Consistent Behavior**: All filters work the same way across features

### 4. Code Organization

- **Reusable Components**: CustomDropdown is used across multiple features
- **Centralized Logic**: All filtering logic is in the cubit
- **Separation of Concerns**: UI components only handle presentation

## Implementation Checklist

When implementing dropdown filters in a new feature:

- [ ] Create CustomDropdown widget with appropriate items
- [ ] Add filter fields to state class
- [ ] Implement filter methods in cubit (e.g., `filterByStatus`, `filterByType`)
- [ ] Add filter logic to `_applyFilters()` method
- [ ] Update state copyWith method to handle new filter fields
- [ ] Add dropdown widgets to table header
- [ ] Connect onChanged callbacks to cubit methods
- [ ] Test filter combinations (individual and combined)
- [ ] Verify "All" option resets filters correctly
- [ ] Check responsive behavior on different screen sizes

## Troubleshooting

### Common Issues:

1. **Filter not working**: Check if `onChanged` callback is properly connected to cubit method
2. **State not updating**: Verify `copyWith` method includes the new filter field
3. **Filters not combining**: Ensure `_applyFilters()` is called after each filter update
4. **"All" not resetting**: Check if filtering logic properly handles "All" value
5. **Case sensitivity**: Verify case handling in filter comparisons

### Debug Tips:

1. Add print statements in filter methods to see filter values
2. Check state values in BlocBuilder to verify filter state
3. Test individual filters first, then combinations
4. Verify dropdown items match the data model exactly
5. Check if filtering logic matches the expected data format

## Advanced Features

### Future Enhancements:

1. **Filter Persistence**: Save filter state across page refreshes
2. **Filter Indicators**: Show active filters with badges/chips
3. **Filter Reset**: Add "Clear All Filters" button
4. **Custom Filter Options**: Allow dynamic filter items based on data
5. **Filter Analytics**: Track most used filter combinations

This tutorial provides a comprehensive guide to understanding and implementing dropdown filter functionality in the CVMS desktop application. The pattern is consistent and can be easily extended to new features.
