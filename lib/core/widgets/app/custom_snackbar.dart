import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

enum SnackBarType { success, error, info, warning, networkError }

class CustomSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onRetry,
  }) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (type) {
      case SnackBarType.success:
        backgroundColor = AppColors.success;
        textColor = AppColors.white;
        icon = PhosphorIcons.checkCircle(PhosphorIconsStyle.fill);
        break;
      case SnackBarType.error:
        backgroundColor = AppColors.error;
        textColor = AppColors.white;
        icon = PhosphorIcons.xCircle(PhosphorIconsStyle.fill);
        break;
      case SnackBarType.info:
        backgroundColor = AppColors.grey;
        textColor = AppColors.white;
        icon = PhosphorIcons.info(PhosphorIconsStyle.fill);
        break;
      case SnackBarType.warning:
        backgroundColor = Colors.orange.shade600;
        textColor = AppColors.white;
        icon = PhosphorIcons.warning(PhosphorIconsStyle.fill);
        break;
      case SnackBarType.networkError:
        backgroundColor = AppColors.error;
        textColor = AppColors.white;
        icon = PhosphorIcons.wifiSlash(PhosphorIconsStyle.fill);
        break;
    }

    final snackBar = SnackBar(
      dismissDirection: DismissDirection.startToEnd,
      content: Row(
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.sora(
                fontSize: AppFontSizes.medium,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration:
          type == SnackBarType.networkError
              ? const Duration(seconds: 6)
              : duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      margin: EdgeInsets.only(
        bottom: 30.0,
        right: 16.0,
        left: MediaQuery.of(context).size.width * 0.7,
      ),
      action:
          (type == SnackBarType.networkError && onRetry != null)
              ? SnackBarAction(
                label: 'Retry',
                textColor: textColor,
                onPressed: onRetry,
              )
              : null,
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showError(BuildContext context, String message) {
    show(context: context, message: message, type: SnackBarType.error);
  }

  static void showSuccess(BuildContext context, String message) {
    show(context: context, message: message, type: SnackBarType.success);
  }

  static void showWarning(BuildContext context, String message) {
    show(context: context, message: message, type: SnackBarType.warning);
  }

  static void showInfo(BuildContext context, String message) {
    show(context: context, message: message, type: SnackBarType.info);
  }

  static void showNetworkError(BuildContext context, {VoidCallback? onRetry}) {
    show(
      context: context,
      message:
          'Network connection failed. Please check your internet connection.',
      type: SnackBarType.networkError,
      onRetry: onRetry,
    );
  }
}
