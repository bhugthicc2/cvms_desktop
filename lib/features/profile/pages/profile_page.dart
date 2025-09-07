//TODO IMPLEMENT PROPERLY SOON

import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/features/auth/bloc/auth_bloc.dart';
import 'package:cvms_desktop/features/auth/bloc/auth_state.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _fullNameController.text = user.displayName ?? 'Admin User';
      _emailController.text = user.email ?? '';
      _phoneController.text = user.phoneNumber ?? '';
      _departmentController.text = 'IT Department';
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _departmentController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final user = FirebaseAuth.instance.currentUser;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(user),
                Spacing.vertical(size: AppSpacing.medium),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildPersonalInformation()),
                    Spacing.horizontal(size: AppSpacing.medium),
                    Expanded(flex: 2, child: _buildAccountSettings()),
                    Spacing.horizontal(size: AppSpacing.medium),
                    Expanded(flex: 2, child: _buildSecuritySettings()),
                  ],
                ),
                Spacing.vertical(size: AppSpacing.medium),
                _buildActivitySection(user),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(User? user) {
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
              image: DecorationImage(
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

              children: [
                Row(
                  children: [
                    Text(
                      user?.displayName ?? 'Admin User',
                      style: const TextStyle(
                        fontSize: AppFontSizes.xxLarge,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    Spacing.horizontal(size: AppSpacing.small),
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
                        'Administrator',
                        style: TextStyle(
                          fontSize: AppFontSizes.small,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
                Spacing.vertical(size: AppSpacing.xSmall),
                Text(
                  user?.email ?? 'admin@cvms.com',
                  style: const TextStyle(
                    fontSize: AppFontSizes.medium,
                    color: AppColors.grey,
                  ),
                ),
                Spacing.vertical(size: AppSpacing.xSmall),
                Row(
                  children: [
                    Icon(
                      PhosphorIconsRegular.circle,
                      size: 8,
                      color: AppColors.success,
                    ),
                    Spacing.horizontal(size: AppSpacing.xSmall),
                    const Text(
                      'Active',
                      style: TextStyle(
                        fontSize: AppFontSizes.small,
                        color: AppColors.success,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: _isEditing ? _saveProfile : _toggleEdit,
            icon: Icon(
              _isEditing
                  ? PhosphorIconsRegular.check
                  : PhosphorIconsRegular.pencil,
              size: 20,
              color: AppColors.white,
            ),
            label: Text(_isEditing ? 'Save Changes' : 'Edit Profile'),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _isEditing ? AppColors.success : AppColors.primary,
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

  Widget _buildPersonalInformation() {
    return _buildSection(
      title: 'Personal Information',
      icon: PhosphorIconsRegular.user,
      children: [
        _buildInfoField(
          label: 'Full Name',
          controller: _fullNameController,
          icon: PhosphorIconsRegular.user,
          enabled: _isEditing,
        ),
        Spacing.vertical(size: AppSpacing.medium),
        _buildInfoField(
          label: 'Phone Number',
          controller: _phoneController,
          icon: PhosphorIconsRegular.phone,
          enabled: _isEditing,
        ),
        Spacing.vertical(size: AppSpacing.medium),
        _buildInfoField(
          label: 'Department',
          controller: _departmentController,
          icon: PhosphorIconsRegular.buildings,
          enabled: _isEditing,
        ),
        Spacing.vertical(size: AppSpacing.medium),
        _buildInfoField(
          label: 'Role',
          value: 'Administrator',
          icon: PhosphorIconsRegular.shield,
          enabled: false,
        ),
      ],
    );
  }

  Widget _buildAccountSettings() {
    return _buildSection(
      title: 'Account Settings',
      icon: PhosphorIconsRegular.gear,
      children: [
        _buildInfoField(
          label: 'Email Address',
          controller: _emailController,
          icon: PhosphorIconsRegular.envelope,
          enabled: false,
        ),
        Spacing.vertical(size: AppSpacing.medium),
        _buildInfoField(
          label: 'Username',
          value: 'admin',
          icon: PhosphorIconsRegular.userCircle,
          enabled: false,
        ),
        Spacing.vertical(size: AppSpacing.medium),
        _buildInfoField(
          label: 'Language',
          value: 'English',
          icon: PhosphorIconsRegular.globe,
          enabled: false,
        ),
        Spacing.vertical(size: AppSpacing.medium),
        _buildInfoField(
          label: 'Theme',
          value: 'Light Mode',
          icon: PhosphorIconsRegular.sun,
          enabled: false,
        ),
      ],
    );
  }

  Widget _buildSecuritySettings() {
    return _buildSection(
      title: 'Security',
      icon: PhosphorIconsRegular.shield,
      children: [
        _buildSecurityAction(
          title: 'Change Password',
          subtitle: 'Update your account password',
          icon: PhosphorIconsRegular.lock,
          onTap: _showChangePasswordDialog,
        ),
        Spacing.vertical(size: AppSpacing.medium),
        _buildSecurityAction(
          title: 'Two-Factor Authentication',
          subtitle: 'Add an extra layer of security',
          icon: PhosphorIconsRegular.deviceMobile,
          onTap: () {},
          trailing: Switch(
            value: false,
            onChanged: (value) {},
            activeColor: AppColors.primary,
          ),
        ),
        Spacing.vertical(size: AppSpacing.medium),
        _buildSecurityAction(
          title: 'Active Sessions',
          subtitle: 'Manage your active sessions',
          icon: PhosphorIconsRegular.devices,
          onTap: () {},
        ),
        Spacing.vertical(size: AppSpacing.medium),
        _buildSecurityAction(
          title: 'Login Activity',
          subtitle: 'View your recent login history',
          icon: PhosphorIconsRegular.clock,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildActivitySection(User? user) {
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
              Icon(
                PhosphorIconsRegular.chartLine,
                color: AppColors.primary,
                size: 24,
              ),
              Spacing.horizontal(size: AppSpacing.small),
              const Text(
                'Activity & Statistics',
                style: TextStyle(
                  fontSize: AppFontSizes.xLarge,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          Spacing.vertical(size: AppSpacing.medium),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Last Login',
                  value: 'Today, 2:30 PM',
                  icon: PhosphorIconsRegular.clock,
                  color: AppColors.primary,
                ),
              ),
              Spacing.horizontal(size: AppSpacing.medium),
              Expanded(
                child: _buildStatCard(
                  title: 'Account Created',
                  value: 'Jan 15, 2024',
                  icon: PhosphorIconsRegular.calendar,
                  color: AppColors.success,
                ),
              ),
              Spacing.horizontal(size: AppSpacing.medium),
              Expanded(
                child: _buildStatCard(
                  title: 'Total Logins',
                  value: '1,247',
                  icon: PhosphorIconsRegular.signIn,
                  color: AppColors.warning,
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

  Widget _buildInfoField({
    required String label,
    TextEditingController? controller,
    String? value,
    required IconData icon,
    required bool enabled,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: AppFontSizes.small,
            fontWeight: FontWeight.w600,
            color: AppColors.grey,
          ),
        ),
        Spacing.vertical(size: AppSpacing.xSmall),
        if (controller != null)
          CustomTextField(
            controller: controller,
            enabled: enabled,
            prefixIcon: icon,
            fillColor: enabled ? AppColors.white : AppColors.greySurface,
            borderColor: enabled ? AppColors.grey : AppColors.dividerColor,
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.small,
              vertical: AppSpacing.medium,
            ),
            decoration: BoxDecoration(
              color: AppColors.greySurface,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: AppColors.dividerColor),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.grey, size: 20),
                Spacing.horizontal(size: AppSpacing.small),
                Text(
                  value ?? '',
                  style: const TextStyle(
                    fontSize: AppFontSizes.medium,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSecurityAction({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
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
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          Spacing.vertical(size: AppSpacing.small),
          Text(
            value,
            style: TextStyle(
              fontSize: AppFontSizes.medium,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveProfile() {
    setState(() {
      _isEditing = false;
    });
    CustomSnackBar.show(
      context: context,
      message: 'Profile updated successfully!',
      type: SnackBarType.success,
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder:
          (context) => CustomDialog(
            title: 'Change Password',
            icon: PhosphorIconsRegular.lock,
            width: 500,
            height: 600,
            btnTxt: 'Update Password',
            onSave: _changePassword,
            child: Column(
              children: [
                CustomTextField(
                  controller: _currentPasswordController,
                  labelText: 'Current Password',
                  obscureText: true,
                  enableVisibilityToggle: true,
                  prefixIcon: PhosphorIconsRegular.lock,
                ),
                Spacing.vertical(size: AppSpacing.medium),
                CustomTextField(
                  controller: _newPasswordController,
                  labelText: 'New Password',
                  obscureText: true,
                  enableVisibilityToggle: true,
                  prefixIcon: PhosphorIconsRegular.lock,
                ),
                Spacing.vertical(size: AppSpacing.medium),
                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm New Password',
                  obscureText: true,
                  enableVisibilityToggle: true,
                  prefixIcon: PhosphorIconsRegular.lock,
                ),
              ],
            ),
          ),
    );
  }

  void _changePassword() {
    Navigator.of(context).pop();
    CustomSnackBar.show(
      context: context,
      message: 'Password updated successfully!',
      type: SnackBarType.success,
    );
  }
}
