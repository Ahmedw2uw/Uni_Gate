import 'package:flutter/material.dart';
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
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (context, index) => CourseCard(course: courses[index]),
      ),
    );
  }
}
