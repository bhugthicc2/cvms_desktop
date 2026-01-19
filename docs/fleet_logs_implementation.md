# Fleet Logs Implementation Documentation 📊🚗

## Overview

The Fleet Logs feature provides real-time visualization of vehicle entry/exit trends over different time ranges with dynamic chart updates and proper BLoC state management.

## Architecture Flow

### 1. Data Flow Pipeline

```
Firestore → Repository → Cubit → State → UI (Chart)
```

---

## 🔧 Core Components

### 1. TimeBuckerHelper (`time_bucket_helper.dart`)

**Purpose**: Manages time-based data aggregation and formatting

#### Key Methods:

**`generateTimeBuckets(start, end, grouping)`**

- Creates empty time buckets for the selected range
- Supports day/week/month/year groupings
- Ensures consistent time intervals

**`formatBucket(date, grouping)`**

- Converts DateTime to standardized bucket keys:
  - Day: `"2025-01-20"` (ISO format)
  - Week: `"W1"`, `"W2"` (week numbers)
  - Month: `"2025-01"` (year-month)
  - Year: `"2025"` (year only)

**`parseBucket(bucketKey, grouping)`**

- Converts bucket keys back to DateTime for chart rendering
- Handles all grouping formats with error handling
- Essential for proper x-axis display in charts

---

### 2. GlobalDashboardRepository (`global_dashboard_repository.dart`)

**Purpose**: Fetches and aggregates fleet logs data from Firestore

#### `watchFleetLogsTrend(start, end, grouping)` Method:

```dart
Stream<List<ChartDataModel>> watchFleetLogsTrend({...}) {
  return _db
    .collection('vehicle_logs')
    .where('timeIn', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
    .where('timeIn', isLessThanOrEqualTo: Timestamp.fromDate(end))
    .snapshots()
    .map((snapshot) {
      // 1. Initialize empty buckets
      final bucketKeys = TimeBuckerHelper().generateTimeBuckets(start, end, grouping);

      // 2. Aggregate logs into buckets
      for (final doc in snapshot.docs) {
        final bucketKey = TimeBuckerHelper().formatBucket(date, grouping);
        buckets[bucketKey] = buckets[bucketKey]! + 1;
      }

      // 3. Convert to ChartDataModel with DateTime
      return buckets.entries.map((e) => ChartDataModel(
        category: e.key,
        value: e.value.toDouble(),
        date: TimeBuckerHelper().parseBucket(e.key, grouping),
      )).toList();
    });
}
```

**Key Features:**

- **Real-time**: Uses Firestore snapshots for live updates
- **Aggregation**: Counts logs per time bucket
- **Flexible**: Supports multiple time groupings
- **Chart-ready**: Converts to ChartDataModel with proper DateTime

---

### 3. DashboardCubit (`dashboard_cubit.dart`)

**Purpose**: Manages state and business logic for fleet logs

#### `watchFleetLogsTrend(start, end, grouping)` Method:

```dart
void watchFleetLogsTrend({...}) {
  _fleetLogsSub?.cancel(); // Prevent duplicate subscriptions

  emit(state.copyWith(loading: true)); // Notify UI loading

  _fleetLogsSub = repository.watchFleetLogsTrend(...)
    .listen(
      (data) => emit(state.copyWith(
        fleetLogsData: data,    // Update chart data
        loading: false,        // Stop loading
      )),
      onError: (e) => emit(state.copyWith(
        error: e.toString(),
        loading: false,
      )),
    );
}
```

**State Management:**

- **Single Source of Truth**: All fleet logs data in `DashboardState`
- **Loading States**: Proper loading/error handling
- **Subscription Management**: Prevents memory leaks
- **Real-time Updates**: Automatic UI updates on data changes

---

### 4. GlobalDashboardView (`global_dashboard_view.dart`)

**Purpose**: UI layer with time range selection and chart display

#### Initialization:

```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // Start with last 7 days, daily grouping
    context.read<DashboardCubit>().watchFleetLogsTrend(
      start: DateTime.now().subtract(const Duration(days: 6)),
      end: DateTime.now(),
      grouping: TimeGrouping.day,
    );
  });
}
```

#### Time Range Handling:

```dart
void _onTimeRangeChanged(String selectedRange) {
  // 1. Update cubit state (proper BLoC pattern)
  context.read<DashboardCubit>().updateTimeRange(selectedRange);

  // 2. Calculate date range
  DateTime endDate = DateTime.now();
  DateTime startDate;

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
      _showCustomDatePicker();
      return;
  }

  // 3. Fetch new data
  context.read<DashboardCubit>().watchFleetLogsTrend(
    start: startDate,
    end: endDate,
    grouping: grouping,
  );
}
```

