import 'package:flutter/material.dart';
import 'package:nuigate/features/exams/data/exam_info.dart';
import 'package:nuigate/features/exams/presentation/widgets/exam_option_tile.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class ExamQuestionCard extends StatelessWidget {
  final ExamQuestion question;
  final int? selectedOptionId;
  final ValueChanged<int> onOptionSelected;

  const ExamQuestionCard({
    super.key,
    required this.question,
    required this.selectedOptionId,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              question.text,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 20),
            ...question.options.map(
              (option) => ExamOptionTile(
                option: option,
                isSelected: selectedOptionId == option.id,
                onTap: () => onOptionSelected(option.id),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
