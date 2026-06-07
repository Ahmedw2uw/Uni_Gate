import 'package:flutter/material.dart';
import 'package:nuigate/features/exams/data/exam_info.dart';
import 'package:nuigate/features/exams/presentation/widgets/exam_card.dart';

class ExamsList extends StatelessWidget {
  final List<ExamInfo> exams;
  final ValueChanged<ExamInfo> onStartExam;

  const ExamsList({super.key, required this.exams, required this.onStartExam});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: exams.length,
      itemBuilder: (context, index) {
        final exam = exams[index];
        return ExamCard(exam: exam, onStart: () => onStartExam(exam));
      },
    );
  }
}
