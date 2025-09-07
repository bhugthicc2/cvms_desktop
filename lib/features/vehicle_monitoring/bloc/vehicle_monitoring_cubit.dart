import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/vehicle_monitoring_entry.dart';
import 'vehicle_monitoring_state.dart';

class VehicleMonitoringCubit extends Cubit<VehicleMonitoringState> {
  VehicleMonitoringCubit() : super(const VehicleMonitoringState());

  void loadEntries(List<VehicleMonitoringEntry> entries) {
    final enteredEntries =
        entries.where((entry) => entry.status == "inside").toList();
    final exitedEntries =
        entries.where((entry) => entry.status == "outside").toList();

    emit(
      state.copyWith(
        allEntries: entries,
        enteredFiltered: enteredEntries,
        exitedFiltered: exitedEntries,
      ),
    );
  }

  void filterEntered(String query) {
    if (query.isEmpty) {
      final enteredEntries =
          state.allEntries.where((entry) => entry.status == "inside").toList();
      emit(state.copyWith(enteredFiltered: enteredEntries));
      return;
    }

    final filtered =
        state.allEntries
            .where(
              (entry) =>
                  entry.status == "inside" &&
                  (entry.name.toLowerCase().contains(query.toLowerCase()) ||
                      entry.vehicle.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ||
                      entry.plateNumber.toLowerCase().contains(
                        query.toLowerCase(),
                      )),
            )
            .toList();

    emit(state.copyWith(enteredFiltered: filtered));
  }

  void filterExited(String query) {
    if (query.isEmpty) {
      final exitedEntries =
          state.allEntries.where((entry) => entry.status == "outside").toList();
      emit(state.copyWith(exitedFiltered: exitedEntries));
      return;
    }

    final filtered =
        state.allEntries
            .where(
              (entry) =>
                  entry.status == "outside" &&
                  (entry.name.toLowerCase().contains(query.toLowerCase()) ||
                      entry.vehicle.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ||
                      entry.plateNumber.toLowerCase().contains(
                        query.toLowerCase(),
                      )),
            )
            .toList();

    emit(state.copyWith(exitedFiltered: filtered));
  }

  void setLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  void setError(String error) {
    emit(state.copyWith(error: error, isLoading: false));
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }
}
