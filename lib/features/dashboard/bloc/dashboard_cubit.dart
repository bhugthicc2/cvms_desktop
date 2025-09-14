import 'dart:async';
import 'package:cvms_desktop/features/dashboard/data/dashboard_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/vehicle_entry.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository repository;
  StreamSubscription? _subscription;

  DashboardCubit(this.repository) : super(DashboardState.initial());

  void startListening() {
    _subscription = repository.streamVehicleLogs().listen((entries) {
      emit(
        state.copyWith(
          allEntries: entries,
          enteredFiltered: entries.where((e) => e.status == "inside").toList(),
          exitedFiltered: entries.where((e) => e.status == "outside").toList(),
        ),
      );
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
    _subscription?.cancel();
    return super.close();
  }
}
