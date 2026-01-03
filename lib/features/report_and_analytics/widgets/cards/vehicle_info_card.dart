import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';

class VehicleInfoCard extends StatelessWidget {
  const VehicleInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border(top: BorderSide(width: 5, color: AppColors.donutBlue)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section: Name and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.network(
                    'https://tse2.mm.bing.net/th/id/OIP.MZIuB6BLbGUkcLQ77aKPuAHaHD?rs=1&pid=ImgDetMain&o=7&rm=3',
                    height: 50,
                    width: 50,
                  ),
                  Spacing.horizontal(size: AppSpacing.small),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rosa Alvarez",
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "ID: KC-22-A-BEV5 • CBA Department",
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              _buildStatusBadge("Offsite"),
            ],
          ),
          const Divider(height: 32),

          // Body: Two Column Layout
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Column 1: Vehicle Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                        Icons.directions_car,
                        "Vehicle Details",
                      ),
                      _buildDetailRow("Model", "Honda CR-V"),
                      _buildDetailRow("Plate Number", "CDE-7890", isBold: true),
                      _buildDetailRow("Color", "White"),
                      _buildDetailRow("Type", "Four-wheeled"),
                    ],
                  ),
                ),
                const VerticalDivider(width: 32),
                // Column 2: Registration & Address
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(Icons.assignment_ind, "Registration"),
                      _buildDetailRow("OR Number", "OR-2024-0109"),
                      _buildDetailRow("CR Number", "CR-2024-0109"),
                      _buildDetailRow("License", "D20-890123"),
                      _buildDetailRow("Contact", "0917 567 8901"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.donutBlue),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.5)),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: Colors.orange,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
