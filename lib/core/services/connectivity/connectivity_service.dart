import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityService {
  final InternetConnection _checker;
  final Duration _initialTimeout; // For initial check timeout

  ConnectivityService({InternetConnection? checker, Duration? initialTimeout})
    : _checker = checker ?? InternetConnection(),
      _initialTimeout = initialTimeout ?? const Duration(seconds: 5);

  Stream<InternetStatus> get status async* {
    // Initial "checking" state
    yield InternetStatus.disconnected;

    // Listen to the package's real-time stream
    // It emits immediately with current status
    await for (final packageStatus in _checker.onStatusChange) {
      final mappedStatus = _mapToAppStatus(packageStatus);
      yield mappedStatus;
    }
  }

  InternetStatus _mapToAppStatus(InternetStatus packageStatus) {
    switch (packageStatus) {
      case InternetStatus.connected:
        return InternetStatus.connected;
      case InternetStatus.disconnected:
        return InternetStatus.disconnected;
    }
  }

  // Optional: Manual one-time check (e.g., on app resume)
  Future<InternetStatus> checkConnection() async {
    final hasConnection = await _checker.hasInternetAccess;
    return hasConnection
        ? InternetStatus.connected
        : InternetStatus.disconnected;
  }
}
