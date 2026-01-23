import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../../../core/services/connectivity/connectivity_service.dart';

class ConnectivityCubit extends Cubit<InternetStatus> {
  final ConnectivityService _service;
  late StreamSubscription<InternetStatus>
  _subscription; // Made non-nullable with 'late'

  ConnectivityCubit(this._service) : super(InternetStatus.disconnected) {
    _subscription = _service.status.listen(emit);
  }

  // Optional: Re-check on app resume/focus (e.g., call from a listener)
  Future<void> refresh() async {
    final status = await _service.checkConnection();
    emit(status);
  }

  @override
  Future<void> close() {
    _subscription.cancel(); // No ? needed now
    return super.close();
  }
}
