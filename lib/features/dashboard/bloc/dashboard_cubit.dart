import 'dart:async';
import 'package:cvms_desktop/features/dashboard/data/dashboard_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/vehicle_entry.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository repository;
  StreamSubscription? _subscription;
  StreamSubscription? _violationsSub;
  StreamSubscription? _logsSub;

  DashboardCubit(this.repository) : super(DashboardState.initial());

  void startListening() {
    //  vehicle logs stream
    _logsSub = repository.streamVehicleLogs().listen((entries) {
      emit(
        state.copyWith(
          allEntries: entries,
          enteredFiltered: entries.where((e) => e.status == "inside").toList(),
          exitedFiltered: entries.where((e) => e.status == "outside").toList(),
        ),
      );
    });

    // violations stream
    _violationsSub = repository.streamTotalViolations().listen((count) {
      emit(state.copyWith(totalViolations: count));
    });

    //  vehicles (can also make reactive the same way if you want)
    repository.getTotalVehicles().then((count) {
      emit(state.copyWith(totalVehicles: count));
    });
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

  @override
  Future<void> close() {
    _logsSub?.cancel();
    _violationsSub?.cancel();
    return super.close();
  }
}
