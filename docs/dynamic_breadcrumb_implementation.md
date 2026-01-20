# Dynamic Breadcrumb Implementation

## Overview

This document describes the implementation of dynamic breadcrumbs in the CVMS dashboard that display the selected vehicle owner's name instead of static text, with proper hierarchy for both individual and global PDF previews.

## Problem

The breadcrumb for individual reports previously showed a static "Individual Report" label, which didn't provide context about which vehicle was being viewed. Additionally, PDF preview breadcrumbs didn't differentiate between global and individual reports, causing navigation confusion.

## Solution

### Modified `_buildBreadcrumbs` Method

**Location**: `lib/features/dashboard2/pages/core/dashboard_page.dart`

**Before:**

```dart
List<BreadcrumbItem> _buildBreadcrumbs(DashboardViewMode viewMode) {
  switch (viewMode) {
    case DashboardViewMode.global:
      return []; // Root level - no breadcrumbs
    case DashboardViewMode.individual:
      return [BreadcrumbItem(label: 'Individual Report')];
    case DashboardViewMode.pdfPreview:
      return [BreadcrumbItem(label: 'PDF Report Preview', isActive: true)];
  }
}
```

**After:**

```dart
List<BreadcrumbItem> _buildBreadcrumbs(DashboardViewMode viewMode, [GlobalDashboardState? state]) {
  switch (viewMode) {
    case DashboardViewMode.global:
      return []; // Root level - no breadcrumbs
    case DashboardViewMode.individual:
      final ownerName = state?.selectedVehicle?.ownerName ?? 'Unknown';
      return [
        BreadcrumbItem(label: '$ownerName\'s Report'),
      ]; //shows owner name as breadcrumb item label
    case DashboardViewMode.pdfPreview:
      // Check if PDF preview is from individual or global report
      if (state?.previousViewMode == DashboardViewMode.individual) {
        final ownerName = state?.selectedVehicle?.ownerName ?? 'Unknown';
        return [
          BreadcrumbItem(label: '$ownerName\'s Report'),
          BreadcrumbItem(label: 'PDF Report Preview', isActive: true),
        ];
      } else {
        // Global PDF report
        return [BreadcrumbItem(label: 'PDF Report Preview', isActive: true)];
      }
  }
}
```

### Updated Method Call

**Location**: Same file, in the BlocListener

```dart
final breadcrumbs = _buildBreadcrumbs(state.viewMode, state);
```

## Key Features

### 1. **Dynamic Label Generation**

- Extracts `ownerName` from `state.selectedVehicle?.ownerName`
- Provides fallback to 'Unknown' if owner name is null
- Formats as "OwnerName's Report" for better UX

### 2. **PDF Preview Hierarchy Differentiation**

- Uses `state.previousViewMode` to determine PDF context
- **Individual PDF**: Shows full hierarchy with owner name
- **Global PDF**: Shows simplified hierarchy without owner context

### 3. **Null Safety**

- Uses null-aware operators (`?.` and `??`)
- Handles cases where state or previousViewMode might be null
- Prevents crashes when vehicle data is not loaded

### 4. **Backward Compatibility**

- Uses optional parameter `[GlobalDashboardState? state]`
- Other view modes (global) remain unchanged
- No breaking changes to existing functionality

## Breadcrumb Hierarchies

### **Global Dashboard**

```
Dashboard2 [Root]
```

### **Individual Report**

```
Dashboard2 [Root] > "OwnerName's Report"
```

### **Individual PDF Report**

```
Dashboard2 [Root] > "OwnerName's Report" > PDF Report Preview
```

### **Global PDF Report**

```
Dashboard2 [Root] > PDF Report Preview
```

## Benefits

### **Efficiency**

- ✅ Uses existing state without additional API calls
- ✅ Single source of truth (GlobalDashboardState)
- ✅ No performance overhead

### **Maintainability**

- ✅ Centralized breadcrumb logic in one method
- ✅ Clear separation of concerns
- ✅ Easy to modify or extend

