//ACTIVITY LOG 7

import 'package:flutter/material.dart';

enum ActivityType {
  vehicleCreated('Vehicle Created', 'add_circle', 'green'),
  vehicleUpdated('Vehicle Updated', 'edit', 'blue'),
  vehicleDeleted('Vehicle Deleted', 'delete', 'red'),
  userLogin('User Login', 'login', 'green'),
  userLogout('User Logout', 'logout', 'orange'),
  violationReported('Violation Reported', 'warning', 'red'),
  violationUpdated('Violation Updated', 'edit', 'blue'),
  violationDeleted('Violation Deleted', 'delete', 'red'),
  userCreated('User Created', 'person_add', 'green'),
  userUpdated('User Updated', 'person', 'blue'),
  userDeleted('User Deleted', 'person_remove', 'red'),
  passwordReset('Password Reset', 'lock_reset', 'orange'),
  systemNavigation('Page Navigation', 'navigation', 'grey'),
  systemError('System Error', 'error', 'red'),
  dataExport('Data Export', 'download', 'blue'),
  dataImport('Data Import', 'upload', 'green');

  const ActivityType(this.label, this.iconName, this.colorName);

  final String label;
  final String iconName;
  final String colorName;

  String get name => toString().split('.').last;

  IconData get icon {
    switch (iconName) {
      case 'add_circle':
        return Icons.add_circle;
      case 'edit':
        return Icons.edit;
      case 'delete':
        return Icons.delete;
      case 'login':
        return Icons.login;
      case 'logout':
        return Icons.logout;
      case 'warning':
        return Icons.warning;
      case 'person_add':
        return Icons.person_add;
      case 'person':
        return Icons.person;
      case 'person_remove':
        return Icons.person_remove;
      case 'lock_reset':
        return Icons.lock_reset;
      case 'navigation':
        return Icons.navigation;
      case 'error':
        return Icons.error;
      case 'download':
        return Icons.download;
      case 'upload':
        return Icons.upload;
      default:
        return Icons.info;
    }
  }

  Color get color {
    switch (colorName) {
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'red':
        return Colors.red;
      case 'orange':
        return Colors.orange;
      case 'grey':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }
}
