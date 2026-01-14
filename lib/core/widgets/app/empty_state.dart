import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import '../../theme/app_colors.dart';

enum EmptyStateType {
  noData,
  noSearchResults,
  error,
  loading,
  noVehicles,
  pageNotFound,
}

class EmptyState extends StatelessWidget {
  final EmptyStateType type;
  final String? title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final String? customIllustration;
  final String? lottieAnimation;

  const EmptyState({
    super.key,
    required this.type,
    this.title,
    this.subtitle,
    this.actionText,
    this.onActionPressed,
    this.customIllustration,
    this.lottieAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getEmptyStateConfig();

    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (lottieAnimation != null) ...[
            Lottie.asset(
              renderCache: RenderCache.raster,
              lottieAnimation!,
              width: 280,
            ),
          ] else ...[
            SizedBox(
              width: 210,
              height: 210,
              child: SvgPicture.asset(
                customIllustration ?? config.customIllustration,
              ),
            ),
          ],

          Spacing.horizontal(size: AppSpacing.large),
          Text(
            title ?? config.title,
            style: const TextStyle(
              fontSize: AppFontSizes.xLarge,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),

          Spacing.horizontal(size: AppSpacing.large),
          Text(
            subtitle ?? config.subtitle,
            style: const TextStyle(
              fontSize: AppFontSizes.medium,
              fontWeight: FontWeight.w400,
              color: AppColors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          if (actionText != null && onActionPressed != null) ...[
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: onActionPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 12.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text(
                actionText!,
                style: const TextStyle(
                  fontSize: AppFontSizes.medium,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  _EmptyStateConfig _getEmptyStateConfig() {
    switch (type) {
      case EmptyStateType.noData:
        return _EmptyStateConfig(
          customIllustration: 'assets/images/no_data.svg',
          title: 'No Data Available',
          subtitle: 'There is no data to display at the moment.',
        );

      case EmptyStateType.noSearchResults:
        return _EmptyStateConfig(
          customIllustration: 'assets/images/no_search_result.svg',
          title: 'No Results Found',
          subtitle: 'Try adjusting your search criteria or filters.',
        );

      case EmptyStateType.error:
        return _EmptyStateConfig(
          customIllustration: 'assets/images/error.svg',
          title: 'Something Went Wrong',
          subtitle: 'We encountered an error while loading the data.',
        );

      case EmptyStateType.loading:
        return _EmptyStateConfig(
          customIllustration: 'assets/images/loading.svg',
          title: 'Loading...',
          subtitle: 'Please wait while we fetch the data.',
          lottieAnimation: 'assets/anim/loading_anim.json',
        );

      case EmptyStateType.noVehicles:
        return _EmptyStateConfig(
          customIllustration: 'assets/images/no_vehicle.svg',
          title: 'No Vehicles',
          subtitle: 'No vehicles have been recorded yet.',
        );
      case EmptyStateType.pageNotFound:
        return _EmptyStateConfig(
          customIllustration: 'assets/images/page_not_found.svg',
          title: 'Sorry Page Not Found',
          subtitle: 'The page you are looking for does not exist.',
        );
    }
  }
}

class _EmptyStateConfig {
  final String customIllustration;
  final String title;
  final String subtitle;
  final String? lottieAnimation;

  _EmptyStateConfig({
    required this.customIllustration,
    required this.title,
    required this.subtitle,
    this.lottieAnimation,
  });
}
