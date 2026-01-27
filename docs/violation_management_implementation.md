# Violation Management Implementation Documentation

## Overview

This document describes the implementation of the violation confirmation and rejection functionality in the CVMS (Cloud-based Vehicle Monitoring System). The system allows administrators to review reported violations and either confirm them (triggering sanctions) or reject them (marking as invalid).

## Architecture

### Components

1. **CustomConfirmDialog** - Simple confirmation dialog for validating violations
2. **CustomRejectDialog** - Rejection dialog for invalidating violations
3. **ViolationActions** - Action buttons in the table (confirm, reject, edit, view more)
4. **ViolationDataSource** - Data source for the violation table
5. **ViolationTable** - Main table component
6. **ViolationManagementPage** - Main page for violation management

### Status Flow

```
Pending Review → Confirmed → Sanction Applied
                ↓
              Dismissed (Invalid)
```

## Implementation Details

### 1. CustomConfirmDialog

**File:** `lib/features/violation_management/widgets/dialogs/custom_confirm_dialog.dart`

**Purpose:** Simple confirmation dialog that automatically sets violation status to "confirmed"

**Key Features:**

- No status selection dropdown (simplified UX)
- Shows current status → "Confirmed" transition
- Blue info box explaining automatic sanction application
- Loading state during submission
- Error handling

**Usage:**

```dart
CustomConfirmDialog(
  currentStatus: entry.status,
  onConfirm: () async {
    await context.read<ViolationCubit>().updateViolationStatus(
      violationId: entry.id,
      status: ViolationStatus.confirmed,
    );
  },
)
```

### 2. CustomRejectDialog

**File:** `lib/features/violation_management/widgets/dialogs/custom_reject_dialog.dart`

**Purpose:** Rejection dialog that sets violation status to "dismissed"

**Key Features:**

- Red warning theme (different from confirm dialog)
- Shows current status → "Dismissed" transition
- Warning box explaining no sanctions will be applied
- Loading state during submission
- Error handling

**Usage:**

```dart
CustomRejectDialog(
  currentStatus: entry.status,
  onReject: () async {
    await context.read<ViolationCubit>().updateViolationStatus(
      violationId: entry.id,
      status: ViolationStatus.dismissed,
    );
  },
)
```

### 3. ViolationActions

**File:** `lib/features/violation_management/widgets/actions/violation_actions.dart`

**Purpose:** Action buttons for individual violations in the table

**Key Features:**

- **Confirm Button:** Disabled when already confirmed (grey color)
- **Reject Button:** Disabled when already dismissed (grey color)
- **Edit Button:** For editing violation details
- **View More Button:** Additional actions menu

**Button States:**

```dart
// Confirm button logic
onPressed: isConfirmed ? () {} : onConfirm,
iconColor: isConfirmed ? AppColors.grey : AppColors.success,

// Reject button logic
onPressed: isDismissed ? () {} : onReject,
iconColor: isDismissed ? AppColors.grey : AppColors.error.withValues(alpha: 0.5),
```

### 4. ViolationDataSource

**File:** `lib/features/violation_management/widgets/datasource/violation_data_source.dart`

**Purpose:** Data source for the violation table, handles action button callbacks

**Key Features:**

- Passes ViolationEntry to action callbacks
- Determines button states based on violation status
- Integrates with ViolationCubit for state management

**Callback Implementation:**

```dart
onReject: () => onReject?.call(entry),
onEdit: () => onEdit?.call(entry),
onConfirm: () => onConfirm?.call(entry),
onViewMore: () => onViewMore?.call(entry),
```

### 5. ViolationTable

**File:** `lib/features/violation_management/widgets/tables/violation_table.dart`

**Purpose:** Main table component for displaying violations

**Key Features:**

- Accepts callback functions for all actions
- Integrates with ViolationDataSource
- Supports bulk selection mode

**Callback Signatures:**

```dart
final Function(ViolationEntry) onReject;
final Function(ViolationEntry) onEdit;
final Function(ViolationEntry) onConfirm;
final Function(ViolationEntry) onViewMore;
```

### 6. ViolationManagementPage

**File:** `lib/features/violation_management/pages/violation_management_page.dart`

**Purpose:** Main page that orchestrates the violation management functionality

