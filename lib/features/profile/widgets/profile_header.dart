import 'dart:convert';

import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_grow.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String image;
  final String name;
  final String role;
  final VoidCallback? onImageTap;

  const ProfileHeader({
    super.key,
    required this.image,
    required this.name,
    required this.role,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileImage(image: image, onTap: onImageTap),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacing.vertical(size: AppSpacing.small),
            Text(
              role,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.grey.withValues(alpha: 0.7),
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacing.vertical(size: AppSpacing.small),
            Row(
              children: [
                CircleAvatar(backgroundColor: AppColors.chartGreen, radius: 5),
                Spacing.horizontal(size: AppSpacing.small),
                Text(
                  'Active',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.chartGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class ProfileImage extends StatelessWidget {
  final String image;
  final VoidCallback? onTap;

  const ProfileImage({super.key, required this.image, this.onTap});

  ImageProvider _getImageProvider(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return AssetImage(imagePath);
    } else {
      try {
        return MemoryImage(base64Decode(imagePath));
      } catch (e) {
        // Fallback to asset if base64 decode fails
        return AssetImage('assets/images/owner_sample.jpg');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary, width: 5),
            color: AppColors.white,
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            radius: 80,
            backgroundImage: _getImageProvider(image),
            backgroundColor: AppColors.white,
          ),
        ),
        Positioned(
          bottom: 5,
          right: 30,
          child: Tooltip(
            message: 'Upload Profile Picture',
            child: HoverGrow(
              cursor: SystemMouseCursors.click,
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
