# Dashboard 2: Vehicle Search and Individual Report Navigation

## Overview

This document explains how vehicle search works in Dashboard 2 and how users navigate to individual vehicle reports.

## Search Flow

### 1. User Input

- User types in the search bar at the top of Dashboard 2
- Search queries can match: plate number, owner name, school ID, or vehicle model

### 2. Search Service Processing

```dart
// VehicleSearchService.getSuggestions() is called
Future<List<VehicleSearchSuggestion>> getSuggestions(String query) async
```

- Service queries Firestore through VehicleSearchRepository
- Results are mapped to VehicleSearchSuggestion objects
- Each suggestion contains: vehicleId, plateNumber, ownerName

### 3. Displaying Suggestions

- Search results appear as dropdown items
- Format: "Plate Number - Owner Name"
- User can click any suggestion to view details

## Navigation to Individual Report

### 1. User Selection

When user clicks a search suggestion:

```dart
onVehicleSelected: (VehicleSearchSuggestion suggestion) {
  context.read<DashboardCubit>().showIndividualReport(suggestion.vehicleId);
}
```

### 2. DashboardCubit Processing

```dart
Future<void> showIndividualReport(String vehicleId) async
```

- Shows loading state
- Creates VehicleSearchService instance
- Calls `getIndividualReport(vehicleId)` to fetch vehicle data

### 3. Data Retrieval

```dart
Future<IndividualVehicleReport?> getIndividualReport(String vehicleId) async
```

- Repository fetches vehicle document from Firestore
- Data is converted to IndividualVehicleReport using `fromFirestore()`
- Report includes: vehicle info, MVP progress, registration/expiry dates

### 4. State Update

- DashboardCubit updates state with:
  - `selectedVehicle`: The fetched IndividualVehicleReport
  - `viewMode`: Changed to `DashboardViewMode.individual`
  - `loading`: Set to false

## Individual Report Display

### 1. UI Components

The individual report shows:

- **Stats Cards**: Days until expiration, violations, entries/exits
- **Vehicle Info Card**: Complete vehicle details with MVP progress

### 2. MVP Progress Calculation

- Uses `RegistrationExpiryUtils.computeExpiryDate()` for expiry calculation
- MVP progress calculated based on registration date and expiry date
- Status: "Valid", "Expired", or "Not Started"

### 3. Date Formatting

- Registration and expiry dates formatted as "Jan. 12, 2025"
- Uses `VehicleInfoService.formatDate()` for consistent display

## Key Components

### VehicleSearchRepository

- Direct Firestore database operations
- Provides `searchVehicles()` for search queries
- Provides `getVehicleById()` for individual vehicle retrieval
- Handles raw Firestore document fetching

### VehicleSearchService

- Handles search queries and individual report retrieval
- Bridges UI components with Firestore repository
- Maps Firestore data to model objects

### DashboardCubit

- Manages navigation between global and individual views
- Maintains selected vehicle state
- Handles loading states during data fetch

### IndividualVehicleReport

- Data model for individual vehicle reports
- Contains MVP progress calculations
- Uses RegistrationExpiryUtils for date calculations

### VehicleInfoCard

- Displays detailed vehicle information
- Shows MVP progress bar with animation
- Formats dates using VehicleInfoService

## Error Handling

- If vehicle not found: Returns to global view
- Network errors: Shows loading state then handles gracefully
- Missing data: Displays "Not set" for empty fields

## Benefits

- **Fast Search**: Real-time suggestions as user types
- **Comprehensive Data**: Complete vehicle information in one view
- **MVP Tracking**: Clear visual progress of registration validity
- **Consistent UI**: Same styling and formatting across all components
