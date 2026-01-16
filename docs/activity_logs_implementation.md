# Activity Logs Implementation Guide

## Overview

This guide covers the complete implementation of activity logging system for CVMS Desktop application.

## Architecture

- **ActivityLogService**: Singleton service for logging activities
- **ActivityLogRepository**: Firestore operations for activity logs
- **ActivityLogsCubit**: State management for activity logs UI
- **ActivityType Enum**: Type-safe activity categorization

## Step 1: Repository Integration (COMPLETED)

### VehicleRepository ✅

```dart
// Methods already enhanced with logging:
- addVehicle() → Logs vehicle creation
- updateVehicle() → Logs vehicle update
- deleteVehicle() → Logs vehicle deletion
```

### UserRepository ✅

```dart
// Methods already enhanced with logging:
- createUser() → Logs user creation
- updateUser() → Logs user update
- deleteUser() → Logs user deletion
```

### ViolationRepository ✅

```dart
// Methods already enhanced with logging:
- createViolationReport() → Logs violation report
```

### AuthRepository ✅

```dart
// Methods already enhanced with logging:
- signIn() → Logs user login
- signOut() → Logs user logout
- resetPassword() → Logs password reset
```

## Step 2: Add Bulk Operation Logging

### VehicleRepository - Add to addVehicles()

```dart
Future<void> addVehicles(List<VehicleEntry> entries) async {
  try {
    for (var i = 0; i < entries.length; i += _batchSize) {
      final batch = _firestore.batch();
      final end = (i + _batchSize < entries.length) ? i + _batchSize : entries.length;
      final sublist = entries.sublist(i, end);

      for (final entry in sublist) {
        final docRef = _firestore.collection(_collection).doc();
        batch.set(docRef, entry.toMap());
      }

      await batch.commit();
    }

    // Add this logging
    await _logger.logActivity(
      type: ActivityType.dataImport,
      description: 'Bulk import: ${entries.length} vehicles added',
      metadata: {'count': entries.length, 'action': 'bulk_import'},
    );
  } catch (e) {
    throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
  }
}
```

### VehicleRepository - Add to bulkDeleteVehicles()

```dart
Future<void> bulkDeleteVehicles(List<String> vehicleIds) async {
  if (vehicleIds.isEmpty) return;

  try {
    final batch = _firestore.batch();

    for (final id in vehicleIds) {
      final docRef = _firestore.collection(_collection).doc(id);
      batch.delete(docRef);
    }

    await batch.commit();

    // Add this logging
    await _logger.logActivity(
      type: ActivityType.vehicleDeleted,
      description: 'Bulk delete: ${vehicleIds.length} vehicles deleted',
      metadata: {'count': vehicleIds.length, 'action': 'bulk_delete'},
    );
  } catch (e) {
    throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
  }
}
```

### UserRepository - Add to bulkDeleteUsers()

```dart
Future<void> bulkDeleteUsers(List<String> userIds) async {
  try {
    final batch = _firestore.batch();

    for (final userId in userIds) {
      final docRef = _firestore.collection(_collection).doc(userId);
      batch.delete(docRef);
    }

    await batch.commit();

    // Add this logging
    await _logger.logActivity(
      type: ActivityType.userDeleted,
      description: 'Bulk delete: ${userIds.length} users deleted',
      metadata: {'count': userIds.length, 'action': 'bulk_delete'},
    );
  } catch (e) {
    throw Exception('Failed to bulk delete users: $e');
  }
}
```

## Step 3: Add Navigation Logging

### ShellCubit - Update selectPage()

```dart
void selectPage(int index) async {
  final navigationGuard = NavigationGuard();
  final canNavigate = await navigationGuard.checkUnsavedChanges();

  if (canNavigate) {
    // Add navigation logging
    await _logger.logNavigation(
      'Page ${state.selectedIndex}',
      'Page $index',
      null, // Will use current user from service
    );

    emit(state.copyWith(selectedIndex: index));
  }
}
```

**Required imports for ShellCubit:**

```dart
import '../../../core/services/activity_log_service.dart';
```

**Add logger instance:**

```dart
final ActivityLogService _logger = ActivityLogService();
```

## Step 4: Add Error Logging to BLoCs

### VehicleCubit - Error Handling

```dart
// In error handling sections
catch (error) {
  await _logger.logError(
    error.toString(),
    'VehicleCubit.loadVehicles',
    null, // Will use current user from service
  );
  emit(VehicleState.error(error.toString()));
}
```

### ViolationCubit - Error Handling

```dart
// In error handling sections
catch (error) {
  await _logger.logError(
    error.toString(),
    'ViolationCubit.loadViolations',
    null, // Will use current user from service
  );
  emit(ViolationState.error(error.toString()));
}
```

### UserCubit - Error Handling

```dart
// In error handling sections
catch (error) {
  await _logger.logError(
    error.toString(),
    'UserCubit.loadUsers',
    null, // Will use current user from service
  );
  emit(UserState.error(error.toString()));
}
```

## Step 5: Complete ActivityLogsPage UI

### Update ActivityLogsPage

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../bloc/activity_logs_cubit.dart';
import '../../../core/models/activity_log.dart';
import '../../../core/models/activity_type.dart';

class ActivityLogsPage extends StatelessWidget {
  const ActivityLogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActivityLogsCubit(ActivityLogRepository())..loadLogs(),
      child: const ActivityLogsView(),
    );
  }
}

class ActivityLogsView extends StatefulWidget {
  const ActivityLogsView({super.key});

  @override
  State<ActivityLogsView> createState() => _ActivityLogsViewState();
}

