# Individual Report Dashboard Flow Documentation

## Overview

The Individual Report Dashboard provides a comprehensive view of a single vehicle's data, including real-time statistics, charts, and historical data. This document explains the complete flow from vehicle search to data display.

## Architecture Overview

### Core Components

```
┌─────────────────────────────────────────────────────────────────┐
│                    Individual Dashboard Flow                │
├─────────────────────────────────────────────────────────────────┤
│ 1. Vehicle Search → 2. Navigation → 3. Data Loading    │
│    ↓                    ↓              ↓               │
│ 4. Real-time Updates → 5. UI Display → 6. Interactions │
└─────────────────────────────────────────────────────────────────┘
```

### Key Classes and Their Responsibilities

#### 1. **IndividualVehicleInfo** (Data Model)

- **Purpose**: Holds all static vehicle information
- **Fields**:
  - `vehicleId`, `plateNumber`, `ownerName`, `vehicleType`
  - `department`, `status`, `vehicleModel`
  - `createdAt`, `expiryDate`, `daysUntilExpiration`
  - **MVP Fields**: `mvpProgress`, `mvpRegisteredDate`, `mvpExpiryDate`, `mvpStatusText`
- **Factory Method**: `fromFirestore()` - Converts Firestore data to model with calculated MVP values

#### 2. **IndividualDashboardCubit** (State Management)

- **Purpose**: Manages real-time data streams for a specific vehicle
- **Constructor**: Requires `vehicleId` and `repository`
- **Streams Managed**:
  - `watchTotalViolations()` - Total violations count
  - `watchPendingViolations()` - Pending violations count
  - `watchTotalVehicleLogs()` - Total logs count
  - `watchViolationByType()` - Violation distribution by type
  - `watchVehicleLogsTrend()` - Time-based logs trend
- **Public API**: `updateDateFilter()` - Changes date range for trend data
- **Lifecycle**: Properly cancels all subscriptions in `close()`

#### 3. **IndividualDashboardRepository** (Data Access)

- **Purpose**: Provides Firestore streams for individual vehicle data
- **Methods**:
  - `watchTotalViolations(vehicleId)` - Real-time violations count
  - `watchPendingViolations(vehicleId)` - Pending violations count
  - `watchTotalVehicleLogs(vehicleId)` - Total logs count
  - `watchViolationByType(vehicleId)` - Violation type distribution
  - `watchVehicleLogsTrend()` - Time-based logs with filtering
- **Query Pattern**: All queries filtered by `vehicleId`

#### 4. **IndividualReportView** (UI Component)

- **Purpose**: Main container for individual vehicle report
- **Props**: `vehicleInfo` (static data), `currentTimeRange` (optional)
- **Features**:
  - Date range picker with time filtering
  - Real-time statistics display
  - Interactive charts
  - Historical tables

#### 5. **IndividualStatsSection** (Statistics Display)

- **Purpose**: Shows vehicle statistics and information cards
- **Components**:
  - Stats cards (violations, logs, days until expiration)
  - Vehicle information card with MVP progress
- **Data Sources**: Mix of static `vehicleInfo` and real-time cubit state

#### 6. **IndividualChartsSection** (Data Visualization)

- **Purpose**: Displays charts for violation distribution and logs trend
- **Charts**:
  - Bar chart: Violation distribution by type
  - Line chart: Vehicle logs over time
- **Features**: Time range selector, dynamic titles

## Complete Data Flow

### Phase 1: Vehicle Search and Selection

```dart
// User searches for vehicle
VehicleSearchBar → VehicleSearchService → VehicleSearchRepository → Firestore

// User selects a result
onVehicleSelected: (suggestion) {
  context.read<GlobalDashboardCubit>()
    .showIndividualReport(suggestion.vehicleId);
}
```

### Phase 2: Navigation and Data Loading

```dart
// GlobalDashboardCubit handles navigation
Future<void> showIndividualReport(String vehicleId) async {
  emit(state.copyWith(loading: true));

  // Fetch static vehicle information
  final vehicleInfo = await VehicleSearchService()
    .getIndividualReport(vehicleId);

  // Switch to individual view mode
  emit(state.copyWith(
    selectedVehicle: vehicleInfo,
    viewMode: DashboardViewMode.individual,
    loading: false,
  ));
}
```

### Phase 3: Individual Dashboard Initialization

```dart
// DashboardPage provides IndividualDashboardCubit
BlocProvider(
  create: (context) => IndividualDashboardCubit(
    vehicleId: state.selectedVehicle!.vehicleId,
    repository: IndividualDashboardRepository(FirebaseFirestore.instance),
  ),
  child: IndividualReportView(vehicleInfo: state.selectedVehicle!),
)

// IndividualDashboardCubit initializes all streams
void _init() {
  _totalViolationsSub = repository.watchTotalViolations(vehicleId).listen(...);
  _pendingViolationsSub = repository.watchPendingViolations(vehicleId).listen(...);
  _vehicleLogsSub = repository.watchTotalVehicleLogs(vehicleId).listen(...);
  _violationTypeSub = repository.watchViolationByType(vehicleId).listen(...);
  _watchVehicleLogsTrend(); // Initialize trend with default date range
}
```

