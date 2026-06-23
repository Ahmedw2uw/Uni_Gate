import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/courses/domain/entities/course_entity.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class AvailableCourseCard extends StatelessWidget {
  final CourseEntity course;
  final bool isSelected;
  final ValueChanged<bool?> onToggle;

  const AvailableCourseCard({
    super.key,
    required this.course,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.grey[200]!,
          width: isSelected ? 2.w : 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Row(
          children: [
            Checkbox(
              value: isSelected,
              onChanged: onToggle,
              activeColor: AppColors.primary,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    course.name,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    'الكود: ${course.code}',
                    fontSize: 12,
                    color: Colors.black54,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (course.instructor.isNotEmpty)
                    CustomText(
                      'الدكتور: ${course.instructor}',
                      fontSize: 12,
                      color: Colors.black54,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: CustomText(
                    '${course.creditHours} ساعة',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 6.h),
                CustomText(
                  '${course.price.toStringAsFixed(0)} ج.م',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[700],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
