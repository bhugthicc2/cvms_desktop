import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  // Theme settings
  static const String keyTheme = 'app_theme';
  static const String keyDarkMode = 'dark_mode';

  // Language settings
  static const String keyLanguage = 'app_language';
  static const String keyLocale = 'app_locale';

  // Notification settings
  static const String keyNotifications = 'notifications_enabled';
  static const String keyEmailNotifications = 'email_notifications';
  static const String keyPushNotifications = 'push_notifications';
  static const String keySoundNotifications = 'sound_notifications';

  // Dashboard settings
  static const String keyAutoRefresh = 'auto_refresh_enabled';
  static const String keyRefreshInterval = 'refresh_interval';
  static const String keyDefaultView = 'default_dashboard_view';

  // Security settings
  static const String keySessionTimeout = 'session_timeout';
  static const String keyAutoLogout = 'auto_logout_enabled';
  static const String keyPasswordPolicy = 'password_policy_enabled';

  // Data settings
  static const String keyDataRetention = 'data_retention_days';
  static const String keyBackupEnabled = 'backup_enabled';
  static const String keyBackupFrequency = 'backup_frequency';

  // System settings
  static const String keyLogLevel = 'log_level';
  static const String keyDebugMode = 'debug_mode';
  static const String keyPerformanceMode = 'performance_mode';

  // Theme methods
  static Future<void> setTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyTheme, theme);
  }

  static Future<String> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyTheme) ?? 'light';
  }

  static Future<void> setDarkMode(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyDarkMode, enabled);
  }

  static Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyDarkMode) ?? false;
  }

  // Language methods
  static Future<void> setLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyLanguage, language);
  }

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyLanguage) ?? 'en';
  }

  // Notification methods
  static Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyNotifications, enabled);
  }

  static Future<bool> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyNotifications) ?? true;
  }

  static Future<void> setEmailNotifications(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyEmailNotifications, enabled);
  }

  static Future<bool> getEmailNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyEmailNotifications) ?? true;
  }

  static Future<void> setPushNotifications(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyPushNotifications, enabled);
  }

  static Future<bool> getPushNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyPushNotifications) ?? true;
  }

  static Future<void> setSoundNotifications(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keySoundNotifications, enabled);
  }

  static Future<bool> getSoundNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keySoundNotifications) ?? true;
  }

  // Dashboard methods
  static Future<void> setAutoRefresh(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyAutoRefresh, enabled);
  }

  static Future<bool> getAutoRefresh() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyAutoRefresh) ?? true;
  }

  static Future<void> setRefreshInterval(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(keyRefreshInterval, seconds);
  }

  static Future<int> getRefreshInterval() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keyRefreshInterval) ?? 30;
  }

  static Future<void> setDefaultView(String view) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyDefaultView, view);
  }

  static Future<String> getDefaultView() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyDefaultView) ?? 'overview';
  }

  // Security methods
  static Future<void> setSessionTimeout(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(keySessionTimeout, minutes);
  }

  static Future<int> getSessionTimeout() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keySessionTimeout) ?? 30;
  }

  static Future<void> setAutoLogout(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyAutoLogout, enabled);
  }

  static Future<bool> getAutoLogout() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyAutoLogout) ?? true;
  }

  static Future<void> setPasswordPolicy(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyPasswordPolicy, enabled);
  }

  static Future<bool> getPasswordPolicy() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyPasswordPolicy) ?? true;
  }

  // Data methods
  static Future<void> setDataRetention(int days) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(keyDataRetention, days);
  }

  static Future<int> getDataRetention() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keyDataRetention) ?? 365;
  }

  static Future<void> setBackupEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyBackupEnabled, enabled);
  }

  static Future<bool> getBackupEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyBackupEnabled) ?? true;
  }

  static Future<void> setBackupFrequency(String frequency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyBackupFrequency, frequency);
  }

  static Future<String> getBackupFrequency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyBackupFrequency) ?? 'daily';
  }

  // System methods
  static Future<void> setLogLevel(String level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyLogLevel, level);
  }

  static Future<String> getLogLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyLogLevel) ?? 'info';
  }

  static Future<void> setDebugMode(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyDebugMode, enabled);
  }

  static Future<bool> getDebugMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyDebugMode) ?? false;
  }

  static Future<void> setPerformanceMode(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyPerformanceMode, enabled);
  }

  static Future<bool> getPerformanceMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyPerformanceMode) ?? false;
  }

  // Reset all settings
  static Future<void> resetAllSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Export settings
  static Future<Map<String, dynamic>> exportSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final Map<String, dynamic> settings = {};

    for (String key in keys) {
      if (key.startsWith('app_') ||
          key.startsWith('notifications_') ||
          key.startsWith('auto_') ||
          key.startsWith('session_') ||
          key.startsWith('data_') ||
          key.startsWith('backup_') ||
          key.startsWith('log_') ||
          key.startsWith('debug_') ||
          key.startsWith('performance_') ||
          key.startsWith('password_') ||
          key.startsWith('refresh_') ||
          key.startsWith('default_') ||
          key.startsWith('dark_') ||
          key.startsWith('email_') ||
          key.startsWith('push_') ||
          key.startsWith('sound_')) {
        final value = prefs.get(key);
        settings[key] = value;
      }
    }

    return settings;
  }
}
