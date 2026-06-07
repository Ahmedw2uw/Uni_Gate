import 'package:flutter/material.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/core/service_locator.dart';
import 'package:nuigate/features/courses/domain/entities/course_entity.dart';
import 'package:nuigate/features/courses/logic/cubit/courses_state.dart';
import 'package:nuigate/features/courses/presentation/view/course_content_page.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class CourseCard extends StatelessWidget {
  final CourseEntity course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            course.name,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
          const SizedBox(height: 8),
          CustomText(course.code, fontSize: 14, color: Colors.black54),
          CustomText(course.instructor, fontSize: 14, color: Colors.black54),
          const SizedBox(height: 16),
          _ViewContentButton(courseId: course.id, courseName: course.name),
        ],
      ),
    );
  }
}

class _ViewContentButton extends StatelessWidget {
  final String courseId;
  final String courseName;

  const _ViewContentButton({required this.courseId, required this.courseName});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: () async {
          debugPrint('Course ID: $courseId, Course Name: $courseName');
          ServiceLocator.coursesCubit.fetchCourseContent(courseId);

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CourseContentPage(courseId: courseId, courseName: courseName),
            ),
          );

          if (ServiceLocator.coursesCubit.state is CourseContentSuccess ||
              ServiceLocator.coursesCubit.state is CourseContentFailure) {
            ServiceLocator.coursesCubit.fetchCourses();
          }
        },
        child: const CustomText(
          'عرض المحتوى',
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
