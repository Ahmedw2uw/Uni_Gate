import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/courses/logic/cubit/courses_cubit.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class CoursesEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isError;
  final bool showRetry;

  const CoursesEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isError = false,
    this.showRetry = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: isError
                  ? Colors.red.withValues(alpha: 0.7)
                  : AppColors.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            CustomText(
              title,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            CustomText(
              subtitle,
              fontSize: 14,
              color: Colors.black54,
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
            if (showRetry) ...[
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.read<CoursesCubit>().fetchCourses(),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
