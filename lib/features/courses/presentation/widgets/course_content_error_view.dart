import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class CourseContentErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const CourseContentErrorView({
    super.key,
    required this.message,
    required this.onRetry,
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
            Icon(Icons.error_outline, color: Colors.red, size: 64.r),
            SizedBox(height: 16.h),
            const CustomText(
              'فشل تحميل المحتوى',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.red,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            CustomText(
              message,
              fontSize: 14,
              color: Colors.grey[700],
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
