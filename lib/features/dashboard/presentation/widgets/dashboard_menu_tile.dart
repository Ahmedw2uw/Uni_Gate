import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: 40.r, color: AppColors.primary),
              SizedBox(height: 10.h),
              CustomText(
                item.label,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
