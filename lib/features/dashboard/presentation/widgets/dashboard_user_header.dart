import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/auth/data/models/user_model.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class DashboardUserHeader extends StatelessWidget {
  final UserModel user;

  const DashboardUserHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.r),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25.r,
            backgroundColor: Colors.white,
            backgroundImage: user.profileImage != null
                ? NetworkImage(user.profileImage!)
                : null,
            child: user.profileImage == null
                ? Icon(Icons.person, color: AppColors.primary, size: 24.r)
                : null,
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  user.name,
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
                if (user.studentCode != null) ...[
                  SizedBox(height: 4.h),
                  CustomText(
                    'كود: ${user.studentCode}',
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
