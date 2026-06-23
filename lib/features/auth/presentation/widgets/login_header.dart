import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6.r,
                ),
              ],
            ),
            child: ImageIcon(
              const AssetImage('assets/p_icon.png'),
              size: 48.r,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 12.h),
          const CustomText(
            'بوابة الدخول',
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: 4.h),
          const CustomText('تسجيل الدخول', fontSize: 14, color: Colors.black54),
        ],
      ),
    );
  }
}
