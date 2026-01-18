# Real-Time Data Layer Architecture

## 🚀 Overview

This document outlines the scalable and efficient data layer architecture for implementing real-time updates in the CVMS Dashboard. The architecture follows clean architecture principles with Repository pattern, reactive streams, and efficient caching.

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────┐
│           UI Layer                 │
│    (DashboardPage, Views)          │
└─────────────┬─────────────────────┘
              │ Stream/BLoC
┌─────────────▼─────────────────────┐
│        Business Logic              │
│    (DashboardCubit, Services)      │
└─────────────┬─────────────────────┘
              │ Repository Interface
┌─────────────▼─────────────────────┐
│       Data Layer                  │
│   (Repository, Cache, WebSocket)   │
└─────────────┬─────────────────────┘
              │ API/WebSocket
┌─────────────▼─────────────────────┐
│        Data Sources               │
│   (REST API, WebSocket, Local DB)  │
└─────────────────────────────────────┘
```

## 🎯 Implementation Plan

### Phase 1: Repository Pattern (High Priority)

#### Repository Interface

```dart
// lib/features/dashboard2/repositories/dashboard_repository.dart
abstract class DashboardRepository {
  // Real-time streams
  Stream<List<Violation>> get violationsStream;
  Stream<List<Vehicle>> get vehiclesStream;
  Stream<FleetSummary> get fleetSummaryStream;
  Stream<List<ChartDataModel>> get violationDistributionStream;
  Stream<List<ChartDataModel>> get vehicleLogsStream;

  // Data operations
  Future<void> refreshData();
  Future<void> subscribeToRealTimeUpdates();
  Future<void> unsubscribeFromRealTimeUpdates();

  // Cache operations
  Future<List<Violation>> getCachedViolations();
  Future<List<Vehicle>> getCachedVehicles();
  Future<FleetSummary> getCachedFleetSummary();
}
```

#### Concrete Implementation

```dart
// lib/features/dashboard2/repositories/dashboard_repository_impl.dart
class DashboardRepositoryImpl implements DashboardRepository {
  final WebSocketService _webSocketService;
  final CacheService _cacheService;
  final ApiClient _apiClient;

  // Stream controllers for real-time updates
  final _violationsController = StreamController<List<Violation>>.broadcast();
  final _vehiclesController = StreamController<List<Vehicle>>.broadcast();
  final _fleetSummaryController = StreamController<FleetSummary>.broadcast();
  final _violationDistributionController = StreamController<List<ChartDataModel>>.broadcast();
  final _vehicleLogsController = StreamController<List<ChartDataModel>>.broadcast();

  @override
  Stream<List<Violation>> get violationsStream => _violationsController.stream;
  @override
  Stream<List<Vehicle>> get vehiclesStream => _vehiclesController.stream;
  @override
  Stream<FleetSummary> get fleetSummaryStream => _fleetSummaryController.stream;
  @override
  Stream<List<ChartDataModel>> get violationDistributionStream => _violationDistributionController.stream;
  @override
  Stream<List<ChartDataModel>> get vehicleLogsStream => _vehicleLogsController.stream;

  DashboardRepositoryImpl({
    required WebSocketService webSocketService,
    required CacheService cacheService,
    required ApiClient apiClient,
  }) : _webSocketService = webSocketService,
       _cacheService = cacheService,
       _apiClient = apiClient;

  @override
  Future<void> subscribeToRealTimeUpdates() async {
    // Listen to WebSocket messages
    _webSocketService.messageStream.listen(_handleRealTimeMessage);

    // Listen to cache updates
    _cacheService.updateStream.listen(_handleCacheUpdate);
  }

  void _handleRealTimeMessage(Map<String, dynamic> message) {
    final type = message['type'] as String;
    final data = message['data'];

    switch (type) {
      case 'violations_update':
        final violations = (data as List).map((e) => Violation.fromJson(e)).toList();
        _cacheService.set('violations', violations);
        _violationsController.add(violations);
        break;

      case 'vehicles_update':
        final vehicles = (data as List).map((e) => Vehicle.fromJson(e)).toList();
        _cacheService.set('vehicles', vehicles);
        _vehiclesController.add(vehicles);
        break;

      case 'fleet_summary_update':
        final summary = FleetSummary.fromJson(data);
        _cacheService.set('fleet_summary', summary);
        _fleetSummaryController.add(summary);
        break;

      case 'violation_distribution_update':
        final distribution = (data as List).map((e) => ChartDataModel.fromJson(e)).toList();
        _cacheService.set('violation_distribution', distribution);
        _violationDistributionController.add(distribution);
        break;

      case 'vehicle_logs_update':
        final logs = (data as List).map((e) => ChartDataModel.fromJson(e)).toList();
        _cacheService.set('vehicle_logs', logs);
        _vehicleLogsController.add(logs);
        break;
    }
  }

