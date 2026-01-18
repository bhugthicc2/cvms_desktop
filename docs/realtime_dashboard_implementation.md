# Real-Time Dashboard Implementation Guide

## Overview

This document documents the step-by-step implementation of real-time data updates in the CVMS Dashboard2 feature using Firestore streams. The implementation focuses on the "Total Entries/Exits" metric as the foundation for real-time dashboard functionality.

## Architecture

```
Firestore Collection → Repository Stream → Cubit → State → UI Update
     ↓                        ↓        ↓       ↓
vehicle_logs changes → watchTotalEntriesExits() → DashboardCubit → DashboardState → GlobalDashboardView
```

## Implementation Steps

### Step 1: Repository Layer (`dashboard_repositoty.dart`)

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardRepository {
  final FirebaseFirestore _db;

  DashboardRepository(this._db);

  //realtime implementation step 1
  /// Real-time total entries/exits
  Stream<int> watchTotalEntriesExits() {
    return _db.collection('vehicle_logs').snapshots().map((snapshot) {
      return snapshot.docs.length;
    });
  }
}
```

**Purpose**: Creates a Firestore stream that listens to changes in the `vehicle_logs` collection and emits the total count of documents.

### Step 2: State Management (`dashboard_state.dart`)

```dart
//realtime implementation step 2
final int totalEntriesExits;

//realtime implementation step 3
const DashboardState({
  // ... other fields
  this.totalEntriesExits = 0,
});

//realtime implementation step 4
DashboardState copyWith({
  // ... other parameters
  int? totalEntriesExits,
}) {
  return DashboardState(
    // ... other assignments
    totalEntriesExits: totalEntriesExits ?? this.totalEntriesExits,
  );
}

//realtime implementation step 5
@override
List<Object?> get props => [
  // ... other props
  totalEntriesExits,
];
```

**Purpose**: Adds the real-time data field to the state management layer with proper immutability and equality support.

### Step 3: Cubit Logic (`dashboard_cubit.dart`)

```dart
class DashboardCubit extends Cubit<DashboardState> {
  // Realtime implementation step 6
  final DashboardRepository repository;

  // Realtime implementation step 7
  StreamSubscription<int>? _logsSub;

  // Realtime implementation step 8
  DashboardCubit(this.repository) : super(const DashboardState()) {
    // Realtime implementation step 9
    _listenToVehicleLogs();
  }

  void _listenToVehicleLogs() {
    // Realtime implementation step 10

    _logsSub = repository.watchTotalEntriesExits().listen(
      (count) {
        // Realtime implementation step 11

        emit(
          // Realtime implementation step 12
          state.copyWith(
            // Realtime implementation step 13
            totalEntriesExits: count, // Realtime implementation step 14
          ),
        );
      },

      onError: (e) {
        // Realtime implementation step 15

        emit(
          state.copyWith(error: e.toString()),
        ); // Realtime implementation step 16
      },
    );
  }

  @override
  Future<void> close() {
    // Realtime implementation step 17

    _logsSub?.cancel(); // Realtime implementation step 18

    return super.close(); // Realtime implementation step 19
  }
}
```

**Purpose**: Manages the stream subscription lifecycle, updates state when data changes, handles errors, and properly cleans up resources.

### Step 4: Dependency Injection (`dasboard_page.dart`)

```dart
@override
Widget build(BuildContext context) {
  return BlocProvider(
    create: (_) => DashboardCubit(
      DashboardRepository(
        FirebaseFirestore.instance,
      ), // Realtime implementation step 20
    ),
    child: BlocListener<DashboardCubit, DashboardState>(
      // ... rest of the widget
    ),
  );
}
```

**Purpose**: Provides the DashboardCubit with the properly configured repository instance.

### Step 5: UI Integration (`global_dashboard_view.dart`)

```dart
// Global Stats Cards
BlocBuilder<DashboardCubit, DashboardState>(
  builder: (context, state) {
    // Realtime implementation step 21
    return GlobalStatsCardSection(
      statsCard1Label: 'Total Violations',
      statsCard1Value: MockDashboardData.fleetSummary.totalViolations,
      statsCard2Label: 'Pending Violations',
      statsCard2Value: MockDashboardData.fleetSummary.activeViolations,
      statsCard3Label: 'Total Vehicles',
      statsCard3Value: MockDashboardData.fleetSummary.totalVehicles,
      statsCard4Label: 'Total Entries/Exits',
      statsCard4Value: state.totalEntriesExits, // Realtime implementation step 22
    );
  },
),
```

**Purpose**: Displays the real-time data in the UI, automatically updating when the state changes.

## Key Features

### Real-Time Updates

- **Automatic**: No manual refresh needed
- **Instant**: UI updates immediately when Firestore data changes
- **Efficient**: Uses Firestore's built-in real-time capabilities

### Error Handling

- **Stream Errors**: Caught and displayed in the UI
- **Graceful Degradation**: App continues to function if stream fails
- **User Feedback**: Error messages shown to users

### Resource Management

- **Proper Cleanup**: Stream subscriptions cancelled when cubit is disposed
- **Memory Safe**: Prevents memory leaks from abandoned streams
- **Lifecycle Aware**: Respects widget lifecycle

## Data Flow

1. **Firestore Change**: A document is added/removed/modified in `vehicle_logs` collection
2. **Stream Emission**: Firestore emits a new snapshot
3. **Repository Processing**: `watchTotalEntriesExits()` maps snapshot to document count
4. **Cubit Update**: Stream listener receives count and updates state
5. **State Change**: `DashboardState` is updated with new `totalEntriesExits`
6. **UI Rebuild**: `BlocBuilder` detects state change and rebuilds the widget
7. **Visual Update**: New count appears in the "Total Entries/Exits" stat card

## Performance Considerations

### Firestore Optimization

- **Collection Size**: Counting all documents can be expensive for large collections
- **Alternative**: Consider using a separate counter document for better performance
- **Indexing**: Ensure proper indexes for queries if filtering is added

### Stream Management

- **Single Stream**: One stream subscription per metric to avoid redundancy
- **Cancellation**: Always cancel streams in the `close()` method
- **Error Recovery**: Implement retry logic for failed streams

## Future Enhancements

### Additional Metrics

- **Total Violations**: Stream from `violations` collection
- **Active Vehicles**: Stream filtered by status
- **Fleet Summary**: Aggregate multiple collections

### Performance Improvements

- **Batch Updates**: Group multiple metric updates
- **Debouncing**: Prevent excessive UI updates
- **Caching**: Cache data for offline support

### Advanced Features

- **Conditional Updates**: Only update relevant UI sections
- **Optimistic Updates**: Update UI before server confirmation
- **Conflict Resolution**: Handle concurrent modifications

## Troubleshooting

### Common Issues

1. **Stream Not Updating**
   - Check Firestore rules
   - Verify collection name
   - Ensure proper permissions

2. **Memory Leaks**
   - Verify stream cancellation in `close()`
   - Check for multiple subscriptions
   - Monitor stream lifecycle

3. **UI Not Updating**
   - Confirm `BlocBuilder` is used
   - Check state immutability
   - Verify `copyWith` implementation

### Debugging Tips

- Add logging to stream listeners
- Monitor state changes in debug console
- Use Flutter DevTools for stream inspection
- Test with Firestore emulator

## Conclusion

This implementation provides a solid foundation for real-time dashboard functionality. The pattern can be extended to additional metrics and features while maintaining clean architecture and proper resource management.

The step-by-step approach ensures each layer is properly implemented before moving to the next, making the code maintainable and testable.
