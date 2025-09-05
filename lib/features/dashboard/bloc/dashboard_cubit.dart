import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/vehicle_entry.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardState.initial());

  void loadEntries(List<VehicleEntry> entries) {
    emit(
      state.copyWith(
        allEntries: entries,
        enteredFiltered: entries.where((e) => e.status == "inside").toList(),
        exitedFiltered: entries.where((e) => e.status == "outside").toList(),
      ),
    );
  }

  void filterEntered(String query) {
    final filtered =
        state.allEntries
            .where(
              (e) =>
                  e.status == "inside" &&
                  (e.name.toLowerCase().contains(query.toLowerCase()) ||
                      e.vehicle.toLowerCase().contains(query.toLowerCase()) ||
                      e.plateNumber.toLowerCase().contains(
                        query.toLowerCase(),
                      )),
            )
            .toList();

    emit(state.copyWith(enteredFiltered: filtered));
  }

  void filterExited(String query) {
    final filtered =
        state.allEntries
            .where(
              (e) =>
                  e.status == "outside" &&
                  (e.name.toLowerCase().contains(query.toLowerCase()) ||
                      e.vehicle.toLowerCase().contains(query.toLowerCase()) ||
                      e.plateNumber.toLowerCase().contains(
                        query.toLowerCase(),
                      )),
            )
            .toList();

    emit(state.copyWith(exitedFiltered: filtered));
  }
}
