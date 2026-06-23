import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class ExamNavigationBar extends StatelessWidget {
  final int currentIndex;
  final int totalQuestions;
  final VoidCallback onPrevious;
  final VoidCallback onNextOrSubmit;

  const ExamNavigationBar({
    super.key,
    required this.currentIndex,
    required this.totalQuestions,
    required this.onPrevious,
    required this.onNextOrSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final isLastQuestion = currentIndex >= totalQuestions - 1;

    return Padding(
      padding: EdgeInsets.all(20.r),
      child: Row(
        children: [
          if (currentIndex > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: onPrevious,
                child: const CustomText('السابق', textAlign: TextAlign.center),
              ),
            ),
          if (currentIndex > 0) SizedBox(width: 12.w),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: onNextOrSubmit,
              child: CustomText(
                isLastQuestion ? 'إنهاء وتسليم' : 'التالي',
                color: Colors.white,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