### Phase 4: Real-time Data Updates

```dart
// Repository provides real-time streams
Stream<int> watchTotalViolations(String vehicleId) {
  return _db
    .collection('violations')
    .where('vehicleId', isEqualTo: vehicleId)
    .snapshots()
    .map((snapshot) => snapshot.size); // Real-time count updates
}

// Cubit emits state changes
_totalViolationsSub = repository.watchTotalViolations(vehicleId).listen(
  (count) {
    emit(state.copyWith(totalViolations: count)); // Triggers UI rebuild
  },
);
```

### Phase 5: UI Display and Interaction

```dart
// IndividualReportView displays data using BlocBuilder
BlocBuilder<IndividualDashboardCubit, IndividualDashboardState>(
  builder: (context, state) {
    return Column(
      children: [
        // Statistics section with real-time data
        IndividualStatsSection(
          totalViolations: state.totalViolations, // From cubit
          totalPendingViolations: state.totalPendingViolations,
          totalVehicleLogs: state.totalVehicleLogs,
          // Static vehicle info
          plateNumber: vehicleInfo.plateNumber, // From props
          ownerName: vehicleInfo.ownerName,
          // ... other static fields
        ),

        // Charts section with time filtering
        IndividualChartsSection(
          violationDistribution: state.violationDistribution,
          vehicleLogs: state.vehicleLogsTrend,
          onTimeRangeChanged: _onTimeRangeChanged, // Date filter interaction
        ),
      ],
    );
  },
)
```

### Phase 6: Date Range Filtering

```dart
// User selects time range
_onTimeRangeChanged(String selectedRange, BuildContext context) {
  DateTime endDate = DateTime.now();
  DateTime startDate;
  TimeGrouping grouping;

  switch (selectedRange) {
    case '7 days':
      startDate = endDate.subtract(Duration(days: 7));
      grouping = TimeGrouping.day;
      break;
    case '30 days':
      startDate = endDate.subtract(Duration(days: 30));
      grouping = TimeGrouping.day;
      break;
    case 'Month':
      startDate = DateTime(endDate.year, endDate.month, 1);
      grouping = TimeGrouping.day;
      break;
    case 'Year':
      startDate = DateTime(endDate.year, 1, 1);
      grouping = TimeGrouping.month;
      break;
    case 'Custom':
      _showCustomDatePicker(context);
      return;
  }

  // Update cubit with new date range
  context.read<IndividualDashboardCubit>().updateDateFilter(
    start: startDate,
    end: endDate,
    grouping: grouping,
  );
}
```

## MVP (Motor Vehicle Permit) Integration

### MVP Progress Calculation

```dart
// IndividualVehicleInfo.fromFirestore() calculates MVP values
factory IndividualVehicleInfo.fromFirestore(String vehicleId, Map<String, dynamic> data) {
  final createdAt = data['createdAt']?.toDate();
  final expiryDate = createdAt != null
    ? RegistrationExpiryUtils.computeExpiryDate(createdAt)
    : null;

  double mvpProgress = 0.0;
  String mvpStatusText = 'Not Set';

  if (createdAt != null && expiryDate != null) {
    final now = DateTime.now();
    if (now.isBefore(createdAt)) {
      mvpStatusText = 'Not Started';
    } else if (now.isAfter(expiryDate)) {
      mvpStatusText = 'Expired';
      mvpProgress = 1.0;
    } else {
      mvpStatusText = 'Valid';
      final totalDuration = expiryDate.difference(createdAt);
      final elapsedDuration = now.difference(createdAt);
      mvpProgress = (elapsedDuration.inMilliseconds / totalDuration.inMilliseconds)
        .clamp(0.0, 1.0);
    }
  }

  return IndividualVehicleInfo(
    // ... other fields
    mvpProgress: mvpProgress,
    mvpRegisteredDate: createdAt,
    mvpExpiryDate: expiryDate,
    mvpStatusText: mvpStatusText,
    daysUntilExpiration: expiryDate?.difference(DateTime.now()).inDays ?? 0,
  );
}
```

### MVP Display in UI

```dart
// VehicleInfoCard displays MVP progress
LinearProgressIndicator(
  value: mvpProgress * _progressAnimation.value,
  backgroundColor: AppColors.grey.withValues(alpha: 0.2),
  valueColor: VehicleInfoService.getMvpProgressColor(
    mvpProgress, mvpRegisteredDate, mvpExpiryDate,
  ),
)

// Status and dates
CustomText(text: mvpStatusText)
CustomText(text: 'Registered on ${formatDate(mvpRegisteredDate)}')
CustomText(text: 'Expires on ${formatDate(mvpExpiryDate)}')
```

