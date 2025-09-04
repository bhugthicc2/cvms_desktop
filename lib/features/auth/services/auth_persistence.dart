import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utils/logger.dart';

class AuthPersistence {
  static const String keyKeepLoggedIn = 'keep_logged_in';

  static Future<void> setKeepLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    //Logger
    Logger.log('Keep me logged in set to: $value');
    await prefs.setBool(keyKeepLoggedIn, value);
  }

  static Future<bool> getKeepLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    //Logger
    Logger.log('Keep me logged in retrieved');

    return prefs.getBool(keyKeepLoggedIn) ?? false;
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyKeepLoggedIn);
  }
}
