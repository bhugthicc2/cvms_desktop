import 'dart:convert';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:cvms_desktop/core/bloc/sidebar_theme_cubit.dart';
import 'package:cvms_desktop/core/bloc/sidebar_theme_state.dart';
import 'package:cvms_desktop/core/bloc/theme_cubit.dart';
import 'package:cvms_desktop/core/bloc/theme_state.dart';
import 'package:cvms_desktop/core/theme/app_dimensions.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_grow.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_window_buttons.dart';
import 'package:cvms_desktop/core/widgets/navigation/bread_crumb_item.dart';
import 'package:cvms_desktop/features/shell/bloc/connectivity_cubit.dart';
import 'package:flutter/material.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final String currentUser;
  final List<Widget>? actions;
  final VoidCallback? onMenuPressed;
  final List<BreadcrumbItem> breadcrumbs;
  final String profileImage;

  const CustomHeader({
    super.key,
    required this.title,
    this.actions,
    this.onMenuPressed,
    required this.currentUser,
    required this.breadcrumbs,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.headerHeight,
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.dividerColor, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        textBaseline: TextBaseline.alphabetic,
        children: [
          HoverGrow(
            hoverScale: 1.1,
            onTap: onMenuPressed,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(PhosphorIconsRegular.list, size: 20),
            ),
          ),
          Spacing.horizontal(size: AppSpacing.medium - 5),

          /// Root (always visible)
          Text(
            title,
            style: TextStyle(
              fontSize: AppFontSizes.medium,
              fontWeight:
                  breadcrumbs.isEmpty ? FontWeight.bold : FontWeight.normal,
              color: breadcrumbs.isEmpty ? AppColors.black : AppColors.grey,
            ),
          ),

          /// Breadcrumbs
          for (int i = 0; i < breadcrumbs.length; i++) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Text('>'),
            ),
            GestureDetector(
              onTap: breadcrumbs[i].onTap,
              child: Text(
                breadcrumbs[i].label,
                style: TextStyle(
                  fontSize: AppFontSizes.medium,
                  fontWeight:
                      i == breadcrumbs.length - 1
                          ? FontWeight.bold
                          : FontWeight.normal,
                  color:
                      i == breadcrumbs.length - 1
                          ? AppColors.black
                          : AppColors.grey,
                ),
              ),
            ),
          ],
          Expanded(child: MoveWindow()),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      profileImage.isNotEmpty
                          ? MemoryImage(base64Decode(profileImage))
                          : const AssetImage('assets/images/profile.png')
                              as ImageProvider,
                ),
                Text(
                  currentUser,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: AppFontSizes.small,
                    height: 1.0,
                  ),
                ),
                Spacing.horizontal(size: AppSpacing.medium),
                Container(
                  height: AppDimensions.headerHeight * 0.4,
                  width: 1,
                  decoration: BoxDecoration(
                    color: AppColors.dividerColor.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Spacing.horizontal(size: AppSpacing.medium),

                BlocBuilder<SidebarThemeCubit, SidebarThemeState>(
                  builder: (context, state) {
                    final isDark = state.isDark;

                    return Tooltip(
                      mouseCursor: SystemMouseCursors.click,
                      message: 'Switch sidebar theme',
                      child: InkWell(
                        onTap: () => context.read<SidebarThemeCubit>().toggle(),
                        borderRadius: BorderRadius.circular(6),
                        child: Icon(
                          isDark
                              ? PhosphorIconsRegular.sun
                              : PhosphorIconsRegular.moon,
                          size: 20,
                          color: isDark ? AppColors.yellow : AppColors.black,
                        ),
                      ),
                    );
                  },
                ),

                Spacing.horizontal(size: AppSpacing.medium),
                Container(
                  height: AppDimensions.headerHeight * 0.4,
                  width: 1,
                  decoration: BoxDecoration(
                    color: AppColors.dividerColor.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.small + 1,
                  ),
                  child: BlocBuilder<ConnectivityCubit, InternetStatus>(
                    builder: (context, status) {
                      IconData icon;
                      Color color;
                      String tooltip;

                      switch (status) {
                        case InternetStatus.connected:
                          icon = PhosphorIconsRegular.wifiHigh;
                          color = AppColors.chartGreen;
                          tooltip = 'Online';
                          break;
                        case InternetStatus.disconnected:
                          icon = PhosphorIconsRegular.wifiSlash;
                          color = AppColors.error;
                          tooltip = 'Offline';
                          break;
                      }

                      return Tooltip(
                        message: tooltip,
                        child: Icon(icon, size: 20, color: color),
                      );
                    },
                  ),
                ),
                Container(
                  height: AppDimensions.headerHeight * 0.4,
                  width: 1,
                  decoration: BoxDecoration(
                    color: AppColors.dividerColor.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
          CustomWindowButtons(
            iconColor: AppColors.black,
            maximizeColor: AppColors.primary,
            minimizeColor: AppColors.primary,
            closeColor: AppColors.error,
          ),
        ],
      ),
    );
  }
}
