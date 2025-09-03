import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/custom_snackbar.dart';
import 'package:cvms_desktop/features/shell/models/nav_item.dart';
import 'package:cvms_desktop/features/shell/widgets/custom_sidebar_header.dart';
import 'package:cvms_desktop/features/shell/widgets/custom_sidebar_tile.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomSidebar extends StatelessWidget {
  final bool isExpanded;
  final int selectedIndex;
  final Function(int) onItemSelected;
  final VoidCallback onToggle;

  CustomSidebar({
    super.key,
    required this.isExpanded,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onToggle,
  });

  final List<NavItem> items = [
    NavItem(icon: PhosphorIconsRegular.squaresFour, label: "Dashboard"),
    NavItem(icon: PhosphorIconsRegular.eye, label: "Vehicle Monitoring"),
    NavItem(icon: PhosphorIconsRegular.motorcycle, label: "Vehicle Management"),
    NavItem(icon: PhosphorIconsRegular.users, label: "User Management"),
    NavItem(icon: PhosphorIconsRegular.warning, label: "Violation Management"),
    NavItem(
      icon: PhosphorIconsRegular.chartLineUp,
      label: "Reports and Analytics",
    ),
    NavItem(icon: PhosphorIconsRegular.gearFine, label: "Settings"),
    NavItem(icon: PhosphorIconsRegular.userCircle, label: "Profile"),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isExpanded ? 250 : 70,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/sidebar_bg.png"),
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
                  item: items[index],
                  isExpanded: isExpanded,
                  isSelected: index == selectedIndex,
                  onTap: () => onItemSelected(index),
                );
              },
            ),
          ),
          CustomSidebarTile(
            item: NavItem(icon: PhosphorIconsRegular.signOut, label: "Logout"),
            iconColor: AppColors.error,
            labelColor: AppColors.error,
            isExpanded: isExpanded,
            isSelected: false,
            onTap:
                () => CustomSnackBar.show(
                  context: context,
                  message: 'Tile pressed',
                  type: SnackBarType.success,
                ),
          ),
        ],
      ),
    );
  }
}
