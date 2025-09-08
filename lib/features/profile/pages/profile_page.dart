import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/auth/bloc/auth_bloc.dart';
import 'package:cvms_desktop/features/auth/bloc/auth_state.dart';
import 'package:cvms_desktop/features/profile/widgets/profile_header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // Profile initialization will be added in future implementation
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
                ProfileHeader(
                  user: user,
                  isEditing: _isEditing,
                  onToggleEdit: _toggleEdit,
                  onSave: _saveProfile,
                ),
                Spacing.vertical(size: AppSpacing.medium),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(flex: 2, child: _buildBlankSection()),
                      Spacing.horizontal(size: AppSpacing.medium),
                      Expanded(flex: 2, child: _buildBlankSection()),
                      Spacing.horizontal(size: AppSpacing.medium),
                      Expanded(flex: 2, child: _buildBlankSection()),
                    ],
                  ),
                ),
                Spacing.vertical(size: AppSpacing.medium),
                _buildBlankSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBlankSection() {
    return Container(
      height: 300, // Fixed height to maintain layout
      width: double.infinity,
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
      child: const SizedBox.shrink(), // Empty container
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
}
