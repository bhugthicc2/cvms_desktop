# Vehicle Logging System Documentation

## Overview

The Vehicle Logging System is a core component of the Cloud-based Vehicle Monitoring System (CVMS) that manages vehicle entry and exit tracking at JRMSU - Katipunan Campus. The system follows the BLoC (Business Logic Component) pattern with Flutter and integrates with Firebase Firestore for real-time data management.

## Architecture

The vehicle logging system follows a layered architecture:

```
┌─────────────────────────────────────┐
│              UI Layer               │
│        (VehicleLogsPage)           │
└─────────────────────────────────────┘
                    │
┌─────────────────────────────────────┐
│           BLoC Layer                │
│        (VehicleLogsCubit)          │
└─────────────────────────────────────┘
                    │
┌─────────────────────────────────────┐
│          Data Layer                 │
│      (VehicleLogsRepository)       │
└─────────────────────────────────────┘
                    │
┌─────────────────────────────────────┐
│         Firebase Layer              │
│    (Firestore Collections)         │
└─────────────────────────────────────┘
```

## Core Components

### 1. VehicleLogModel

**File**: `lib/features/vehicle_logs_management/models/vehicle_log_model.dart`

The data model representing a vehicle log entry with the following properties:

#### Properties
- `logID` (String): Unique identifier for the log entry
- `vehicleID` (String): Reference to the vehicle document ID
- `ownerName` (String): Name of the vehicle owner
- `plateNumber` (String): Vehicle's license plate number
- `vehicleModel` (String): Make and model of the vehicle
- `timeIn` (Timestamp): Entry timestamp (required)
- `timeOut` (Timestamp?): Exit timestamp (nullable for active sessions)
- `updatedBy` (String): User who created/updated the log
- `status` (String): Current status ("inside" or "outside")
- `durationMinutes` (int?): Duration of stay in minutes (calculated on exit)

#### Methods
- `toMap()`: Converts the model to a Map for Firestore storage
- `fromMap(Map<String, dynamic> map, String id)`: Factory constructor to create model from Firestore data

### 2. VehicleLogsRepository

**File**: `lib/features/vehicle_logs_management/data/vehicle_logs_repository.dart`

The data access layer that handles all Firebase Firestore operations for vehicle logs.

#### Key Methods

##### `addManualLog(VehicleLogModel entry)`
- **Purpose**: Adds a manual vehicle log entry
- **Validation**: Checks for existing active sessions before adding
- **Side Effects**: Updates vehicle status in the vehicles collection
- **Error Handling**: Uses FirebaseErrorHandler for consistent error messages

##### `fetchAvailableVehicles(String query)`
- **Purpose**: Retrieves vehicles with "outside" status for session creation
- **Filtering**: Supports owner name search queries
- **Returns**: List of vehicle data maps with complete vehicle information

##### `fetchLogs()`
- **Purpose**: Provides real-time stream of vehicle logs
- **Ordering**: Sorted by timeIn (descending - newest first)
- **Returns**: Stream<List<VehicleLogModel>> for reactive UI updates

##### `startSession(String vehicleID, String updatedBy, Map<String, dynamic> vehicleInfo)`
- **Purpose**: Creates a new vehicle entry session
- **Process**:
  1. Creates VehicleLogModel with current timestamp
  2. Adds log to vehicle_logs collection
  3. Updates vehicle status to "inside"
- **Status**: Sets vehicle status as "inside"

##### `endSession(String vehicleID, String updatedBy)`
- **Purpose**: Closes an active vehicle session
- **Process**:
  1. Finds active session (timeOut is null)
  2. Calculates duration in minutes
  3. Updates log with timeOut and duration
  4. Updates vehicle status to "outside"

#### Firebase Collections Used
- `vehicle_logs`: Stores all vehicle log entries
- `vehicles`: Stores vehicle master data and current status

### 3. VehicleLogsCubit

**File**: `lib/features/vehicle_logs_management/bloc/vehicle_logs_cubit.dart`

The business logic component that manages state and coordinates between UI and data layers.

#### State Management
- Uses `VehicleLogsState` to manage:
  - Loading states
  - Error messages
  - Vehicle logs list
  - Bulk mode toggle

#### Stream Subscription Management
- **Field**: `StreamSubscription<List<VehicleLogModel>>? _logsSubscription`
- **Purpose**: Manages real-time log updates from Firestore
- **Lifecycle**: Properly cancelled in `close()` method to prevent memory leaks
- **Safety**: Includes `isClosed` checks before emitting states

#### Key Methods

##### `loadVehicleLogs()`
- **Purpose**: Initializes real-time log streaming
- **Process**:
  1. Cancels existing subscription
  2. Creates new stream subscription
  3. Handles incoming data with isClosed checks
  4. Manages loading states

##### `addManualLog(VehicleLogModel entry)`
- **Purpose**: Adds manual log entries
- **Flow**: Repository call → Reload logs → Update UI
- **Error Handling**: Catches and displays errors via state

##### `startSession(String vehicleID, String updatedBy, Map<String, dynamic> vehicleInfo)`
- **Purpose**: Initiates vehicle entry session
- **Flow**: Repository call → Reload logs → Update UI
- **Loading**: Shows loading indicator during operation

