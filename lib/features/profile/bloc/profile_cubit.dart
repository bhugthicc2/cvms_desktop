import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/data/auth_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserRepository _userRepository;
  final AuthRepository _authRepository;
  StreamSubscription? _userProfileSub;

  ProfileCubit({
    required UserRepository userRepository,
    required AuthRepository authRepository,
  }) : _userRepository = userRepository,
       _authRepository = authRepository,
       super(ProfileState.initial()) {
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final uid = _authRepository.uid;
    if (uid == null) {
      emit(state.copyWith(isLoading: false, errorMessage: 'No user logged in'));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      // Listen to real-time profile updates
      _userProfileSub?.cancel();
      _userProfileSub = _userRepository
          .watchUserProfile(uid)
          .listen(
            (snapshot) {
              if (isClosed) return;

              if (snapshot.exists && snapshot.data() != null) {
                final userData = snapshot.data()!;
                emit(
                  state.copyWith(
                    isLoading: false,
                    userData: userData,
                    errorMessage: null,
                  ),
                );
              } else {
                emit(
                  state.copyWith(
                    isLoading: false,
                    userData: null,
                    errorMessage: 'User profile not found',
                  ),
                );
              }
            },
            onError: (error) {
              if (isClosed) return;
              emit(
                state.copyWith(
                  isLoading: false,
                  userData: null,
                  errorMessage: 'Failed to load profile: $error',
                ),
              );
            },
          );
    } catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          isLoading: false,
          userData: null,
          errorMessage: 'Failed to load profile: $e',
        ),
      );
    }
  }

  Future<void> loadUserProfile() async {
    await _loadUserProfile();
  }

  Future<void> updateProfileImage(String base64Image) async {
    final uid = _authRepository.uid;
    if (uid == null) {
      emit(state.copyWith(errorMessage: 'No user logged in'));
      return;
    }

    try {
      await _userRepository.updateUserProfile(uid, {
        'profileImage': base64Image,
      });
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to update profile image: $e'));
    }
  }

  String getInitials(String? fullname) {
    if (fullname == null || fullname.isEmpty) return 'U';
    final parts = fullname.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'U';
  }

  @override
  Future<void> close() async {
    await _userProfileSub?.cancel();
    return super.close();
  }
}
