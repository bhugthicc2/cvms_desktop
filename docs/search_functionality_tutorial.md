# CVMS Desktop Application - Search Functionality Tutorial

## Overview

This tutorial explains how the search functionality works across different features in the CVMS (Campus Vehicle Management System) desktop application. The search system is implemented using Flutter BLoC pattern with real-time filtering capabilities.

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Search Components](#search-components)
3. [Step-by-Step Search Flow](#step-by-step-search-flow)
4. [Feature-Specific Implementations](#feature-specific-implementations)
5. [Search Field Configuration](#search-field-configuration)
6. [Filtering Logic](#filtering-logic)
7. [Empty State Handling](#empty-state-handling)
8. [Best Practices](#best-practices)

## Architecture Overview

The search functionality follows a consistent pattern across all features:

```
UI Layer (SearchField) → BLoC Layer (Cubit) → State Management → Data Layer
```

### Key Components:

- **SearchField**: Reusable UI component for input
- **Cubit**: State management for search logic
- **State**: Immutable state containing search query and filtered results
- **DataSource**: Handles data filtering and display

## Search Components

### 1. SearchField Widget (`lib/core/widgets/app/search_field.dart`)

```dart
class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const SearchField({
    super.key,
    required this.controller,
    this.onChanged,
  });
}
```

**Features:**

- Rounded border design with primary color focus
- Placeholder text: "Search name, plate number, etc..."
- Customizable controller and onChange callback
- Responsive design with proper styling

### 2. State Management Pattern

Each feature follows this state structure:

```dart
class FeatureState {
  final List<Entry> allEntries;        // Original data
  final List<Entry> filteredEntries;  // Search results
  final String searchQuery;            // Current search term
  // ... other filters
}
```

## Step-by-Step Search Flow

### Step 1: User Input

1. User types in the SearchField component
2. TextEditingController captures the input
3. Controller triggers onChange listener

### Step 2: State Update

1. Page component listens to controller changes
2. Calls cubit's `filterEntries(query)` method
3. Cubit updates state with new search query
4. Triggers `_applyFilters()` method

### Step 3: Filtering Logic

1. Cubit applies search query to `allEntries`
2. Filters based on multiple fields (case-insensitive)
3. Updates `filteredEntries` with results
4. Emits new state

### Step 4: UI Update

1. BlocBuilder rebuilds UI with new state
2. Table displays `filteredEntries`
3. Pagination updates automatically
4. Empty state shown if no results

### Step 5: Search Clearing

1. User clicks "Clear Search" button (when no results)
2. Triggers `onSearchCleared` callback
3. Controller text is cleared
4. All entries are restored

## Feature-Specific Implementations

### Vehicle Management Search

**Location**: `lib/features/vehicle_management/`

**Searchable Fields**:

- Owner Name
- School ID
- Plate Number
- Vehicle Type
- Vehicle Model
- Vehicle Color
- License Number
- OR Number
- CR Number
- Status

**Implementation**:

```dart
// In VehicleManagementPage
vehicleController.addListener(() {
  context.read<VehicleCubit>().filterEntries(vehicleController.text);
});

// In VehicleCubit
void filterEntries(String query) {
  emit(state.copyWith(searchQuery: query));
  _applyFilters();
}

void _applyFilters() {
  var filtered = state.allEntries;

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

  emit(state.copyWith(filteredEntries: filtered));
}
```

### User Management Search

**Location**: `lib/features/user_management/`

**Searchable Fields**:

- Full Name
- Email
- Role
- Status
- Last Login Date

**Implementation**:

```dart
// In UserCubit
void _applyFilters() {
  var filtered = state.allEntries;
  if (state.searchQuery.isNotEmpty) {
    final q = state.searchQuery.toLowerCase();
    filtered = filtered.where((e) {
      final lastLoginStr = DateFormat('MMM dd, yyyy').format(e.lastLogin).toLowerCase();
      return e.fullname.toLowerCase().contains(q) ||
             e.email.toLowerCase().contains(q) ||
             e.role.toLowerCase().contains(q) ||
             e.status.toLowerCase().contains(q) ||
             lastLoginStr.contains(q);
    }).toList();
  }

  emit(state.copyWith(filteredEntries: filtered));
}
```

### Vehicle Logs Search

**Location**: `lib/features/vehicle_logs_management/`

**Note**: Vehicle logs search is implemented differently - it uses a simpler approach without complex filtering logic in the cubit.

## Search Field Configuration

### Responsive Width

The search field adapts to screen size:

```dart
// In TableHeader
double _searchWidthFor(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 1280) {
    return 300;
  } else if (screenWidth < 1464) {
    return 400;
  }

  return 560;
}
```

### Integration with Table Header

```dart
// In TableHeader widget
if (searchController != null)
  SizedBox(
    width: _searchWidthFor(context),
    height: 40,
    child: SearchField(controller: searchController!),
  ),
```

## Filtering Logic

### Multi-Field Search

The search performs case-insensitive matching across multiple fields:

1. **Convert query to lowercase**: `final q = state.searchQuery.toLowerCase()`
2. **Check each field**: Uses `contains()` method for partial matching
3. **Combine results**: Uses `where()` to filter the list
4. **Update state**: Emits new filtered results

### Combined Filters

Search works alongside other filters:

```dart
void _applyFilters() {
  var filtered = state.allEntries;

  // Apply search filter
  if (state.searchQuery.isNotEmpty) {
    // ... search logic
  }

  // Apply status filter
  if (state.statusFilter != 'All') {
    filtered = filtered.where((e) => e.status == state.statusFilter.toLowerCase()).toList();
  }

  // Apply type filter
  if (state.typeFilter != 'All') {
    filtered = filtered.where((e) => e.vehicleType == state.typeFilter).toList();
  }

  emit(state.copyWith(filteredEntries: filtered));
}
```

## Empty State Handling

### No Search Results

When search returns no results:

```dart
// In CustomTable
EmptyState(
  type: widget.hasSearchQuery ? EmptyStateType.noSearchResults : EmptyStateType.noData,
  actionText: widget.hasSearchQuery && widget.onSearchCleared != null ? 'Clear Search' : null,
  onActionPressed: widget.hasSearchQuery ? widget.onSearchCleared : null,
)
```

### Clear Search Functionality

```dart
// In VehicleTable
onSearchCleared: () {
  searchController.clear();
},
```

## Best Practices

### 1. Performance Optimization

- **Debouncing**: Consider adding debouncing for large datasets
- **Case-insensitive**: Always convert to lowercase for comparison
- **Partial matching**: Use `contains()` for flexible search

### 2. User Experience

- **Clear feedback**: Show "Clear Search" button when no results
- **Responsive design**: Adapt search field width to screen size
- **Consistent behavior**: Same search pattern across all features

### 3. Code Organization

- **Reusable components**: SearchField is used across features
- **Consistent state**: Same state structure pattern
- **Separation of concerns**: UI, business logic, and data layers separated

### 4. Error Handling

- **Null safety**: Check for null values in search fields
- **Empty states**: Handle cases with no data gracefully
- **State management**: Proper cleanup of controllers and subscriptions

## Implementation Checklist

When implementing search in a new feature:

- [ ] Create TextEditingController in page component
- [ ] Add controller listener in initState()
- [ ] Implement filterEntries() method in cubit
- [ ] Add \_applyFilters() method with search logic
- [ ] Update state with searchQuery and filteredEntries
- [ ] Add SearchField to table header
- [ ] Implement onSearchCleared callback
- [ ] Test with various search terms
- [ ] Verify empty state handling
- [ ] Check responsive behavior

## Troubleshooting

### Common Issues:

1. **Search not working**: Check if controller listener is properly set up
2. **Case sensitivity**: Ensure both query and data are converted to lowercase
3. **Empty results**: Verify search fields exist in the data model
4. **Performance**: Consider debouncing for large datasets
5. **State not updating**: Check if BlocBuilder is properly wrapping the UI

### Debug Tips:

1. Add print statements in \_applyFilters() to see filtering process
2. Check state values in BlocBuilder
3. Verify controller text changes are being captured
4. Test with simple search terms first

This tutorial provides a comprehensive guide to understanding and implementing search functionality in the CVMS desktop application. The pattern is consistent across features, making it easy to maintain and extend.