  void _handleCacheUpdate(Map<String, dynamic> update) {
    // Handle cache updates and propagate to streams if needed
    final key = update.keys.first;
    final value = update[key];

    switch (key) {
      case 'violations':
        _violationsController.add(value as List<Violation>);
        break;
      case 'vehicles':
        _vehiclesController.add(value as List<Vehicle>);
        break;
      case 'fleet_summary':
        _fleetSummaryController.add(value as FleetSummary);
        break;
      // ... other cases
    }
  }
}
```

### Phase 2: WebSocket Service (High Priority)

#### WebSocket Implementation

```dart
// lib/features/dashboard2/services/websocket_service.dart
class WebSocketService {
  WebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _messageController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<WebSocketState> _stateController =
      StreamController<WebSocketState>.broadcast();

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  Stream<WebSocketState> get stateStream => _stateController.stream;

  bool get isConnected => _channel != null;

  Future<void> connect(String url) async {
    try {
      _stateController.add(WebSocketState.connecting);

      _channel = WebSocketChannel.connect(Uri.parse(url));

      _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDone,
      );

      _stateController.add(WebSocketState.connected);
    } catch (e) {
      _stateController.add(WebSocketState.error(e.toString()));
      await _reconnect();
    }
  }

  void _handleMessage(dynamic message) {
    try {
      final data = jsonDecode(message as String);
      _messageController.add(data);
    } catch (e) {
      _stateController.add(WebSocketState.error('Failed to parse message: $e'));
    }
  }

  void _handleError(dynamic error) {
    _stateController.add(WebSocketState.error(error.toString()));
  }

  void _handleDone() {
    _stateController.add(WebSocketState.disconnected);
    _channel = null;
    _reconnect();
  }

  Future<void> _reconnect() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!isConnected) {
      // Attempt reconnection
      // connect(originalUrl);
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    _stateController.add(WebSocketState.disconnected);
  }

  void sendMessage(Map<String, dynamic> message) {
    if (isConnected) {
      _channel!.sink.add(jsonEncode(message));
    }
  }
}

enum WebSocketState {
  connecting,
  connected,
  disconnected,
  error(String message),
}
```

### Phase 3: Cache Layer (High Priority)

#### Cache Service Implementation

```dart
// lib/features/dashboard2/services/cache_service.dart
class CacheService {
  final Map<String, dynamic> _cache = {};
  final Map<String, DateTime> _timestamps = {};
  final StreamController<Map<String, dynamic>> _updateController =
      StreamController<Map<String, dynamic>>.broadcast();
  final Duration _defaultTtl = const Duration(minutes: 5);

  Stream<Map<String, dynamic>> get updateStream => _updateController.stream;

  T? get<T>(String key, {Duration? ttl}) {
    final value = _cache[key] as T?;
    if (value == null) return null;

    final timestamp = _timestamps[key];
    final effectiveTtl = ttl ?? _defaultTtl;

    if (timestamp != null && DateTime.now().difference(timestamp) > effectiveTtl) {
      _cache.remove(key);
      _timestamps.remove(key);
      return null;
    }

    return value;
  }

  void set<T>(String key, T value) {
    _cache[key] = value;
    _timestamps[key] = DateTime.now();
    _updateController.add({key: value});
  }

  void remove(String key) {
    _cache.remove(key);
    _timestamps.remove(key);
    _updateController.add({key: null});
  }

  void clear() {
    _cache.clear();
    _timestamps.clear();
    _updateController.add({'all': null});
  }

  bool isExpired(String key, {Duration? ttl}) {
    final timestamp = _timestamps[key];
    if (timestamp == null) return true;

    final effectiveTtl = ttl ?? _defaultTtl;
    return DateTime.now().difference(timestamp) > effectiveTtl;
  }

