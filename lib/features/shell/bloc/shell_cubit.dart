import 'package:flutter_bloc/flutter_bloc.dart';

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
  ShellCubit() : super(ShellState());

  void toggleSidebar() => emit(state.copyWith(isExpanded: !state.isExpanded));
  void selectPage(int index) => emit(state.copyWith(selectedIndex: index));
}
