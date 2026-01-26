import 'package:cvms_desktop/core/theme/sidebar_theme.dart';
import 'package:cvms_desktop/core/widgets/layout/custom_divider.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
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
  final bool isStencil;

  CustomSidebar({
    super.key,
    required this.isExpanded,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.activeStyle,
    required this.onToggle,
    required this.onLogout,
    this.isStencil = true,
  });

  final List<NavItem> items = [
    NavItem(icon: 'dashboard.png', label: "Dashboard"),
    NavItem(icon: 'vehicle_monitoring.png', label: "Vehicle Monitoring"),
    NavItem(icon: 'vehicle.png', label: "Vehicle Logs"),
    NavItem(icon: 'vehicle_type.png', label: "Vehicle Management"),
    NavItem(icon: 'user.png', label: "User Management"),
    NavItem(icon: 'violation.png', label: "Violation Management"),
    NavItem(icon: 'activity2.png', label: "Activity Logs"),
    NavItem(icon: 'profile.png', label: "Profile"),
    NavItem(icon: 'gear.png', label: "Settings"),
  ];

  @override
  Widget build(BuildContext context) {
    final sidebarTheme = SidebarTheme.fromCubit(context);

    final double tileHeight = 42.0;
    final double indicatorOffset = 63.0; // Half of 126 for centering
    final double indicatorTop = selectedIndex * tileHeight - indicatorOffset;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isExpanded ? 235 : 52,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [sidebarTheme.background, sidebarTheme.background],
        ),
        image:
            sidebarTheme == SidebarTheme.dark
                ? DecorationImage(
                  opacity: 0.7,
                  image: const AssetImage("assets/images/sidebar_bg.png"),
                  fit: BoxFit.cover,
                )
                : null,
        border:
            sidebarTheme == SidebarTheme.light
                ? Border(
                  right: BorderSide(
                    color: sidebarTheme.dividerColor,
                    width: 2.0,
                  ),
                )
                : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomSidebarHeader(isExpanded: isExpanded),
          Spacing.vertical(size: 2),
          Expanded(
            child:
                activeStyle == SidebarActiveStyle.curvedIndicator
                    ? _buildCurved(
                      context,
                      indicatorTop,
                      tileHeight,
                      indicatorOffset,
                    )
                    : _buildSideBorder(context),
          ),
          //LOGOUT TILE DAWG
          CustomDivider(
            direction: Axis.horizontal,
            thickness: 0.5,
            color: sidebarTheme.dividerColor.withValues(alpha: 0.4),
          ),
          CustomSidebarTile(
            isLogoutTile: true,
            item: NavItem(icon: 'logout.png', label: "Logout"),
            iconColor: sidebarTheme.logoutIcon,
            labelColor: sidebarTheme.logoutIcon,
            isExpanded: isExpanded,
            isSelected: false,
            onTap: onLogout,
            showActiveBorder: false,
            isStencil: isStencil,
          ),
        ],
      ),
    );
  }

  Widget _buildSideBorder(BuildContext context) {
    final sidebarTheme = SidebarTheme.of(context);
    return ListView.builder(
      itemExtent: 46,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return CustomSidebarTile(
          item: items[index],
          isExpanded: isExpanded,
          isSelected: index == selectedIndex,
          onTap: () => onItemSelected(index),
          showActiveBorder: true,
          isStencil: isStencil,
          labelColor: sidebarTheme.primaryText,
        );
      },
    );
  }

  Widget _buildCurved(
    BuildContext context,
    double indicatorTop,
    double tileHeight,
    double indicatorOffset,
  ) {
    final sidebarTheme = SidebarTheme.of(context);
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
              labelColor: sidebarTheme.primaryText,
              item: items[index],
              isExpanded: isExpanded,
              isSelected: index == selectedIndex,
              onTap: () => onItemSelected(index),
              showActiveBorder: false,
              isStencil: isStencil,
            );
          },
        ),
      ],
    );
  }
}
