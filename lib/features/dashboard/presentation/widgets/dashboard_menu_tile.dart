import 'package:flutter/material.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/dashboard/presentation/widgets/dashboard_menu_item.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class DashboardMenuTile extends StatelessWidget {
  final DashboardMenuItem item;
  final VoidCallback onTap;

  const DashboardMenuTile({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 40, color: AppColors.primary),
            const SizedBox(height: 10),
            CustomText(item.label, fontWeight: FontWeight.bold),
          ],
        ),
      ),
    );
  }
}
