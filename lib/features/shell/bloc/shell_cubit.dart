import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/navigation_guard.dart';
import '../../dashboard/data/firestore_analytics_repository.dart';
import '../../dashboard/data/analytics_repository.dart';

class ShellState {
  final bool isExpanded;
  final int selectedIndex;

  ShellState({this.isExpanded = true, this.selectedIndex = 0});

  ShellState copyWith({bool? isExpanded, int? selectedIndex}) {
    return ShellState(
      isExpanded: isExpanded ?? this.isExpanded,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

class ShellCubit extends Cubit<ShellState> {
  // Shared analytics repository instance
  late final AnalyticsRepository _sharedAnalyticsRepository;

  ShellCubit() : super(ShellState()) {
    _sharedAnalyticsRepository = FirestoreAnalyticsRepository();
  }

  // Getter for shared analytics repository
  AnalyticsRepository get sharedAnalyticsRepository =>
      _sharedAnalyticsRepository;

  void toggleSidebar() => emit(state.copyWith(isExpanded: !state.isExpanded));

  void selectPage(int index) async {
    final navigationGuard = NavigationGuard();
    final canNavigate = await navigationGuard.checkUnsavedChanges();

    if (canNavigate) {
      emit(state.copyWith(selectedIndex: index));
    }
  }
}
