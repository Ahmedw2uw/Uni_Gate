import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/doctor/domain/entities/doctor_course_entity.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class DoctorCourseCard extends StatelessWidget {
  final DoctorCourseEntity course;
  final VoidCallback onTap;

  const DoctorCourseCard({
    super.key,
    required this.course,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
        side: const BorderSide(color: Color(0xFF9BAAD8)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.all(14.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.menu_book, color: AppColors.primary, size: 22.r),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: CustomText(
                      course.courseName,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              CustomText(
                course.sectionName.isEmpty
                    ? course.courseCode
                    : '${course.courseCode} - ${course.sectionName}',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              CustomText(
                course.departmentName,
                fontSize: 12,
                color: Colors.black54,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 14.h),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                runSpacing: 8.h,
                spacing: 8.w,
                children: [
                  _Metric(label: 'طلاب', value: course.studentCount),
                  _Metric(label: 'تسليمات', value: course.submissionCount),
                  _Metric(label: 'امتحانات', value: course.upcomingExamCount),
                ],
              ),
              SizedBox(height: 12.h),
              SizedBox(
                height: 40.h,
                child: FilledButton(
                  onPressed: onTap,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  child: const CustomText(
                    'إدارة الكورس',
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final int value;

  const _Metric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          value.toString(),
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(width: 4.w),
        CustomText(label, fontSize: 12, color: Colors.black54),
      ],
    );
  }
}
