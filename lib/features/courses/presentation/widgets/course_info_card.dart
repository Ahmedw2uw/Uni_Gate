import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/courses/domain/entities/course_entity.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class CourseInfoCard extends StatelessWidget {
  final CourseEntity course;

  const CourseInfoCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.r),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            course.name,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12.h),
          _CourseInfoRow(icon: Icons.person, text: course.instructor),
          SizedBox(height: 8.h),
          _CourseInfoRow(icon: Icons.code, text: 'الكود: ${course.code}'),
          SizedBox(height: 12.h),
          _CreditHoursBadge(creditHours: course.creditHours),
        ],
      ),
    );
  }
}

class _CourseInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _CourseInfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18.r, color: Colors.grey),
        SizedBox(width: 8.w),
        Expanded(
          child: CustomText(
            text,
            fontSize: 14,
            color: Colors.grey[700],
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _CreditHoursBadge extends StatelessWidget {
  final int creditHours;

  const _CreditHoursBadge({required this.creditHours});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.book, size: 16.r, color: AppColors.primary),
          SizedBox(width: 8.w),
          CustomText(
            '$creditHours ساعات معتمدة',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
