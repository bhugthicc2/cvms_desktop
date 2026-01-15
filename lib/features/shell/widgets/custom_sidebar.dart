import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/features/shell/models/nav_item.dart';
import 'package:cvms_desktop/features/shell/widgets/custom_sidebar_header.dart';
import 'package:cvms_desktop/features/shell/widgets/custom_sidebar_tile.dart';
import 'package:cvms_desktop/features/shell/widgets/selected_tile.dart';
import 'package:flutter/material.dart';

class CustomSidebar extends StatelessWidget {
  final bool isExpanded;
  final int selectedIndex;
  final Function(int) onItemSelected;
  final VoidCallback onToggle;
  final VoidCallback onLogout;

  CustomSidebar({
    super.key,
    required this.isExpanded,
    required this.selectedIndex,
    required this.onItemSelected,
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
    NavItem(icon: 'analytics.png', label: "Reports"),
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
            AppColors.darkBlue.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Column(
        children: [
          CustomSidebarHeader(isExpanded: isExpanded),
          Expanded(
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                // Indicator layer first (behind)
                if (selectedIndex < items.length)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    top: indicatorTop,
                    left: 0,
                    right: 0,
                    height: 126.0,
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: SelectedTile(isExpanded: isExpanded),
                        size: Size.infinite,
                      ),
                    ),
                  ),
                // Content layer second (on top)
                ListView.builder(
                  itemExtent: tileHeight,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return CustomSidebarTile(
                      hover: () {},
                      item: items[index],
                      isExpanded: isExpanded,
                      isSelected: index == selectedIndex,
                      onTap: () => onItemSelected(index),
                    );
                  },
                ),
              ],
            ),
          ),
          //LOGOUT TILE DAWG
          CustomSidebarTile(
            hover: () {},
            item: NavItem(icon: 'logout.png', label: "Logout"),
            iconColor: AppColors.error,
            labelColor: AppColors.error,
            isExpanded: isExpanded,
            isSelected: false,
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
