import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class DoctorPlaceholderTab extends StatelessWidget {
  final String title;
  final IconData icon;

  const DoctorPlaceholderTab({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 54.r, color: AppColors.primary),
            SizedBox(height: 14.h),
            CustomText(
              title,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            const CustomText(
              'سيتم بناء هذه الشاشة في المرحلة التالية حسب الصورة التفصيلية الخاصة بها.',
              color: Colors.black54,
              fontSize: 14,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
