import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 80.r,
              color: isError
                  ? Colors.red.withValues(alpha: 0.7)
                  : AppColors.primary.withValues(alpha: 0.5),
            ),
            SizedBox(height: 24.h),
            CustomText(
              title,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            CustomText(
              subtitle,
              fontSize: 14,
              color: Colors.black54,
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            if (showRetry) ...[
              SizedBox(height: 32.h),
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
