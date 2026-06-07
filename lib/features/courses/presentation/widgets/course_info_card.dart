import 'package:flutter/material.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/courses/domain/entities/course_entity.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class CourseInfoCard extends StatelessWidget {
  final CourseEntity course;

  const CourseInfoCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            course.name,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),
          _CourseInfoRow(icon: Icons.person, text: course.instructor),
          const SizedBox(height: 8),
          _CourseInfoRow(icon: Icons.code, text: 'الكود: ${course.code}'),
          const SizedBox(height: 12),
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
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.book, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
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
