import 'package:cvms_desktop/core/widgets/custom_snackbar.dart';
import 'package:cvms_desktop/features/shell/models/nav_item.dart';
import 'package:cvms_desktop/features/shell/widgets/custom_sidebar_header.dart';
import 'package:cvms_desktop/features/shell/widgets/custom_sidebar_tile.dart';
import 'package:flutter/material.dart';

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
    NavItem(icon: Icons.dashboard, label: "Dashboard"),
    NavItem(icon: Icons.visibility, label: "Vehicle Monitoring"),
    NavItem(icon: Icons.car_rental, label: "Vehicle Management"),
    NavItem(icon: Icons.person, label: "User Management"),
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
            item: NavItem(icon: Icons.logout, label: "Logout"),
            isExpanded: isExpanded,
            isSelected: false,
            onTap:
                () => CustomSnackBar.show(
                  context: context,
                  message: 'Tile pressed',
                  type: SnackBarType.success,
                ),
          ),
          IconButton(
            icon: Icon(
              isExpanded ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
              color: Colors.white,
            ),
            onPressed: onToggle,
          ),
        ],
      ),
    );
  }
}
