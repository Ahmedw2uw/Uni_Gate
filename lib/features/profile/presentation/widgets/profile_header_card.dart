import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/auth/data/models/user_model.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class ProfileHeaderCard extends StatelessWidget {
  final UserModel user;

  const ProfileHeaderCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50.r,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            backgroundImage: user.profileImage != null
                ? NetworkImage(user.profileImage!)
                : null,
            child: user.profileImage == null
                ? Icon(Icons.person, size: 50.r, color: AppColors.primary)
                : null,
          ),
          SizedBox(height: 15.h),
          CustomText(
            user.name,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 5.h),
          CustomText(
            user.studentCode ?? '',
            color: Colors.grey,
            fontSize: 14,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
