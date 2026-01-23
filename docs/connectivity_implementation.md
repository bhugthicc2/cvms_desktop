# Connectivity Checker Implementation

## Overview

The CVMS application includes a real-time connectivity monitoring system that tracks internet connection status and provides visual feedback to users. This implementation uses the `internet_connection_checker_plus` package combined with a custom BLoC architecture for state management.

## Architecture

### Core Components

1. **ConnectivityService** (`lib/core/services/connectivity/connectivity_service.dart`)
   - Handles low-level internet connection checking
   - Provides real-time status streams
   - Wraps the `internet_connection_checker_plus` package

2. **ConnectivityCubit** (`lib/features/shell/bloc/connectivity_cubit.dart`)
   - Manages connectivity state using BLoC pattern
   - Provides reactive state updates to UI components
   - Handles subscription lifecycle management

3. **CustomHeader Widget** (`lib/features/shell/widgets/custom_header.dart`)
   - Displays connectivity status with visual indicators
   - Shows online/offline status with appropriate icons and colors

## Implementation Details

### 1. ConnectivityService

```dart
class ConnectivityService {
  final InternetConnection _checker;
  final Duration _initialTimeout;

  Stream<InternetStatus> get status async* {
    yield InternetStatus.disconnected; // Initial state
    await for (final packageStatus in _checker.onStatusChange) {
      final mappedStatus = _mapToAppStatus(packageStatus);
      yield mappedStatus;
    }
  }
}
```

**Key Features:**

- Provides real-time connection status stream
- Maps package status to app-specific enum
- Includes initial timeout for connection checks
- Handles manual connection checks on app resume

### 2. ConnectivityCubit

```dart
class ConnectivityCubit extends Cubit<InternetStatus> {
  final ConnectivityService _service;
  late StreamSubscription<InternetStatus> _subscription;

  ConnectivityCubit(this._service) : super(InternetStatus.disconnected) {
    _subscription = _service.status.listen(emit);
  }

  Future<void> refresh() async {
    final status = await _service.checkConnection();
    emit(status);
  }
}
```

**Key Features:**

- Reactive state management with BLoC pattern
- Automatic stream subscription management
- Manual refresh capability
- Proper cleanup in `close()` method

### 3. UI Integration

The connectivity status is displayed in the `CustomHeader` widget:

```dart
BlocBuilder<ConnectivityCubit, InternetStatus>(
  builder: (context, status) {
    IconData icon;
    Color color;
    String tooltip;

    switch (status) {
      case InternetStatus.connected:
        icon = PhosphorIconsRegular.wifiHigh;
        color = AppColors.chartGreen;
        tooltip = 'Online';
        break;
      case InternetStatus.disconnected:
        icon = PhosphorIconsRegular.wifiSlash;
        color = AppColors.error;
        tooltip = 'Offline';
        break;
    }

    return Tooltip(
      message: tooltip,
      child: Icon(icon, size: 20, color: color),
    );
  },
)
```

## App Lifecycle Integration

The connectivity checker integrates with app lifecycle events to refresh connection status when the app resumes:

```dart
class _CVMSAppState extends State<CVMSApp> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<ConnectivityCubit>().refresh();
    }
  }
}
```

## Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  internet_connection_checker_plus: ^2.7.2
  flutter_bloc: ^8.1.3
```

## Setup Instructions

### 1. Create ConnectivityService

Create `lib/core/services/connectivity/connectivity_service.dart` with the service implementation.

### 2. Create ConnectivityCubit

Create `lib/features/shell/bloc/connectivity_cubit.dart` with the BLoC implementation.

### 3. Provide ConnectivityCubit

Add the `ConnectivityCubit` to your app's BLoC provider tree:

```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (context) => ConnectivityCubit(ConnectivityService())),
    // ... other providers
  ],
  child: MaterialApp(...),
)
```

### 4. Update UI Components

Add the connectivity status indicator to your header or appropriate UI component using `BlocBuilder<ConnectivityCubit, InternetStatus>`.

## Status Types

The system uses two status values:

- **`InternetStatus.connected`**: Device has internet access
  - Icon: WiFi high signal
  - Color: Green (`AppColors.chartGreen`)
  - Tooltip: "Online"

- **`InternetStatus.disconnected`**: Device has no internet access
  - Icon: WiFi slash
  - Color: Red (`AppColors.error`)
  - Tooltip: "Offline"

## Error Handling

The implementation includes proper error handling:

1. **Stream subscription management**: Automatically cancels subscriptions when cubit is disposed
2. **Connection timeout**: Includes timeout for initial connection checks
3. **Graceful degradation**: Shows disconnected status during initial checks

## Performance Considerations

1. **Real-time updates**: Uses package's built-in stream for efficient real-time monitoring
2. **Minimal overhead**: Only subscribes to connection status changes
3. **Proper cleanup**: Cancels subscriptions to prevent memory leaks
4. **App lifecycle integration**: Refreshes status only when app resumes

## Troubleshooting

### Common Issues

1. **Type mismatch errors**: Ensure all files import the same `InternetStatus` from `internet_connection_checker_plus`
2. **Provider not found**: Make sure `ConnectivityCubit` is provided in the widget tree above where it's used
3. **Status not updating**: Check that the BLoC provider is properly configured and the widget is rebuilt with `BlocBuilder`

### Debug Tips

1. Add print statements in `ConnectivityCubit` to track state changes
2. Use Flutter DevTools to monitor BLoC state changes
3. Test with different network conditions (airplane mode, WiFi off, etc.)

## Future Enhancements

Potential improvements to consider:

1. **Connection quality indicators**: Show signal strength or connection speed
2. **Offline mode**: Implement offline data synchronization
3. **Custom notifications**: Show toast messages for connection changes
4. **Retry logic**: Implement automatic reconnection attempts
5. **Connection type detection**: Differentiate between WiFi and mobile data

## Files Summary

- `lib/core/services/connectivity/connectivity_service.dart` - Core connectivity service
- `lib/features/shell/bloc/connectivity_cubit.dart` - BLoC state management
- `lib/features/shell/widgets/custom_header.dart` - UI status indicator
- `lib/core/app/cvms_app.dart` - App lifecycle integration
- `pubspec.yaml` - Package dependencies
