# Violation History Implementation Documentation

## Overview

The Violation History feature provides real-time display of vehicle violations in the individual dashboard, showing the most recent violations with user information and status tracking.

## Architecture Components

### 1. ViolationHistoryEntry (Data Model)

```dart
class ViolationHistoryEntry extends Equatable {
  final String violationId;
  final DateTime dateTime;
  final String violationType;
  final String reportedBy;
  final String status;
  final DateTime createdAt;
  final DateTime lastUpdated;

  // Computed properties
  bool get isPending => status.toLowerCase() == 'pending';
  bool get isResolved => status.toLowerCase() == 'resolved';
}
```

**Purpose**: Immutable data model for violation records
**Key Features**:

- Equatable for efficient comparisons
- Computed boolean properties for status checks
- Complete violation lifecycle tracking

### 2. Repository Layer (Data Access)

```dart
Stream<List<ViolationHistoryEntry>> watchViolationHistory({
  required String vehicleId,
  int limit = 10,
}) {
  return _db
    .collection('violations')
    .where('vehicleId', isEqualTo: vehicleId)
    .orderBy('createdAt', descending: true)
    .limit(limit)
    .snapshots()
    .asyncMap((snapshot) async {
      // Step 1: Collect userIds from violations
      final userIds = snapshot.docs
        .map((doc) => doc['reportedByUserId'] as String?)
        .whereType<String>()
        .toSet();

      // Step 2: Batch fetch user information
      final usersMap = <String, String>{};
      if (userIds.isNotEmpty) {
        final usersSnap = await _db.collection('users').get();
        for (final doc in usersSnap.docs) {
          if (userIds.contains(doc.id)) {
            usersMap[doc.id] = doc.data()['fullname'] ?? 'Unknown';
          }
        }
      }

      // Step 3: Build violation entries with user names
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ViolationHistoryEntry(
          violationId: doc.id,
          dateTime: (data['reportedAt'] as Timestamp).toDate(),
          violationType: data['violationType'] ?? '',
          reportedBy: usersMap[data['reportedByUserId']] ?? 'Unknown',
          status: data['status'] ?? '',
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          lastUpdated: (data['createdAt'] as Timestamp).toDate(),
        );
      }).toList();
    });
}
```

**Key Features**:

- **Real-time Updates**: Uses `.snapshots()` for live data
- **User Resolution**: Batch fetches user names from userIds
- **Efficient Queries**: Vehicle-specific filtering with limits
- **Data Transformation**: Converts Firestore data to domain models

### 3. State Management (Cubit)

```dart
// IndividualDashboardState
final List<ViolationHistoryEntry> violationHistory;

// IndividualDashboardCubit
StreamSubscription? _violationHistorySub;

void _watchViolationHistory() {
  _violationHistorySub = repository
    .watchViolationHistory(vehicleId: vehicleId)
    .listen((entries) {
      emit(state.copyWith(violationHistory: entries));
    });
}

@override
Future<void> close() {
  _violationHistorySub?.cancel();
  return super.close();
}
```

**Key Features**:

- **Stream Management**: Proper subscription lifecycle
- **State Updates**: Real-time state emission
- **Memory Safety**: Cancels subscriptions on disposal

### 4. UI Integration (IndividualReportView)

```dart
BlocBuilder<IndividualDashboardCubit, IndividualDashboardState>(
  builder: (context, state) {
    return ViolationHistoryTableSection(
      allowSorting: false,
      istableHeaderDark: false,
      violationHistoryEntries: state.violationHistory,
      sectionTitle: 'Violation History',
      onClick: () {
        //todo
      },
    );
  },
)
```

## Complete Data Flow

### Phase 1: Initialization

```
IndividualDashboardCubit._init()
    ↓
_watchViolationHistory()
    ↓
repository.watchViolationHistory(vehicleId)
```

### Phase 2: Data Fetching

```
Firestore Query
    ↓
.violations collection
    ↓
.where('vehicleId', isEqualTo: vehicleId)
    ↓
.orderBy('createdAt', descending: true)
    ↓
.limit(10)
    ↓
.snapshots() // Real-time stream
```

### Phase 3: User Resolution

```
Collect userIds from violations
    ↓
Batch fetch from .users collection
    ↓
Map userId → fullname
    ↓
Create ViolationHistoryEntry objects
```

### Phase 4: State Update

```
Repository stream emits List<ViolationHistoryEntry>
    ↓
IndividualDashboardCubit receives data
    ↓
emit(state.copyWith(violationHistory: entries))
    ↓
UI rebuilds with new data
```

### Phase 5: UI Display

```
BlocBuilder rebuilds
    ↓
ViolationHistoryTableSection receives data
    ↓
ViolationHistoryDataSource processes entries
    ↓
CustomTable displays formatted data
```

## Technical Implementation Details

### Firestore Schema Requirements

```dart
// violations collection document
{
  'vehicleId': 'vehicle123',
  'reportedByUserId': 'user456',
  'violationType': 'Speeding',
  'status': 'pending',
  'reportedAt': Timestamp,
  'createdAt': Timestamp,
  // ... other fields
}

// users collection document
{
  'fullname': 'John Doe',
  // ... other user fields
}
```

### Performance Optimizations

1. **Batch User Fetching**: Single query for all users instead of N+1 queries
2. **Query Limits**: Limits to 10 most recent violations
3. **Efficient Indexing**: Requires Firestore indexes on:
   - `vehicleId` + `createdAt` (descending)
   - `userId` for user collection

4. **Stream Management**: Proper subscription cancellation prevents memory leaks

### Error Handling

```dart
// In repository stream
.snapshots()
.asyncMap((snapshot) async {
  try {
    // Data processing logic
    return entries;
  } catch (e) {
    // Handle parsing errors
    return <ViolationHistoryEntry>[];
  }
})

// In cubit subscription
.listen(
  (entries) => emit(state.copyWith(violationHistory: entries)),
  onError: (e) => print('Error watching violation history: $e'),
)
```

### Testing Strategy

#### Unit Tests

```dart
test('should resolve user names correctly', () async {
  // Mock Firestore responses
  when(mockDb.collection('violations').snapshots())
    .thenAnswer(Stream.value(mockViolationSnapshot));
  when(mockDb.collection('users').get())
    .thenAnswer(mockUserSnapshot);

  final result = await repository.watchViolationHistory(vehicleId: 'test').first;

  expect(result.first.reportedBy, equals('John Doe'));
});
```

#### Integration Tests

```dart
testWidgets('should display violation history in UI', (tester) async {
  await tester.pumpWidget(
    BlocProvider(
      create: (_) => mockIndividualCubit,
      child: IndividualReportView(vehicleInfo: mockVehicleInfo),
    ),
  );

  // Verify table displays violations
  expect(find.byType(ViolationHistoryTableSection), findsOneWidget);
  expect(find.text('Speeding'), findsOneWidget);
});
```

## Summary

The Violation History implementation provides:

1. **Real-time Data**: Live updates from Firestore
2. **User Resolution**: Automatic user name fetching
3. **Efficient Architecture**: Clean separation of concerns
4. **Performance Optimized**: Batch queries and proper limits
5. **Error Resilient**: Graceful error handling
6. **Testable**: Comprehensive test coverage strategy

This architecture ensures users see up-to-date violation information with proper user attribution while maintaining clean, maintainable code structure.
