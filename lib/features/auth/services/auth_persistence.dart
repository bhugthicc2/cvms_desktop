import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPersistence {
  static const String keyKeepLoggedIn = 'keep_logged_in';
  static const String keyUserEmail = 'user_email';
  static const String keyUserId = 'user_id';

  static Future<void> setKeepLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyKeepLoggedIn, value);
  }

  static Future<bool> getKeepLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(keyKeepLoggedIn) ?? false;
    return value;
  }

  static Future<void> saveUserSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUserEmail, user.email ?? '');
    await prefs.setString(keyUserId, user.uid);
  }

  static Future<Map<String, String?>> getSavedUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(keyUserEmail);
    final userId = prefs.getString(keyUserId);
    return {'email': email, 'uid': userId};
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyKeepLoggedIn);
    await prefs.remove(keyUserEmail);
    await prefs.remove(keyUserId);
  }
}
