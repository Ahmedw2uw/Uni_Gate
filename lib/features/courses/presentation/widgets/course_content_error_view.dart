import 'package:flutter/material.dart';
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
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            const CustomText(
              'فشل تحميل المحتوى',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
            const SizedBox(height: 8),
            CustomText(
              message,
              fontSize: 14,
              color: Colors.grey[700],
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
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
