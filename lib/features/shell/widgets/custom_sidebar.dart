import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/features/shell/models/nav_item.dart';
import 'package:cvms_desktop/features/shell/widgets/custom_sidebar_header.dart';
import 'package:cvms_desktop/features/shell/widgets/custom_sidebar_tile.dart';
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
    NavItem(icon: 'assets/icons/dashboard.png', label: "Dashboard"),
    NavItem(
      icon: 'assets/icons/vehicle_logs.png',
      label: "Vehicle Logs Management",
    ),
    NavItem(
      icon: 'assets/icons/vehicle_management.png',
      label: "Vehicle Management",
    ),
    NavItem(icon: 'assets/icons/user.png', label: "User Management"),
    NavItem(icon: 'assets/icons/violation.png', label: "Violation Management"),
    NavItem(icon: 'assets/icons/analytics.png', label: "Reports and Analytics"),
    NavItem(icon: 'assets/icons/activity.png', label: "Activity Logs"),
    NavItem(icon: 'assets/icons/profile.png', label: "Profile"),
    NavItem(icon: 'assets/icons/setting.png', label: "Settings"),
  ];

  @override
  Widget build(BuildContext context) {
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
            child: ListView.builder(
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
          ),
          //LOGOUT TILE DAWG
          CustomSidebarTile(
            hover: () {},
            item: NavItem(icon: 'assets/icons/logout.png', label: "Logout"),
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
