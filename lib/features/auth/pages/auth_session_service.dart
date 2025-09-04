import 'package:cvms_desktop/features/auth/services/auth_persistence.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cvms_desktop/core/routes/app_routes.dart';

class AuthSessionService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Determines which route the app should start with
  Future<String> getInitialRoute() async {
    try {
      // Ensure Firebase emits at least once
      await _firebaseAuth.authStateChanges().first;

      final keepLoggedIn = await AuthPersistence.getKeepLoggedIn();
      final user = _firebaseAuth.currentUser;
      final savedSession = await AuthPersistence.getSavedUserSession();

      final hasValidSession =
          (user != null) ||
          (keepLoggedIn &&
              savedSession['email'] != null &&
              savedSession['uid'] != null);

      return hasValidSession ? AppRoutes.shell : AppRoutes.signIn;
    } catch (e) {
      // fallback route
      return AppRoutes.signIn;
    }
  }
}