## Real-time Data Architecture

### Stream Management

```dart
class IndividualDashboardCubit extends Cubit<IndividualDashboardState> {
  StreamSubscription? _totalViolationsSub;
  StreamSubscription? _pendingViolationsSub;
  StreamSubscription? _vehicleLogsSub;
  StreamSubscription? _violationTypeSub;
  StreamSubscription? _vehicleLogsTrendSub;

  @override
  Future<void> close() {
    // Cancel all subscriptions to prevent memory leaks
    _totalViolationsSub?.cancel();
    _pendingViolationsSub?.cancel();
    _vehicleLogsSub?.cancel();
    _violationTypeSub?.cancel();
    _vehicleLogsTrendSub?.cancel();
    return super.close();
  }
}
```

### State Updates

```dart
// IndividualDashboardState holds all real-time data
class IndividualDashboardState extends Equatable {
  final int totalViolations;
  final int totalPendingViolations;
  final int totalVehicleLogs;
  final List<ChartDataModel> violationDistribution;
  final List<ChartDataModel> vehicleLogsTrend;
  final DateTime startDate;
  final DateTime endDate;
  final TimeGrouping grouping;

  // copyWith() for immutable updates
  // props for Equatable comparison
}
```

## Error Handling and Edge Cases

### Data Validation

```dart
// IndividualVehicleInfo.fromFirestore() handles missing data
final createdAt = data['createdAt'] != null
  ? (data['createdAt'] as Timestamp).toDate()
  : null;

// Graceful handling of null values
final daysUntilExpiration = expiryDate != null
  ? expiryDate.difference(DateTime.now()).inDays
  : 0;
```

### Stream Error Handling

```dart
_totalViolationsSub = repository.watchTotalViolations(vehicleId).listen(
  (count) {
    emit(state.copyWith(totalViolations: count));
  },
  onError: (e) {
    // Error state could be added here if needed
    print('Error watching violations: $e');
  },
);
```

## Performance Optimizations

### Selective Rebuilds

```dart
// BlocBuilder rebuilds only when relevant state changes
BlocBuilder<IndividualDashboardCubit, IndividualDashboardState>(
  buildWhen: (previous, current) {
    return previous.totalViolations != current.totalViolations ||
           previous.totalPendingViolations != current.totalPendingViolations;
  },
  builder: (context, state) {
    // UI only rebuilds when necessary
  },
)
```

### Efficient Queries

```dart
// All repository queries are filtered by vehicleId
.where('vehicleId', isEqualTo: vehicleId)

// Use snapshots() for real-time updates instead of get()
.snapshots().map((snapshot) => snapshot.size)
```

## Testing Considerations

### Unit Tests

```dart
// Test IndividualVehicleInfo factory
test('should calculate MVP progress correctly', () {
  final data = {
    'createdAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
    'plateNumber': 'ABC123',
    // ... other fields
  };

  final vehicleInfo = IndividualVehicleInfo.fromFirestore('vehicle1', data);

  expect(vehicleInfo.mvpStatusText, equals('Valid'));
  expect(vehicleInfo.mvpProgress, greaterThan(0.0));
});

// Test IndividualDashboardCubit
test('should update total violations on stream change', () {
  when(repository.watchTotalViolations('vehicle1'))
    .thenAnswer(Stream.fromIterable([5]));

  cubit = IndividualDashboardCubit(vehicleId: 'vehicle1', repository: repository);

  expect(cubit.state.totalViolations, equals(5));
});
```

### Integration Tests

```dart
// Test complete flow from search to display
testWidgets('should display individual report after vehicle selection', (tester) async {
  // Mock search selection
  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => mockGlobalCubit),
        BlocProvider(create: (_) => mockIndividualCubit),
      ],
      child: DashboardPage(),
    ),
  );

  // Simulate vehicle selection
  mockGlobalCubit.showIndividualReport('vehicle1');
  await tester.pumpAndSettle();

  // Verify individual view is displayed
  expect(find.byType(IndividualReportView), findsOneWidget);
  expect(find.text('Total Violations: 5'), findsOneWidget);
});
```

## Summary

The Individual Report Dashboard provides:

1. **Complete Vehicle Overview**: Static information + real-time statistics
2. **MVP Integration**: Automatic progress calculation and status tracking
3. **Real-time Updates**: Live data streams for all metrics
4. **Interactive Filtering**: Date range selection for trend analysis
5. **Clean Architecture**: Separation of concerns with proper state management
6. **Error Resilience**: Graceful handling of missing data and stream errors
7. **Performance**: Efficient queries and selective UI rebuilds

This architecture ensures that users get a comprehensive, up-to-date view of any selected vehicle's data while maintaining clean, maintainable code structure.
