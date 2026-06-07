import 'package:flutter/material.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/courses/domain/entities/course_entity.dart';
import 'package:nuigate/features/courses/presentation/widgets/course_info_card.dart';
import 'package:nuigate/features/courses/presentation/widgets/course_materials_section.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class CourseContentView extends StatelessWidget {
  final CourseEntity course;
  final dynamic courseContent;

  const CourseContentView({
    super.key,
    required this.course,
    required this.courseContent,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CourseInfoCard(course: course),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  'محتوى المقرر',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 16),
                CourseMaterialsSection(courseContent: courseContent),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
