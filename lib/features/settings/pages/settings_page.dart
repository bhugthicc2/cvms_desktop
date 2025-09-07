//TODO IMPLEMENT PROPERLY SOON

import 'package:flutter/material.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Theme settings
  String _selectedTheme = 'light';
  bool _darkMode = false;

  // Language settings
  String _selectedLanguage = 'en';

  // Notification settings
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _soundNotifications = true;

  // Dashboard settings
  bool _autoRefresh = true;
  int _refreshInterval = 30;
  String _defaultView = 'overview';

  // Security settings
  int _sessionTimeout = 30;
  bool _autoLogout = true;
  bool _passwordPolicy = true;

  // Data settings
  int _dataRetention = 365;
  bool _backupEnabled = true;
  String _backupFrequency = 'daily';

  // System settings
  String _logLevel = 'info';
  bool _debugMode = false;
  bool _performanceMode = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _selectedTheme = 'light';
      _darkMode = false;
      _selectedLanguage = 'en';
      _notificationsEnabled = true;
      _emailNotifications = true;
      _pushNotifications = true;
      _soundNotifications = true;
      _autoRefresh = true;
      _refreshInterval = 30;
      _defaultView = 'overview';
      _sessionTimeout = 30;
      _autoLogout = true;
      _passwordPolicy = true;
      _dataRetention = 365;
      _backupEnabled = true;
      _backupFrequency = 'daily';
      _logLevel = 'info';
      _debugMode = false;
      _performanceMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSettingsHeader(),
            Spacing.vertical(size: AppSpacing.medium),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildAppearanceSettings()),
                Spacing.horizontal(size: AppSpacing.medium),
                Expanded(flex: 2, child: _buildNotificationSettings()),
                Spacing.horizontal(size: AppSpacing.medium),
                Expanded(flex: 2, child: _buildDashboardSettings()),
              ],
            ),
            Spacing.vertical(size: AppSpacing.medium),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildSecuritySettings()),
                Spacing.horizontal(size: AppSpacing.medium),
                Expanded(flex: 2, child: _buildDataSettings()),
                Spacing.horizontal(size: AppSpacing.medium),
                Expanded(flex: 2, child: _buildSystemSettings()),
              ],
            ),
            Spacing.vertical(size: AppSpacing.medium),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.lightBlue,
            ),
            child: const Icon(
              PhosphorIconsBold.gear,
              size: 30,
              color: AppColors.white,
            ),
          ),
          Spacing.horizontal(size: AppSpacing.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Application Settings',
                  style: TextStyle(
                    fontSize: AppFontSizes.xxLarge,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                Spacing.vertical(size: AppSpacing.xSmall),
                const Text(
                  'Customize your CVMS experience with these settings',
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: _exportSettings,
            icon: const Icon(
              PhosphorIconsRegular.download,
              size: 20,
              color: AppColors.white,
            ),
            label: const Text('Export Settings'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.medium,
                vertical: AppSpacing.medium,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSettings() {
    return _buildSection(
      title: 'Appearance',
      icon: PhosphorIconsRegular.palette,
      children: [
        _buildSettingItem(
          title: 'Theme',
          subtitle: 'Choose your preferred theme',
          icon: PhosphorIconsRegular.sun,
          trailing: _buildThemeDropdown(),
        ),
        Spacing.vertical(size: AppSpacing.medium),
        _buildSettingItem(
          title: 'Dark Mode',
          subtitle: 'Enable dark mode for better viewing',
          icon: PhosphorIconsRegular.moon,
          trailing: Switch(
            value: _darkMode,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
              });
            },
            activeColor: AppColors.primary,
          ),
        ),
        Spacing.vertical(size: AppSpacing.medium),
        _buildSettingItem(
          title: 'Language',
          subtitle: 'Select your preferred language',
          icon: PhosphorIconsRegular.globe,
          trailing: _buildLanguageDropdown(),
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return _buildSection(
      title: 'Notifications',
      icon: PhosphorIconsRegular.bell,
      children: [
        _buildSettingItem(
          title: 'Enable Notifications',
          subtitle: 'Receive system notifications',
          icon: PhosphorIconsRegular.bell,
          trailing: Switch(
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            activeColor: AppColors.primary,
          ),
        ),
        Spacing.vertical(size: AppSpacing.medium),
        _buildSettingItem(
          title: 'Email Notifications',
          subtitle: 'Receive notifications via email',
          icon: PhosphorIconsRegular.envelope,
          trailing: Switch(
            value: _emailNotifications,
            onChanged:
                _notificationsEnabled
                    ? (value) {
                      setState(() {
                        _emailNotifications = value;
                      });
                    }
                    : null,
            activeColor: AppColors.primary,
          ),
        ),
        Spacing.vertical(size: AppSpacing.medium),
        _buildSettingItem(
          title: 'Push Notifications',
          subtitle: 'Receive push notifications',
          icon: PhosphorIconsRegular.deviceMobile,
          trailing: Switch(
            value: _pushNotifications,
            onChanged:
                _notificationsEnabled
                    ? (value) {
                      setState(() {
                        _pushNotifications = value;
                      });
                    }
                    : null,
            activeColor: AppColors.primary,
          ),
        ),
        Spacing.vertical(size: AppSpacing.medium),
        _buildSettingItem(
          title: 'Sound Notifications',
          subtitle: 'Play sound for notifications',
          icon: PhosphorIconsRegular.speakerHigh,
          trailing: Switch(
            value: _soundNotifications,
            onChanged:
                _notificationsEnabled
                    ? (value) {
                      setState(() {
                        _soundNotifications = value;
                      });
                    }
                    : null,
            activeColor: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardSettings() {
    return _buildSection(
      title: 'Dashboard',
      icon: PhosphorIconsRegular.squaresFour,
      children: [
        _buildSettingItem(
          title: 'Auto Refresh',
          subtitle: 'Automatically refresh dashboard data',
          icon: PhosphorIconsRegular.arrowClockwise,
          trailing: Switch(
            value: _autoRefresh,
            onChanged: (value) {
              setState(() {
                _autoRefresh = value;
              });
            },
            activeColor: AppColors.primary,
          ),
        ),
        Spacing.vertical(size: AppSpacing.medium),
        _buildSettingItem(
          title: 'Refresh Interval',
          subtitle: 'Data refresh interval in seconds',
          icon: PhosphorIconsRegular.timer,
          trailing: _buildRefreshIntervalDropdown(),
        ),
        Spacing.vertical(size: AppSpacing.medium),
        _buildSettingItem(
          title: 'Default View',
          subtitle: 'Default dashboard view on startup',
          icon: PhosphorIconsRegular.layout,
          trailing: _buildDefaultViewDropdown(),
        ),
      ],
    );
  }

  Widget _buildSecuritySettings() {
    return _buildSection(
      title: 'Security',
      icon: PhosphorIconsRegular.shield,
      children: [
        _buildSettingItem(
          title: 'Session Timeout',
          subtitle: 'Auto logout after inactivity (minutes)',
          icon: PhosphorIconsRegular.clock,
          trailing: _buildSessionTimeoutDropdown(),
        ),
        Spacing.vertical(size: AppSpacing.medium),
        _buildSettingItem(
          title: 'Auto Logout',
          subtitle: 'Automatically logout on timeout',
          icon: PhosphorIconsRegular.signOut,
          trailing: Switch(
            value: _autoLogout,
            onChanged: (value) {
              setState(() {
                _autoLogout = value;
              });
            },
            activeColor: AppColors.primary,
          ),
        ),
        Spacing.vertical(size: AppSpacing.medium),
        _buildSettingItem(
          title: 'Password Policy',
          subtitle: 'Enforce strong password requirements',
          icon: PhosphorIconsRegular.lock,
          trailing: Switch(
            value: _passwordPolicy,
            onChanged: (value) {
              setState(() {
                _passwordPolicy = value;
              });
            },
            activeColor: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildDataSettings() {
    return _buildSection(
      title: 'Data Management',
      icon: PhosphorIconsRegular.database,
      children: [
        _buildSettingItem(
          title: 'Data Retention',
          subtitle: 'Keep data for (days)',
          icon: PhosphorIconsRegular.calendar,
          trailing: _buildDataRetentionDropdown(),
        ),
        Spacing.vertical(size: AppSpacing.medium),
        _buildSettingItem(
          title: 'Auto Backup',
          subtitle: 'Automatically backup data',
          icon: PhosphorIconsRegular.cloudArrowUp,
          trailing: Switch(
            value: _backupEnabled,
            onChanged: (value) {
              setState(() {
                _backupEnabled = value;
              });
            },
            activeColor: AppColors.primary,
          ),
        ),
        Spacing.vertical(size: AppSpacing.medium),
        _buildSettingItem(
          title: 'Backup Frequency',
          subtitle: 'How often to backup data',
          icon: PhosphorIconsRegular.clockCounterClockwise,
          trailing: _buildBackupFrequencyDropdown(),
        ),
      ],
    );
  }

  Widget _buildSystemSettings() {
    return _buildSection(
      title: 'System',
      icon: PhosphorIconsRegular.cpu,
      children: [
        _buildSettingItem(
          title: 'Log Level',
          subtitle: 'System logging level',
          icon: PhosphorIconsRegular.listChecks,
          trailing: _buildLogLevelDropdown(),
        ),
        Spacing.vertical(size: AppSpacing.medium),
        _buildSettingItem(
          title: 'Debug Mode',
          subtitle: 'Enable debug information',
          icon: PhosphorIconsRegular.bug,
          trailing: Switch(
            value: _debugMode,
            onChanged: (value) {
              setState(() {
                _debugMode = value;
              });
            },
            activeColor: AppColors.primary,
          ),
        ),
        Spacing.vertical(size: AppSpacing.medium),
        _buildSettingItem(
          title: 'Performance Mode',
          subtitle: 'Optimize for better performance',
          icon: PhosphorIconsRegular.lightning,
          trailing: Switch(
            value: _performanceMode,
            onChanged: (value) {
              setState(() {
                _performanceMode = value;
              });
            },
            activeColor: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: _resetSettings,
            icon: const Icon(
              PhosphorIconsRegular.arrowCounterClockwise,
              size: 20,
              color: AppColors.white,
            ),
            label: const Text('Reset to Default'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.medium,
                vertical: AppSpacing.medium,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _cancelChanges,
                icon: const Icon(
                  PhosphorIconsRegular.x,
                  size: 20,
                  color: AppColors.white,
                ),
                label: const Text('Cancel'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.grey,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.medium,
                    vertical: AppSpacing.medium,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Spacing.horizontal(size: AppSpacing.medium),
              ElevatedButton.icon(
                onPressed: _saveSettings,
                icon: const Icon(
                  PhosphorIconsRegular.check,
                  size: 20,
                  color: AppColors.white,
                ),
                label: const Text('Save Settings'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.medium,
                    vertical: AppSpacing.medium,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 24),
              Spacing.horizontal(size: AppSpacing.small),
              Text(
                title,
                style: const TextStyle(
                  fontSize: AppFontSizes.xLarge,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          Spacing.vertical(size: AppSpacing.medium),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          Spacing.horizontal(size: AppSpacing.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: AppFontSizes.small,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildThemeDropdown() {
    return DropdownButton<String>(
      value: _selectedTheme,
      onChanged: (value) {
        setState(() {
          _selectedTheme = value!;
        });
      },
      items: const [
        DropdownMenuItem(value: 'light', child: Text('Light')),
        DropdownMenuItem(value: 'dark', child: Text('Dark')),
        DropdownMenuItem(value: 'auto', child: Text('Auto')),
      ],
    );
  }

  Widget _buildLanguageDropdown() {
    return DropdownButton<String>(
      value: _selectedLanguage,
      onChanged: (value) {
        setState(() {
          _selectedLanguage = value!;
        });
      },
      items: const [
        DropdownMenuItem(value: 'en', child: Text('English')),
        DropdownMenuItem(value: 'es', child: Text('Spanish')),
        DropdownMenuItem(value: 'fr', child: Text('French')),
      ],
    );
  }

  Widget _buildRefreshIntervalDropdown() {
    return DropdownButton<int>(
      value: _refreshInterval,
      onChanged: (value) {
        setState(() {
          _refreshInterval = value!;
        });
      },
      items: const [
        DropdownMenuItem(value: 15, child: Text('15s')),
        DropdownMenuItem(value: 30, child: Text('30s')),
        DropdownMenuItem(value: 60, child: Text('1m')),
        DropdownMenuItem(value: 300, child: Text('5m')),
      ],
    );
  }

  Widget _buildDefaultViewDropdown() {
    return DropdownButton<String>(
      value: _defaultView,
      onChanged: (value) {
        setState(() {
          _defaultView = value!;
        });
      },
      items: const [
        DropdownMenuItem(value: 'overview', child: Text('Overview')),
        DropdownMenuItem(value: 'detailed', child: Text('Detailed')),
        DropdownMenuItem(value: 'compact', child: Text('Compact')),
      ],
    );
  }

  Widget _buildSessionTimeoutDropdown() {
    return DropdownButton<int>(
      value: _sessionTimeout,
      onChanged: (value) {
        setState(() {
          _sessionTimeout = value!;
        });
      },
      items: const [
        DropdownMenuItem(value: 15, child: Text('15m')),
        DropdownMenuItem(value: 30, child: Text('30m')),
        DropdownMenuItem(value: 60, child: Text('1h')),
        DropdownMenuItem(value: 120, child: Text('2h')),
      ],
    );
  }

  Widget _buildDataRetentionDropdown() {
    return DropdownButton<int>(
      value: _dataRetention,
      onChanged: (value) {
        setState(() {
          _dataRetention = value!;
        });
      },
      items: const [
        DropdownMenuItem(value: 30, child: Text('30 days')),
        DropdownMenuItem(value: 90, child: Text('90 days')),
        DropdownMenuItem(value: 180, child: Text('6 months')),
        DropdownMenuItem(value: 365, child: Text('1 year')),
      ],
    );
  }

  Widget _buildBackupFrequencyDropdown() {
    return DropdownButton<String>(
      value: _backupFrequency,
      onChanged: (value) {
        setState(() {
          _backupFrequency = value!;
        });
      },
      items: const [
        DropdownMenuItem(value: 'daily', child: Text('Daily')),
        DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
        DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
      ],
    );
  }

  Widget _buildLogLevelDropdown() {
    return DropdownButton<String>(
      value: _logLevel,
      onChanged: (value) {
        setState(() {
          _logLevel = value!;
        });
      },
      items: const [
        DropdownMenuItem(value: 'error', child: Text('Error')),
        DropdownMenuItem(value: 'warning', child: Text('Warning')),
        DropdownMenuItem(value: 'info', child: Text('Info')),
        DropdownMenuItem(value: 'debug', child: Text('Debug')),
      ],
    );
  }

  void _saveSettings() {
    CustomSnackBar.show(
      context: context,
      message: 'Settings saved successfully!',
      type: SnackBarType.success,
    );
  }

  void _cancelChanges() {
    _loadSettings();
    CustomSnackBar.show(
      context: context,
      message: 'Changes cancelled',
      type: SnackBarType.info,
    );
  }

  void _resetSettings() {
    showDialog(
      context: context,
      builder:
          (context) => CustomDialog(
            title: 'Reset Settings',
            icon: PhosphorIconsRegular.warning,
            width: 400,
            height: 300,
            btnTxt: 'Reset',
            onSave: () {
              Navigator.of(context).pop();
              _loadSettings();
              CustomSnackBar.show(
                context: context,
                message: 'Settings reset to default!',
                type: SnackBarType.success,
              );
            },
            child: const Text(
              'Are you sure you want to reset all settings to their default values? This action cannot be undone.',
              style: TextStyle(fontSize: AppFontSizes.medium),
            ),
          ),
    );
  }

  void _exportSettings() {
    CustomSnackBar.show(
      context: context,
      message: 'Settings exported successfully!',
      type: SnackBarType.success,
    );
  }
}