##### `endSession(String vehicleID, String updatedBy)`
- **Purpose**: Terminates active vehicle session
- **Flow**: Repository call → Reload logs → Update UI
- **Loading**: Shows loading indicator during operation

##### `getAvailableVehicles(String query)`
- **Purpose**: Fetches vehicles available for new sessions
- **Returns**: List of vehicle data for dropdowns/selection
- **Error Handling**: Returns empty list on error

#### State Management Methods
- `setLoading(bool isLoading)`: Updates loading state
- `setError(String error)`: Sets error message
- `clearError()`: Clears current error
- `toggleBulkMode()`: Toggles bulk operation mode

#### Memory Management
- **Critical**: Implements proper `close()` method
- **Purpose**: Cancels stream subscriptions to prevent "Cannot emit new states after calling close" errors
- **Pattern**: Follows the same pattern as other cubits in the system

## Data Flow

### 1. Vehicle Entry Process
```
User Action → VehicleLogsCubit.startSession() → VehicleLogsRepository.startSession() 
→ Firestore Write → Stream Update → UI Refresh
```

### 2. Vehicle Exit Process
```
User Action → VehicleLogsCubit.endSession() → VehicleLogsRepository.endSession() 
→ Firestore Update → Stream Update → UI Refresh
```

### 3. Manual Log Addition
```
User Input → VehicleLogsCubit.addManualLog() → VehicleLogsRepository.addManualLog() 
→ Validation → Firestore Write → Stream Update → UI Refresh
```

### 4. Real-time Updates
```
Firestore Change → Stream Emission → VehicleLogsCubit.loadVehicleLogs() 
→ State Update → UI Rebuild
```

## Business Rules

### 1. Active Session Validation
- Only one active session per vehicle allowed
- Active sessions have `timeOut` as null
- New sessions blocked if active session exists

### 2. Status Management
- Vehicle status automatically updated on session start/end
- "inside" status for active sessions
- "outside" status for completed sessions

### 3. Duration Calculation
- Calculated automatically on session end
- Stored in minutes for consistency
- Based on timeIn and timeOut timestamps

### 4. Data Consistency
- Vehicle logs and vehicle status kept in sync
- Atomic operations ensure data integrity
- Error handling prevents partial updates

## Error Handling

### 1. Repository Level
- Uses `FirebaseErrorHandler` for consistent error messages
- Validates business rules before operations
- Throws descriptive exceptions for UI feedback

### 2. Cubit Level
- Catches all repository exceptions
- Updates state with error messages
- Maintains loading states during error scenarios
- Provides error clearing functionality

### 3. Stream Safety
- `isClosed` checks prevent emissions after disposal
- Proper subscription cancellation in `close()`
- Error handling in stream listeners

## Security Considerations

### 1. Data Validation
- Vehicle existence validation before operations
- User authentication required for all operations
- Input sanitization at repository level

### 2. Access Control
- Operations require authenticated user context
- `updatedBy` field tracks operation authors
- Role-based access through authentication system

## Performance Optimizations

### 1. Real-time Updates
- Stream-based architecture for efficient updates
- Firestore queries optimized with proper indexing
- Minimal data transfer with targeted queries

### 2. Memory Management
- Proper stream subscription lifecycle management
- State emission guards prevent memory leaks
- Efficient data structures for large datasets

### 3. Query Optimization
- Indexed queries for vehicle status filtering
- Ordered results for chronological display
- Limit clauses for pagination support

## Integration Points

### 1. Authentication System
- Uses authenticated user context for operations
- Integrates with existing auth repositories
- Maintains audit trail with user information

### 2. Vehicle Management
- Reads from vehicles collection for master data
- Updates vehicle status for consistency
- Validates vehicle existence before operations

### 3. Firebase Services
- Firestore for data persistence
- Real-time listeners for live updates
- Timestamp services for accurate timing

## Future Enhancements

### 1. Batch Operations
- Bulk session management
- Mass data import/export
- Batch status updates

### 2. Advanced Analytics
- Duration analysis and reporting
- Peak usage time identification
- Vehicle utilization metrics

### 3. Notification System
- Real-time alerts for long sessions
- Automated reminders for vehicle exits
- Status change notifications

## Troubleshooting

### Common Issues

1. **"Cannot emit new states after calling close" Error**
   - **Cause**: Stream subscriptions continuing after cubit disposal
   - **Solution**: Ensure proper `close()` implementation with subscription cancellation

2. **Active Session Conflicts**
   - **Cause**: Multiple active sessions for same vehicle
   - **Solution**: Validation in `addManualLog()` prevents this scenario

3. **Real-time Updates Not Working**
   - **Cause**: Stream subscription not properly initialized
   - **Solution**: Call `loadVehicleLogs()` after cubit initialization

4. **Memory Leaks**
   - **Cause**: Uncancelled stream subscriptions
   - **Solution**: Implement proper disposal pattern in cubit `close()` method

## Testing Considerations

### Unit Tests
- Repository methods with mock Firestore
- Cubit state transitions and error handling
- Model serialization/deserialization

### Integration Tests
- End-to-end session management flows
- Real-time update propagation
- Error scenario handling

### Performance Tests
- Large dataset handling
- Concurrent session management
- Memory usage monitoring

---

*This documentation reflects the current implementation of the Vehicle Logging System in CVMS v1.0. For updates and modifications, please refer to the latest codebase and maintain this documentation accordingly.*
