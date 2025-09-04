import 'package:cvms_desktop/features/auth/services/auth_persistence.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cvms_desktop/core/routes/app_routes.dart';

class AuthSessionService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> getInitialRoute() async {
    try {
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
      return AppRoutes.signIn;
    }
  }
}