### **Scalability**

- ✅ Pattern can be extended for other dynamic breadcrumbs
- ✅ Optional parameter allows future enhancements
- ✅ Consistent with existing codebase patterns

### **User Experience**

- ✅ Provides immediate context about which vehicle is being viewed
- ✅ Clear navigation hierarchy for both report types
- ✅ Professional appearance with proper possessive formatting
- ✅ Graceful fallback for edge cases

## Usage Examples

### Normal Cases

```
Selected Vehicle: { vehicleId: "V123", ownerName: "John Doe" }
Individual Report Breadcrumb: "John Doe's Report"
Individual PDF Breadcrumb: ["John Doe's Report", "PDF Report Preview"]

Global PDF Report Breadcrumb: ["PDF Report Preview"]
```

### Edge Cases

```
Selected Vehicle: { vehicleId: "V456", ownerName: null }
Individual Report Breadcrumb: "Unknown's Report"
Individual PDF Breadcrumb: ["Unknown's Report", "PDF Report Preview"]

No Vehicle Selected:
Global PDF Breadcrumb: ["PDF Report Preview"]
```

## Implementation Details

### Dependencies

- `GlobalDashboardState` - Contains selectedVehicle and previousViewMode data
- `BreadcrumbItem` - UI component for breadcrumb display
- `DashboardViewMode` - Enum for view mode management

### Data Flow

1. User selects a vehicle in global dashboard
2. `GlobalDashboardCubit` updates state with `selectedVehicle`
3. User navigates to individual report or generates PDF
4. `BlocListener` detects state change
5. `_buildBreadcrumbs` called with current state
6. Dynamic breadcrumb generated based on view mode and context
7. For PDF preview, `previousViewMode` determines hierarchy level

### State Management

- `previousViewMode` tracks the view before entering PDF preview
- This enables proper breadcrumb hierarchy reconstruction
- State is preserved when navigating between views

## Future Enhancements

### Potential Improvements

1. **Vehicle Model/Plate**: Include vehicle model or plate number

   ```dart
   final label = '${ownerName}\'s ${vehicleModel ?? 'Vehicle'}';
   ```

2. **Status Indicators**: Add status icons or colors

   ```dart
   return BreadcrumbItem(
     label: '$ownerName\'s Report',
     icon: vehicle.isActive ? Icons.check_circle : Icons.warning,
   );
   ```

3. **Localization**: Support for multiple languages

   ```dart
   return BreadcrumbItem(label: AppLocalizations.of(context).vehicleReport(ownerName));
   ```

4. **Breadcrumb Navigation**: Implement click handlers for navigation
   ```dart
   return BreadcrumbItem(
     label: '$ownerName\'s Report',
     onTap: () => navigateToIndividualReport(vehicleId),
   );
   ```

### Extension Points

- The optional `state` parameter allows for future dynamic breadcrumbs
- Pattern can be replicated for other dashboard views
- Easy to add additional context (date ranges, filters, etc.)

## Testing Considerations

### Test Cases

1. **Normal Flow**: Vehicle with valid owner name
2. **Null Owner**: Vehicle with null owner name
3. **Empty State**: No vehicle selected
4. **Loading State**: State still initializing
5. **Error State**: Error in vehicle data loading
6. **PDF Navigation**: Both global and individual PDF preview contexts
7. **Previous View Mode**: State transitions between views

### Mock Data

```dart
final testState = GlobalDashboardState(
  viewMode: DashboardViewMode.pdfPreview,
  previousViewMode: DashboardViewMode.individual,
  selectedVehicle: VehicleSearchSuggestion(
    vehicleId: 'TEST123',
    ownerName: 'Test User',
    // ... other fields
  ),
);
```

## Conclusion

This implementation provides a robust, efficient, and user-friendly solution for dynamic breadcrumbs that enhances the CVMS dashboard's usability while maintaining code quality and scalability. The proper hierarchy differentiation between global and individual PDF reports ensures users always have clear navigation context.
