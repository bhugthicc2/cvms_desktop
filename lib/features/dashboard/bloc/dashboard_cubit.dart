import 'dart:async';
import 'package:cvms_desktop/features/dashboard/data/dashboard_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/vehicle_entry.dart';
import '../models/violation_model.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository repository;
  StreamSubscription? _violationsSub;
  StreamSubscription? _logsSub;

  DashboardCubit(this.repository) : super(DashboardState.initial());

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
    //  vehicle logs stream
    _logsSub = repository.streamVehicleLogs().listen((entries) {
      if (!isClosed) {
        emit(
          state.copyWith(
            allEntries: entries,
            enteredFiltered:
                entries.where((e) => e.status == "inside").toList(),
            exitedFiltered:
                entries.where((e) => e.status == "outside").toList(),
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
        await repository.updateVehicleStatusAndLogs(
          vehicleId: id,
          newStatus: newStatus,
          updatedBy: 'dashboard',
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

  Future<String> reportViolation(ViolationModel violation) async {
    return repository.reportViolation(violation);
  }

  void filterEntered(String query) {
    final filtered =
        state.allEntries.where((e) {
          return e.status == "inside" &&
              (e.ownerName.toLowerCase().contains(query.toLowerCase()) ||
                  e.vehicleModel.toLowerCase().contains(query.toLowerCase()) ||
                  e.plateNumber.toLowerCase().contains(query.toLowerCase()));
        }).toList();

    emit(state.copyWith(enteredFiltered: filtered));
  }

  void filterExited(String query) {
    final filtered =
        state.allEntries.where((e) {
          return e.status == "outside" &&
              (e.ownerName.toLowerCase().contains(query.toLowerCase()) ||
                  e.vehicleModel.toLowerCase().contains(query.toLowerCase()) ||
                  e.plateNumber.toLowerCase().contains(query.toLowerCase()));
        }).toList();

    emit(state.copyWith(exitedFiltered: filtered));
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
