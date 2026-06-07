import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          if (currentIndex > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: onPrevious,
                child: const CustomText('السابق'),
              ),
            ),
          if (currentIndex > 0) const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: onNextOrSubmit,
              child: CustomText(
                isLastQuestion ? 'إنهاء وتسليم' : 'التالي',
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
