import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/courses/domain/entities/course_entity.dart';
import 'package:nuigate/features/courses/logic/cubit/courses_cubit.dart';
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
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      padding: EdgeInsets.all(18.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            course.name,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8.h),
          CustomText(
            course.code,
            fontSize: 14,
            color: Colors.black54,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          CustomText(
            course.instructor,
            fontSize: 14,
            color: Colors.black54,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 16.h),
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
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h),
        ),
        onPressed: () async {
          debugPrint('Course ID: $courseId, Course Name: $courseName');
          context.read<CoursesCubit>().fetchCourseContent(courseId);

          final cubit = context.read<CoursesCubit>();

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CourseContentPage(courseId: courseId, courseName: courseName),
            ),
          );

          if (cubit.state is CourseContentSuccess ||
              cubit.state is CourseContentFailure) {
            cubit.fetchCourses();
          }
        },
        child: const CustomText(
          'عرض المحتوى',
          color: Colors.white,
          fontWeight: FontWeight.w700,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
