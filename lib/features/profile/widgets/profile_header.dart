import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.user,
    required this.isEditing,
    required this.onToggleEdit,
    required this.onSave,
  });

  final User? user;
  final bool isEditing;
  final VoidCallback onToggleEdit;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/profile.png'),
              ),
              shape: BoxShape.circle,
              border: Border.all(width: 2, color: AppColors.primary),
              gradient: AppColors.lightBlue,
            ),
          ),
          Spacing.horizontal(size: AppSpacing.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Spacing.vertical(size: AppSpacing.xSmall),
                Text(
                  user?.email ?? 'admin@cvms.com',
                  style: const TextStyle(
                    fontSize: AppFontSizes.medium,
                    color: AppColors.grey,
                  ),
                ),
                Spacing.vertical(size: AppSpacing.xSmall),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.small,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'CDRRSMU Admin', //todo retrieve the role from the user
                    style: TextStyle(
                      fontSize: AppFontSizes.small,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: isEditing ? onSave : onToggleEdit,
            icon: Icon(
              isEditing
                  ? PhosphorIconsRegular.check
                  : PhosphorIconsRegular.pencil,
              size: 20,
              color: AppColors.white,
            ),
            label: Text(isEditing ? 'Save Changes' : 'Edit Profile'),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isEditing ? AppColors.success : AppColors.primary,
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
}
