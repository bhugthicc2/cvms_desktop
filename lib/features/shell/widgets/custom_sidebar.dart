import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/features/shell/config/sidebar_active_style.dart';
import 'package:cvms_desktop/features/shell/models/nav_item.dart';
import 'package:cvms_desktop/features/shell/widgets/custom_sidebar_header.dart';
import 'package:cvms_desktop/features/shell/widgets/custom_sidebar_tile.dart';
import 'package:cvms_desktop/features/shell/widgets/selected_tile.dart';
import 'package:flutter/material.dart';

class CustomSidebar extends StatelessWidget {
  final bool isExpanded;
  final int selectedIndex;
  final SidebarActiveStyle activeStyle;
  final Function(int) onItemSelected;
  final VoidCallback onToggle;
  final VoidCallback onLogout;

  CustomSidebar({
    super.key,
    required this.isExpanded,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.activeStyle,
    required this.onToggle,
    required this.onLogout,
  });

  final List<NavItem> items = [
    NavItem(icon: 'dashboard.png', label: "Dashboard"),
    NavItem(icon: 'vehicle_monitoring.png', label: "Vehicle Monitoring"),
    NavItem(icon: 'vehicle_logs.png', label: "Vehicle Logs Management"),
    NavItem(icon: 'vehicle_management.png', label: "Vehicle Management"),
    NavItem(icon: 'user.png', label: "User Management"),
    NavItem(icon: 'violation.png', label: "Violation Management"),
    NavItem(icon: 'activity.png', label: "Activity Logs"),
    NavItem(icon: 'profile.png', label: "Profile"),
    NavItem(icon: 'settings.png', label: "Settings"),
  ];

  @override
  Widget build(BuildContext context) {
    final double tileHeight = 42.0;
    final double indicatorOffset = 63.0; // Half of 126 for centering
    final double indicatorTop = selectedIndex * tileHeight - indicatorOffset;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isExpanded ? 235 : 50,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage("assets/images/sidebar_bg.png"),
          fit: BoxFit.cover,
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.darkBlue.withValues(alpha: 0.7),
            AppColors.black.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSidebarHeader(isExpanded: isExpanded),
          Expanded(
            child:
                activeStyle == SidebarActiveStyle.curvedIndicator
                    ? _buildCurved(indicatorTop, tileHeight, indicatorOffset)
                    : _buildSideBorder(),
          ),
          //LOGOUT TILE DAWG
          CustomSidebarTile(
            item: NavItem(icon: 'logout.png', label: "Logout"),
            iconColor: AppColors.error,
            labelColor: AppColors.error,
            isExpanded: isExpanded,
            isSelected: false,
            onTap: onLogout,
            showActiveBorder: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSideBorder() {
    return ListView.builder(
      itemExtent: 42,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return CustomSidebarTile(
          item: items[index],
          isExpanded: isExpanded,
          isSelected: index == selectedIndex,
          onTap: () => onItemSelected(index),
          showActiveBorder: true,

          labelColor: AppColors.white,
        );
      },
    );
  }

  Widget _buildCurved(
    double indicatorTop,
    double tileHeight,
    double indicatorOffset,
  ) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          top: indicatorTop,
          left: 0,
          right: 0,
          height: 126,
          child: IgnorePointer(
            child: CustomPaint(painter: SelectedTile(isExpanded: isExpanded)),
          ),
        ),
        ListView.builder(
          itemExtent: tileHeight,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return CustomSidebarTile(
              labelColor: AppColors.white,
              item: items[index],
              isExpanded: isExpanded,
              isSelected: index == selectedIndex,
              onTap: () => onItemSelected(index),
              showActiveBorder: false, // 🔥 IMPORTANT
            );
          },
        ),
      ],
    );
  }
}
