import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/features/courses/domain/entities/course_entity.dart';
import 'package:nuigate/features/courses/presentation/widgets/course_card.dart';

class CoursesList extends StatelessWidget {
  final List<CourseEntity> courses;
  final RefreshCallback onRefresh;

  const CoursesList({
    super.key,
    required this.courses,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 700) {
            return GridView.builder(
              padding: EdgeInsets.all(16.r),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 1.8,
              ),
              itemCount: courses.length,
              itemBuilder: (context, index) =>
                  CourseCard(course: courses[index]),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(16.r),
            itemCount: courses.length,
            separatorBuilder: (_, _) => SizedBox(height: 16.h),
            itemBuilder: (context, index) => CourseCard(course: courses[index]),
          );
        },
      ),
    );
  }
}