  Map<String, dynamic> getAll() => Map.unmodifiable(_cache);

  void dispose() {
    _updateController.close();
  }
}
```

### Phase 4: Cubit Integration (Medium Priority)

#### Updated Dashboard Cubit

```dart
// lib/features/dashboard2/bloc/dashboard_cubit.dart
class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _repository;
  StreamSubscription<List<Violation>>? _violationsSubscription;
  StreamSubscription<List<Vehicle>>? _vehiclesSubscription;
  StreamSubscription<FleetSummary>? _fleetSummarySubscription;
  StreamSubscription<List<ChartDataModel>>? _violationDistributionSubscription;
  StreamSubscription<List<ChartDataModel>>? _vehicleLogsSubscription;

  DashboardCubit(this._repository) : super(const DashboardState()) {
    _subscribeToRealTimeUpdates();
    _loadInitialData();
  }

  void _subscribeToRealTimeUpdates() {
    // Listen to violations
    _violationsSubscription = _repository.violationsStream.listen(
      (violations) => emit(state.copyWith(violations: violations)),
      onError: (error) => setError('Violations stream error: $error'),
    );

    // Listen to vehicles
    _vehiclesSubscription = _repository.vehiclesStream.listen(
      (vehicles) => emit(state.copyWith(vehicles: vehicles)),
      onError: (error) => setError('Vehicles stream error: $error'),
    );

    // Listen to fleet summary
    _fleetSummarySubscription = _repository.fleetSummaryStream.listen(
      (summary) => emit(state.copyWith(fleetSummary: summary)),
      onError: (error) => setError('Fleet summary stream error: $error'),
    );

    // Listen to violation distribution
    _violationDistributionSubscription = _repository.violationDistributionStream.listen(
      (distribution) => emit(state.copyWith(violationDistribution: distribution)),
      onError: (error) => setError('Violation distribution stream error: $error'),
    );

    // Listen to vehicle logs
    _vehicleLogsSubscription = _repository.vehicleLogsStream.listen(
      (logs) => emit(state.copyWith(vehicleLogs: logs)),
      onError: (error) => setError('Vehicle logs stream error: $error'),
    );
  }

  Future<void> _loadInitialData() async {
    setLoading(true);
    try {
      // Load cached data first
      final cachedViolations = await _repository.getCachedViolations();
      final cachedVehicles = await _repository.getCachedVehicles();
      final cachedSummary = await _repository.getCachedFleetSummary();

      emit(state.copyWith(
        violations: cachedViolations,
        vehicles: cachedVehicles,
        fleetSummary: cachedSummary,
      ));

      // Then refresh from server
      await _repository.refreshData();
      await _repository.subscribeToRealTimeUpdates();
    } catch (e) {
      setError('Failed to load initial data: $e');
    } finally {
      setLoading(false);
    }
  }

  @override
  Future<void> close() {
    _violationsSubscription?.cancel();
    _vehiclesSubscription?.cancel();
    _fleetSummarySubscription?.cancel();
    _violationDistributionSubscription?.cancel();
    _vehicleLogsSubscription?.cancel();

    _repository.unsubscribeFromRealTimeUpdates();
    return super.close();
  }
}
```

### Phase 5: Updated State Model (Medium Priority)

#### Enhanced Dashboard State

```dart
// lib/features/dashboard2/bloc/dashboard_state.dart
class DashboardState extends Equatable {
  final DashboardViewMode viewMode;
  final bool loading;
  final String? error;
  final IndividualVehicleReport? selectedVehicle;
  final DashboardViewMode? previousViewMode;

  // Real-time data
  final List<Violation>? violations;
  final List<Vehicle>? vehicles;
  final FleetSummary? fleetSummary;
  final List<ChartDataModel>? violationDistribution;
  final List<ChartDataModel>? vehicleLogs;

  const DashboardState({
    this.viewMode = DashboardViewMode.global,
    this.loading = false,
    this.error,
    this.selectedVehicle,
    this.previousViewMode,
    this.violations,
    this.vehicles,
    this.fleetSummary,
    this.violationDistribution,
    this.vehicleLogs,
  });

