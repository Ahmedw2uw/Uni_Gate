import 'package:flutter/material.dart';
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFF9BAAD8)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.menu_book, color: AppColors.primary),
                  const SizedBox(width: 8),
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
              const SizedBox(height: 8),
              CustomText(
                course.sectionName.isEmpty
                    ? course.courseCode
                    : '${course.courseCode} - ${course.sectionName}',
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 4),
              CustomText(
                course.departmentName,
                fontSize: 12,
                color: Colors.black54,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _Metric(label: 'طلاب', value: course.studentCount),
                  _Metric(label: 'تسليمات', value: course.submissionCount),
                  _Metric(label: 'امتحانات', value: course.upcomingExamCount),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 40,
                child: FilledButton(
                  onPressed: onTap,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
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
        const SizedBox(width: 4),
        CustomText(label, fontSize: 12, color: Colors.black54),
      ],
    );
  }
}
