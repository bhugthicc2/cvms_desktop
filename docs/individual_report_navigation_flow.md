# Individual Report Navigation Flow from Search Results

## Overview

This document provides a complete and detailed explanation of how the individual report navigation works when a user selects a vehicle from the search results in the dashboard.

## Navigation Flow Architecture

### 1. User Interaction Layer

**Location**: `lib/features/dashboard2/pages/core/dasboard_page.dart` (Lines 142-149)

```dart
onVehicleSelected: (
  VehicleSearchSuggestion suggestion,
) {
  context
      .read<DashboardCubit>()
      .showIndividualReport(suggestion.vehicleId);//navigate to individual report and display its dedicated report
},
```

**Process**:

- User selects a vehicle from the search suggestions dropdown
- The `VehicleSearchSuggestion` object contains the `vehicleId` field
- The `onVehicleSelected` callback is triggered with the selected suggestion
- The suggestion's `vehicleId` is passed to the DashboardCubit's `showIndividualReport` method

### 2. State Management Layer

**Location**: `lib/features/dashboard2/bloc/dashboard_cubit.dart` (Lines 262-283)

```dart
Future<void> showIndividualReport(String vehicleId) async {
  emit(state.copyWith(loading: true));

  final service = VehicleSearchService(
    VehicleSearchRepository(FirebaseFirestore.instance),
  );

  final report = await service.getIndividualReport(vehicleId);

  if (report == null) {
    emit(state.copyWith(loading: false));
    return;
  }

  emit(
    state.copyWith(
      selectedVehicle: report,
      viewMode: DashboardViewMode.individual,
      loading: false,
    ),
  );
}
```

**Process**:

1. **Loading State**: Sets loading to true to show UI loading indicator
2. **Service Creation**: Creates a `VehicleSearchService` with a `VehicleSearchRepository` instance
3. **Data Fetching**: Calls `getIndividualReport(vehicleId)` to retrieve vehicle data
4. **Error Handling**: If report is null, stops loading and returns (vehicle not found)
5. **State Update**: Updates the dashboard state with:
   - `selectedVehicle`: The retrieved individual vehicle report
   - `viewMode`: Changes to `DashboardViewMode.individual`
   - `loading`: Sets to false to hide loading indicator

### 3. Service Layer

**Location**: `lib/features/dashboard2/services/vehicle_search_service.dart` (Lines 21-26)

```dart
Future<IndividualVehicleReport?> getIndividualReport(String vehicleId) async {
  final data = await repository.getVehicleById(vehicleId);
  if (data == null) return null;

  return IndividualVehicleReport.fromFirestore(data);
}
```

**Process**:

1. **Repository Call**: Delegates to the repository to fetch raw vehicle data
2. **Null Check**: Returns null if vehicle data is not found
3. **Data Transformation**: Converts the raw Firestore data into an `IndividualVehicleReport` object using the `fromFirestore` factory method

### 4. Data Access Layer

**Location**: `lib/features/dashboard2/repositories/vehicle_search_repository.dart` (Lines 51-56)

```dart
Future<Map<String, dynamic>?> getVehicleById(String vehicleId) async {
  final doc = await _db.collection('vehicles').doc(vehicleId).get();

  if (!doc.exists) return null;
  return doc.data();
}
```

**Process**:

1. **Firestore Query**: Accesses the 'vehicles' collection and fetches the document with the specified `vehicleId`
2. **Existence Check**: Verifies if the document exists
3. **Data Return**: Returns the raw document data as `Map<String, dynamic>` or null if not found

## Data Flow Diagram

```
User Selection
     ↓
VehicleSearchSuggestion (with vehicleId)
     ↓
DashboardCubit.showIndividualReport(vehicleId)
     ↓
VehicleSearchService.getIndividualReport(vehicleId)
     ↓
VehicleSearchRepository.getVehicleById(vehicleId)
     ↓
Firestore Database Query
     ↓
Raw Vehicle Data (Map<String, dynamic>)
     ↓
IndividualVehicleReport.fromFirestore(data)
     ↓
IndividualVehicleReport Object
     ↓
Dashboard State Update (selectedVehicle, viewMode.individual)
     ↓
UI Navigation to Individual Report View
```

## Key Components

### VehicleSearchSuggestion Model

Contains essential vehicle information for search display:

- `vehicleId`: Unique identifier for the vehicle
- `plateNumber`: Vehicle's plate number
- `ownerName`: Name of the vehicle owner
- `schoolId`: School identification

### IndividualVehicleReport Model

Represents the complete vehicle report data structure, created from Firestore data using the `fromFirestore` factory method.

### DashboardViewMode Enum

Controls the current view mode of the dashboard:

- `DashboardViewMode.individual`: Shows individual vehicle report
- Other modes for different dashboard views

## Error Handling

1. **Vehicle Not Found**: If `getVehicleById` returns null, the service returns null, and the cubit stops loading without updating the state
2. **Network Issues**: Handled by Firestore SDK with automatic retries
3. **Invalid Data**: The `fromFirestore` method handles data validation and transformation

## UI Impact

When the state is updated with `viewMode: DashboardViewMode.individual`:

- The dashboard UI switches from the grid/list view to the individual report view
- The selected vehicle's detailed information is displayed
- Navigation controls are updated to allow returning to the previous view
- Loading indicators are shown/hidden based on the loading state

## Performance Considerations

1. **Lazy Loading**: Vehicle data is only fetched when explicitly requested
2. **Single Document Query**: Efficient Firestore query targeting a specific document by ID
3. **State Management**: Proper loading states prevent UI flickering
4. **Error Boundaries**: Graceful handling of missing vehicles

## Future Enhancements

1. **Caching**: Implement local caching for frequently accessed vehicle reports
2. **Preloading**: Fetch related vehicle data in parallel
3. **Offline Support**: Cache reports for offline viewing
4. **Real-time Updates**: Subscribe to vehicle document changes for live updates
