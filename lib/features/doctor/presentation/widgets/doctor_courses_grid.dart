import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/features/doctor/domain/entities/doctor_course_entity.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_navigation_cubit.dart';
import 'package:nuigate/features/doctor/presentation/widgets/doctor_course_card.dart';

class DoctorCoursesGrid extends StatelessWidget {
  final List<DoctorCourseEntity> courses;

  const DoctorCoursesGrid({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 700;
        final crossAxisCount = isTablet ? 2 : 1;

        if (!isTablet) {
          return ListView.separated(
            padding: EdgeInsets.all(16.r),
            itemCount: courses.length,
            separatorBuilder: (_, _) => SizedBox(height: 12.h),
            itemBuilder: (context, index) =>
                _CourseItem(course: courses[index]),
          );
        }

        return GridView.builder(
          padding: EdgeInsets.all(18.r),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 14.w,
            mainAxisSpacing: 14.h,
            childAspectRatio: 1.75,
          ),
          itemCount: courses.length,
          itemBuilder: (context, index) => _CourseItem(course: courses[index]),
        );
      },
    );
  }
}

class _CourseItem extends StatelessWidget {
  final DoctorCourseEntity course;

  const _CourseItem({required this.course});

  @override
  Widget build(BuildContext context) {
    return DoctorCourseCard(
      course: course,
      onTap: () {
        context.read<DoctorNavigationCubit>().openCourseLectures(course);
      },
    );
  }
}