  DashboardState copyWith({
    DashboardViewMode? viewMode,
    bool? loading,
    String? error,
    IndividualVehicleReport? selectedVehicle,
    DashboardViewMode? previousViewMode,
    List<Violation>? violations,
    List<Vehicle>? vehicles,
    FleetSummary? fleetSummary,
    List<ChartDataModel>? violationDistribution,
    List<ChartDataModel>? vehicleLogs,
  }) {
    return DashboardState(
      viewMode: viewMode ?? this.viewMode,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
      previousViewMode: previousViewMode ?? this.previousViewMode,
      violations: violations ?? this.violations,
      vehicles: vehicles ?? this.vehicles,
      fleetSummary: fleetSummary ?? this.fleetSummary,
      violationDistribution: violationDistribution ?? this.violationDistribution,
      vehicleLogs: vehicleLogs ?? this.vehicleLogs,
    );
  }

  @override
  List<Object?> get props => [
    viewMode, loading, error, selectedVehicle, previousViewMode,
    violations, vehicles, fleetSummary, violationDistribution, vehicleLogs,
  ];
}
```

## 🔄 Real-Time Update Flow

### Data Update Pipeline

```
WebSocket Message → Repository → Cache → Stream → Cubit → UI
     ↓              ↓          ↓        ↓      ↓
  Raw Data    → Process → Cache → Stream → State → Rebuild
```

### Update Types

1. **Incremental Updates** → Single item changes
2. **Batch Updates** → Multiple items changed
3. **Full Refresh** → Complete data reload
4. **Connection Events** → Connect/disconnect status

## 🎯 Benefits

### ✅ Efficiency

- **Selective Updates** → Only affected UI parts rebuild
- **Stream-based** → No polling, push-based updates
- **Intelligent Caching** → Reduces API calls, improves performance
- **Connection Management** → Automatic reconnection, error handling

### ✅ Scalability

- **Repository Pattern** → Easy to swap data sources
- **Stream Architecture** → Handles multiple concurrent updates
- **Modular Design** → Each component has single responsibility
- **Type Safety** → Strong typing with Dart streams

### ✅ Maintainability

- **Clear Separation** → UI, business logic, data layer separated
- **Testable** → Each layer can be unit tested independently
- **Observable** → Easy debugging with stream tracing
- **Extensible** → Simple to add new data types and update handlers

## 🚀 Implementation Strategy

### Step 1: Create Repository Interface

```dart
// lib/features/dashboard2/repositories/dashboard_repository.dart
abstract class DashboardRepository {
  // Define all stream and method signatures
}
```

### Step 2: Implement WebSocket Service

```dart
// lib/features/dashboard2/services/websocket_service.dart
class WebSocketService {
  // WebSocket connection and message handling
}
```

### Step 3: Create Cache Service

```dart
// lib/features/dashboard2/services/cache_service.dart
class CacheService {
  // In-memory caching with TTL
}
```

### Step 4: Implement Repository

```dart
// lib/features/dashboard2/repositories/dashboard_repository_impl.dart
class DashboardRepositoryImpl implements DashboardRepository {
  // Combine WebSocket, cache, and API
}
```

### Step 5: Update Cubit

```dart
// Update existing DashboardCubit to use repository
class DashboardCubit extends Cubit<DashboardState> {
  // Stream subscriptions and state management
}
```

### Step 6: Update State Model

```dart
// Add real-time data fields to DashboardState
class DashboardState extends Equatable {
  // Add violations, vehicles, fleetSummary, etc.
}
```

## 📋 Next Steps

1. **Start with Repository Pattern** → Provides foundation for data layer
2. **Implement WebSocket Service** → Enables real-time communication
3. **Add Cache Layer** → Improves performance and offline support
4. **Integrate with Cubit** → Connects data layer to UI
5. **Update Views** → Use real-time data in UI components
6. **Add Error Handling** → Robust error management
7. **Implement Testing** → Unit tests for each layer

## 🔧 Configuration

### WebSocket Configuration

```dart
class WebSocketConfig {
  static const String baseUrl = 'ws://localhost:8080';
  static const Duration reconnectDelay = Duration(seconds: 3);
  static const int maxReconnectAttempts = 5;
}
```

### Cache Configuration

```dart
class CacheConfig {
  static const Duration defaultTtl = Duration(minutes: 5);
  static const int maxCacheSize = 1000;
  static const Duration cleanupInterval = Duration(minutes: 10);
}
```

This architecture provides a solid foundation for real-time data updates in the CVMS Dashboard, ensuring efficiency, scalability, and maintainability.
