import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/auth_repository.dart';
import '../data/user_repository.dart';

part 'current_user_state.dart';

class CurrentUserCubit extends Cubit<CurrentUserState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  StreamSubscription<dynamic>? _authSub;

  CurrentUserCubit({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  }) : _authRepository = authRepository,
       _userRepository = userRepository,
       super(CurrentUserState.initial()) {
    _listenAuthChanges();
  }

  void _listenAuthChanges() {
    _authSub?.cancel();
    _authSub = _authRepository.authStateChanges.listen(
      (user) async {
        if (isClosed) return;
        if (user == null) {
          emit(
            state.copyWith(
              fullname: null,
              errorMessage: null,
              isLoading: false,
            ),
          );
        } else {
          await loadFullname(user.uid);
        }
      },
      onError: (e) {
        if (isClosed) return;
        emit(
          state.copyWith(
            errorMessage: 'Auth stream error: $e',
            fullname: null,
            isLoading: false,
          ),
        );
      },
    );
  }

  Future<void> loadFullname([String? uid]) async {
    final currentUid = uid ?? _authRepository.uid;
    if (currentUid == null) {
      if (isClosed) return;
      emit(
        state.copyWith(fullname: null, errorMessage: null, isLoading: false),
      );
      return;
    }

    if (isClosed) return;
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final name = await _userRepository.getUserFullname(currentUid);
      if (isClosed) return;
      emit(
        state.copyWith(isLoading: false, fullname: name, errorMessage: null),
      );
    } catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          isLoading: false,
          fullname: null,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await _authSub?.cancel();
    return super.close();
  }
}