**Key Features:**

- Shows confirmation/rejection dialogs
- Handles API calls to update violation status
- Error handling with user feedback
- Integration with ViolationCubit

**Confirm Implementation:**

```dart
onConfirm: (ViolationEntry entry) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return CustomConfirmDialog(
        currentStatus: entry.status,
        onConfirm: () async {
          // Close dialog first
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).pop();
          }

          // Update status
          await context.read<ViolationCubit>()
            .updateViolationStatus(
              violationId: entry.id,
              status: ViolationStatus.confirmed,
            );
        },
      );
    },
  );
},
```

**Reject Implementation:**

```dart
onReject: (ViolationEntry entry) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return CustomRejectDialog(
        currentStatus: entry.status,
        onReject: () async {
          // Close dialog first
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).pop();
          }

          // Update status
          await context.read<ViolationCubit>()
            .updateViolationStatus(
              violationId: entry.id,
              status: ViolationStatus.dismissed,
            );
        },
      );
    },
  );
},
```

## User Workflow

### Confirming a Violation

1. User clicks green checkmark button on pending violation
2. CustomConfirmDialog appears showing:
   - Current status → "Confirmed" transition
   - Blue info box about automatic sanctions
3. User clicks "Confirm" button
4. Dialog closes and violation status updates to "confirmed"
5. System automatically applies sanctions based on offense count

### Rejecting a Violation

1. User clicks red X button on pending violation
2. CustomRejectDialog appears showing:
   - Current status → "Dismissed" transition
   - Red warning box about no sanctions
3. User clicks "Reject" button
4. Dialog closes and violation status updates to "dismissed"
5. No sanctions are applied

## Button States

| Status           | Confirm Button | Reject Button  |
| ---------------- | -------------- | -------------- |
| Pending Review   | Green, Active  | Red, Active    |
| Confirmed        | Grey, Disabled | Red, Active    |
| Dismissed        | Green, Active  | Grey, Disabled |
| Sanction Applied | Grey, Disabled | Grey, Disabled |

## Error Handling

Both dialogs implement comprehensive error handling:

1. **Dialog Management:** Dialog closes before API call to prevent UI freezing
2. **API Errors:** Catches exceptions and shows red error snackbar
3. **State Safety:** Checks `context.mounted` before navigation operations
4. **Loading States:** Shows "Confirming..." or "Rejecting..." during API calls

## Integration Points

### ViolationCubit Integration

The system uses the existing `ViolationCubit.updateViolationStatus()` method:

```dart
Future<void> updateViolationStatus({
  required String violationId,
  required ViolationStatus status,
}) async
```

### Dashboard Integration

Dashboard views are updated to use the new callback signatures:

```dart
// Before
onReject: () {},

// After
onReject: (ViolationEntry entry) {},
```

## Future Enhancements

### Potential Improvements

1. **Bulk Operations:** Extend to support confirming/rejecting multiple violations
2. **Undo Functionality:** Add ability to undo confirm/reject actions
3. **Audit Trail:** Log all status changes with user and timestamp
4. **Notifications:** Send notifications when violations are confirmed/rejected
5. **Custom Reasons:** Allow users to add reasons for rejection

### Sanction Integration

The confirmed violations are designed to integrate with the sanction management system:

- Confirmed violations trigger automatic sanction application
- Sanctions are based on the number of confirmed offenses
- Different sanction types (warning, suspension, revocation) based on offense count

## Testing Considerations

### Unit Tests

1. **Dialog Behavior:** Test dialog opening/closing
2. **Status Updates:** Verify correct status changes
3. **Button States:** Test enable/disable logic
4. **Error Handling:** Test error scenarios

### Integration Tests

1. **End-to-End Workflow:** Test complete confirm/reject flow
2. **State Management:** Verify ViolationCubit integration
3. **UI Updates:** Test table refreshes after status changes
4. **Error Recovery:** Test error handling and user feedback

## Conclusion

The violation confirmation and rejection functionality provides a streamlined user experience for managing reported violations. The implementation follows clean architecture principles with proper separation of concerns, comprehensive error handling, and intuitive user interface design.

The system is designed to integrate seamlessly with the sanction management module, providing a complete workflow from violation reporting to sanction application.