class _ActivityLogsViewState extends State<ActivityLogsView> {
  DateTime? startDate;
  DateTime? endDate;
  ActivityType? selectedType;
  String? selectedUserId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.medium),
        child: Container(
          decoration: cardDecoration(),
          child: Column(
            children: [
              // Filter Controls
              _buildFilterControls(),
              const SizedBox(height: 16),
              // Data Grid
              Expanded(child: _buildDataGrid()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterControls() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Date Range Filter
          IconButton(
            onPressed: _selectDateRange,
            icon: const Icon(Icons.date_range),
          ),
          const SizedBox(width: 8),
          Text(startDate != null && endDate != null
            ? '${startDate!.toShortDateString()} - ${endDate!.toShortDateString()}'
            : 'Select Date Range'),

          const SizedBox(width: 16),

          // Activity Type Filter
          DropdownButton<ActivityType>(
            value: selectedType,
            hint: const Text('All Types'),
            items: ActivityType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Row(
                  children: [
                    Icon(type.icon, color: type.color, size: 16),
                    const SizedBox(width: 8),
                    Text(type.label),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedType = value;
              });
              _applyFilters();
            },
          ),

          const Spacer(),

          // Clear Filters
          TextButton(
            onPressed: _clearFilters,
            child: const Text('Clear Filters'),
          ),

          // Refresh
          IconButton(
            onPressed: _refreshLogs,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  Widget _buildDataGrid() {
    return BlocBuilder<ActivityLogsCubit, ActivityLogsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.error != null) {
          return Center(child: Text('Error: ${state.error}'));
        }

        if (state.logs.isEmpty) {
          return const Center(child: Text('No activity logs found'));
        }

        return SfDataGrid(
          source: ActivityLogsDataSource(state.logs),
          columns: [
            GridColumn(
              columnName: 'timestamp',
              label: const Text('Date/Time'),
              width: 150,
            ),
            GridColumn(
              columnName: 'type',
              label: const Text('Activity'),
              width: 120,
            ),
            GridColumn(
              columnName: 'description',
              label: const Text('Description'),
              width: 300,
            ),
            GridColumn(
              columnName: 'userId',
              label: const Text('User'),
              width: 120,
            ),
          ],
        );
      },
    );
  }

  void _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
      _applyFilters();
    }
  }

  void _applyFilters() {
    context.read<ActivityLogsCubit>().filterLogs(
      startDate: startDate,
      endDate: endDate,
      type: selectedType,
      userId: selectedUserId,
    );
  }

  void _clearFilters() {
    setState(() {
      startDate = null;
      endDate = null;
      selectedType = null;
      selectedUserId = null;
    });
    context.read<ActivityLogsCubit>().clearFilters();
  }

  void _refreshLogs() {
    context.read<ActivityLogsCubit>().refreshLogs();
  }
}
```

### ActivityLogsDataSource for Syncfusion

```dart
class ActivityLogsDataSource extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];

  ActivityLogsDataSource(List<ActivityLog> logs) {
    _dataGridRows = logs.map((log) {
      return DataGridRow(cells: [
        DataGridCell<DateTime>('timestamp', log.timestamp),
        DataGridCell<ActivityType>('type', log.type),
        DataGridCell<String>('description', log.description),
        DataGridCell<String>('userId', log.userId ?? 'System'),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == 'timestamp') {
          return Text(
            (cell.value as DateTime).toString().substring(0, 19),
            style: const TextStyle(fontSize: 12),
          );
        }
        if (cell.columnName == 'type') {
          final type = cell.value as ActivityType;
          return Row(
            children: [
              Icon(type.icon, color: type.color, size: 16),
              const SizedBox(width: 4),
              Text(type.label),
            ],
          );
        }
        return Text(
          cell.value.toString(),
          style: const TextStyle(fontSize: 12),
        );
      }).toList(),
    );
  }
}
```

## Step 6: Add ActivityLogsCubit to Shell Navigation

### Update shell_navigation_config.dart

```dart
// Add import
import '../../features/activity_logs/bloc/activity_logs_cubit.dart';
import '../../features/activity_logs/pages/activity_logs_page.dart';

// Add to getPage() method
case 5: // Activity Logs index
  return MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => ActivityLogsCubit(ActivityLogRepository())),
    ],
    child: const ActivityLogsPage(),
  );
```

## Implementation Checklist

- [ ] Add bulk operation logging to VehicleRepository.addVehicles()
- [ ] Add bulk operation logging to VehicleRepository.bulkDeleteVehicles()
- [ ] Add bulk operation logging to UserRepository.bulkDeleteUsers()
- [ ] Add navigation logging to ShellCubit.selectPage()
- [ ] Add error logging to all BLoC error handlers
- [ ] Complete ActivityLogsPage UI implementation
- [ ] Add ActivityLogsCubit to shell navigation config
- [ ] Test all logging functionality

## Testing

1. **Test Repository Logging**: Perform CRUD operations and verify logs appear
2. **Test Bulk Operations**: Import/delete multiple items and verify bulk logging
3. **Test Navigation**: Navigate between pages and verify navigation logs
4. **Test Error Logging**: Trigger errors and verify error logs appear
5. **Test Filters**: Use date range and activity type filters
6. **Test Real-time Updates**: Verify logs appear in real-time

## Firestore Collection

The activity logs are stored in the `activities` collection with the following structure:

```dart
{
  'id': String,
  'type': String, // ActivityType.name
  'description': String,
  'userId': String?,
  'targetId': String?,
  'metadata': Map<String, dynamic>?,
  'timestamp': Timestamp,
}
```

## Performance Considerations

- Activity logs use Firestore streams for real-time updates
- Implement pagination for large datasets
- Consider log retention policies for production
- Use Firestore indexes for efficient querying
