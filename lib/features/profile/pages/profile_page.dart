import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/layout/custom_divider.dart';
import '../../../core/widgets/layout/spacing.dart';
import '../bloc/profile_cubit.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_page_header.dart';
import '../widgets/profile_section.dart';
import '../widgets/section_decor.dart';
import '../services/profile_service.dart';

class ProfilePage extends StatefulWidget {
  final bool isEdit;
  const ProfilePage({super.key, this.isEdit = true});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64, color: AppColors.error),
                const SizedBox(height: 16),
                Text(
                  'Error: ${state.errorMessage}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:
                      () =>
                          context
                              .read<ProfileCubit>()
                              .loadUserProfile(), //refresh
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state.userData == null) {
          return const Center(child: Text('No profile data available'));
        }

        final userData = state.userData!;
        final screenWidth = MediaQuery.of(context).size.width;

        return Scaffold(
          backgroundColor: AppColors.greySurface,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.09,
                vertical: AppSpacing.medium,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfilePageHeader(
                    title: 'My Profile',
                    buttonText: widget.isEdit ? 'Edit Profile' : 'Save Changes',
                    btnColor:
                        widget.isEdit ? AppColors.primary : AppColors.success,
                    onButtonTap: () {
                      // TODO:trigger edit mode
                    },
                  ),

                  Spacing.vertical(size: AppSpacing.large),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.medium),
                    height: 160,
                    decoration: sectionDecoration(),
                    child: ProfileHeader(
                      image:
                          userData['profileImage'] ??
                          'assets/images/profile.png',
                      name: userData['fullname'] ?? 'Unknown User',
                      role: userData['role'] ?? 'Unknown Role',
                      onImageTap: () async {
                        await ProfileService.pickAndUploadImage(
                          context: context,
                          onImageSelected: (base64Image) {
                            if (mounted) {
                              context.read<ProfileCubit>().updateProfileImage(
                                base64Image,
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                  ProfileSection(
                    title: 'Profile information',
                    children: [
                      ProfileDetailRow(
                        label: 'Fullname',
                        value: userData['fullname'] ?? 'N/A',
                      ),
                      CustomDivider(
                        direction: Axis.horizontal,
                        thickness: 1,
                        color: AppColors.dividerColor.withValues(alpha: 0.4),
                      ),
                      ProfileDetailRow(
                        label: 'Email',
                        value: userData['email'] ?? 'N/A',
                      ),
                      CustomDivider(
                        direction: Axis.horizontal,
                        thickness: 1,
                        color: AppColors.dividerColor.withValues(alpha: 0.4),
                      ),
                      ProfileDetailRow(
                        label: 'Role',
                        value:
                            userData['role']?.toString().replaceAll('_', ' ') ??
                            'N/A',
                      ),
                      CustomDivider(
                        direction: Axis.horizontal,
                        thickness: 1,
                        color: AppColors.dividerColor.withValues(alpha: 0.4),
                      ),
                      ProfileDetailRow(label: 'Password', value: '********'),
                    ],
                  ),
                  ProfileSection(
                    title: 'Account details',
                    children: [
                      ProfileDetailRow(
                        label: 'Account created',
                        value: TimestampFormatter.formatTimestamp(
                          userData['createdAt'],
                        ),
                      ),
                      CustomDivider(
                        direction: Axis.horizontal,
                        thickness: 1,
                        color: AppColors.dividerColor.withValues(alpha: 0.4),
                      ),
                      ProfileDetailRow(
                        label: 'Last login',
                        value: TimestampFormatter.formatTimestamp(
                          userData['lastLogin'],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
