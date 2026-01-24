import 'dart:async';
import 'package:cvms_desktop/features/auth/data/auth_repository.dart';
import 'package:cvms_desktop/features/vehicle_monitoring/data/vehicle_monitoring_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/vehicle_entry.dart';

part 'vehicle_monitoring_state.dart';

class VehicleMonitoringCubit extends Cubit<VehicleMonitoringState> {
  final DashboardRepository repository;
  final AuthRepository _authRepository = AuthRepository();
  StreamSubscription? _violationsSub;
  StreamSubscription? _logsSub;

  VehicleMonitoringCubit(this.repository)
    : super(VehicleMonitoringState.initial());

  Future<void> _refreshVehicleCounts() async {
    try {
      final entered = await repository.getTotalEnteredVehicles();
      final exited = await repository.getTotalExitedVehicles();
      if (!isClosed) {
        emit(state.copyWith(totalEntered: entered, totalExited: exited));
      }
    } catch (_) {
      // ignore
    }
  }

  void startListening() {
    emit(state.copyWith(loading: true));

    //  vehicle logs stream
    _logsSub = repository.streamVehicleLogs().listen((entries) {
      if (!isClosed) {
        emit(
          state.copyWith(
            loading: false,
            allEntries: entries,
            enteredFiltered:
                entries
                    .where((e) => e.status == "inside" || e.status == "onsite")
                    .toList(),
            exitedFiltered:
                entries
                    .where(
                      (e) => e.status == "outside" || e.status == "offsite",
                    )
                    .toList(),
          ),
        );

        _refreshVehicleCounts();
      }
    });

    // violations stream
    _violationsSub = repository.streamTotalViolations().listen((count) {
      if (!isClosed) {
        emit(state.copyWith(totalViolations: count));
      }
    });

    repository.getTotalVehicles().then((count) {
      if (!isClosed) {
        emit(state.copyWith(totalVehicles: count));
      }
    });

    // Initial fetch for entered/exited counts from vehicles collection
    _refreshVehicleCounts();
  }

  Future<void> updateVehicle(String id, Map<String, dynamic> updates) async {
    try {
      if (id.trim().isEmpty) {
        return; // guard
      }

      if (updates.containsKey('status')) {
        final String newStatus = (updates['status'] as String).toLowerCase();

        final currentUserId = _authRepository.uid ?? 'Unknown';
        await repository.updateVehicleStatusAndLogs(
          vehicleId: id,
          newStatus: newStatus,
          updatedByUserId: currentUserId,
        );
      } else {
        await repository.updateVehicle(id, updates);
      }

      await _refreshVehicleCounts();
    } catch (e) {
      //todo add error handling
    }
  }

  Future<Map<String, dynamic>> getVehicleById(String id) async {
    return repository.getVehicleById(id);
  }

  void filterEntered(String query) {
    final filtered =
        state.allEntries.where((e) {
          return (e.status == "inside" || e.status == "onsite") &&
              (e.ownerName.toLowerCase().contains(query.toLowerCase()) ||
                  e.vehicleModel.toLowerCase().contains(query.toLowerCase()) ||
                  e.plateNumber.toLowerCase().contains(query.toLowerCase()));
        }).toList();

    emit(state.copyWith(enteredFiltered: filtered, loading: false));
  }

  void filterExited(String query) {
    final filtered =
        state.allEntries.where((e) {
          return (e.status == "outside" || e.status == "offsite") &&
              (e.ownerName.toLowerCase().contains(query.toLowerCase()) ||
                  e.vehicleModel.toLowerCase().contains(query.toLowerCase()) ||
                  e.plateNumber.toLowerCase().contains(query.toLowerCase()));
        }).toList();

    emit(state.copyWith(exitedFiltered: filtered, loading: false));
  }

  Future<void> deleteVehicleLog(String docId) async {
    try {
      await repository.deleteVehicleLog(docId);
    } catch (e) {
      //Todo You could show a snackbar or log error
    }
  }

  @override
  Future<void> close() {
    _logsSub?.cancel();
    _violationsSub?.cancel();
    return super.close();
  }
}