---

## 🎯 Key Features

### 1. Dynamic Time Ranges

- **7 days**: Last week with daily buckets
- **30 days**: Last month with daily buckets
- **Month**: Current month with daily buckets
- **Year**: Current year with monthly buckets
- **Custom**: User-selected date range

### 2. Real-time Updates

- Firestore snapshots automatically push updates
- Chart updates instantly when new logs are added
- Loading states during data fetching

### 3. Proper BLoC Architecture

- **State Management**: All state in `DashboardState`
- **Single Source of Truth**: No local widget state
- **Reactive UI**: Automatic rebuilds on state changes
- **Clean Separation**: Business logic separated from UI

### 4. Dynamic Chart Titles

- Titles update based on selected time range
- Uses `DynamicTitleFormatter` for consistent formatting
- Examples:
  - "Fleet logs for the last 7 days"
  - "Fleet logs for this month"
  - "Fleet logs for this year"

---

## 🔄 Complete Data Flow

1. **User selects time range** → `_onTimeRangeChanged()`
2. **Update cubit state** → `updateTimeRange(selectedRange)`
3. **Calculate date range** → Based on selection
4. **Fetch data** → `watchFleetLogsTrend(start, end, grouping)`
5. **Repository query** → Firestore with date filters
6. **Aggregate data** → Time buckets with counts
7. **Convert to ChartDataModel** → With proper DateTime
8. **Update state** → `fleetLogsData` in `DashboardState`
9. **UI rebuilds** → Chart displays new data
10. **Dynamic title** → Updates based on current range

---

## 🛠️ Technical Implementation Details

### Time Grouping Strategy:

- **Day**: Best for 7-30 day ranges (detailed view)
- **Month**: Best for year-long data (summary view)
- **Week**: Available but not currently used
- **Year**: For very long-term trends

### Error Handling:

- Network errors caught in cubit
- Parsing errors handled in `TimeBuckerHelper`
- Loading states for better UX

### Performance Optimizations:

- Stream cancellation prevents memory leaks
- Efficient bucket generation
- Minimal rebuilds with proper `buildWhen` conditions

---

## 📊 Chart Integration

The fleet logs data integrates seamlessly with `LineChartWidget`:

- **X-axis**: DateTime from parsed bucket keys
- **Y-axis**: Log counts per time bucket
- **Real-time**: Updates automatically with new data
- **Responsive**: Handles different time ranges and groupings

---

## 📁 File Structure

```
lib/features/dashboard2/
├── bloc/
│   ├── dashboard_cubit.dart      # State management
│   └── dashboard_state.dart      # State definition
├── repositories/
│   └── global_dashboard_repository.dart  # Data fetching
├── utils/
│   ├── time_bucket_helper.dart  # Time aggregation logic
│   └── dynamic_title_formatter.dart  # Title formatting
├── pages/views/
│   └── global_dashboard_view.dart  # UI implementation
└── widgets/sections/charts/
    └── global_charts_section.dart  # Chart display
```

---

## 🔍 Code Examples

### Time Bucket Generation:

```dart
final buckets = TimeBuckerHelper().generateTimeBuckets(
  DateTime(2025, 1, 1),    // Start: Jan 1, 2025
  DateTime(2025, 1, 7),    // End: Jan 7, 2025
  TimeGrouping.day,        // Daily grouping
);
// Result: ["2025-01-01", "2025-01-02", ..., "2025-01-07"]
```

### Data Aggregation:

```dart
// For each vehicle log document
final bucketKey = TimeBuckerHelper().formatBucket(logDate, TimeGrouping.day);
buckets[bucketKey] = (buckets[bucketKey] ?? 0) + 1;
```

### Chart Data Conversion:

```dart
ChartDataModel(
  category: "2025-01-01",     // Bucket key
  value: 15.0,                // Log count
  date: DateTime(2025, 1, 1), // Parsed DateTime
)
```

---

## 🚀 Best Practices Implemented

1. **Separation of Concerns**: Each component has a single responsibility
2. **Reactive Programming**: Stream-based real-time updates
3. **State Management**: Proper BLoC pattern implementation
4. **Error Handling**: Comprehensive error catching and user feedback
5. **Performance**: Stream cancellation and efficient data structures
6. **Testability**: Business logic separated from UI
7. **Scalability**: Flexible time grouping and aggregation strategies

---

This implementation provides a robust, scalable, and maintainable fleet logs visualization system following Flutter best practices and proper BLoC architecture patterns. 🎯
