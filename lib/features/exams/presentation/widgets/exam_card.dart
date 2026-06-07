import 'package:flutter/material.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/exams/data/exam_info.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class ExamCard extends StatelessWidget {
  final ExamInfo exam;
  final VoidCallback onStart;

  const ExamCard({super.key, required this.exam, required this.onStart});

  @override
  Widget build(BuildContext context) {
    final canStart = exam.isActive && !exam.alreadySubmitted;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomText(
                  exam.title,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              _ExamStatusBadge(exam: exam),
            ],
          ),
          const Divider(height: 24),
          _ExamInfoRow(
            icon: Icons.book_outlined,
            label: 'المقرر:',
            value: exam.courseName,
          ),
          _ExamInfoRow(
            icon: Icons.person_outline,
            label: 'المحاضر:',
            value: exam.instructorName,
          ),
          _ExamInfoRow(
            icon: Icons.timer_sharp,
            label: 'المدة المتاحة:',
            value: '${exam.durationMinutes} دقيقة',
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: canStart
                    ? const Color(0xFF10B981)
                    : Colors.grey.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: canStart ? onStart : null,
              child: CustomText(
                _buttonLabel,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String get _buttonLabel {
    if (exam.alreadySubmitted) return 'تم تسليم الإجابة';
    if (exam.isActive) return 'بدء الامتحان';
    return 'غير متاح حاليا';
  }
}

class _ExamInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ExamInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary.withValues(alpha: 0.6)),
          const SizedBox(width: 8),
          CustomText(label, fontSize: 13, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Expanded(
            child: CustomText(value, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _ExamStatusBadge extends StatelessWidget {
  final ExamInfo exam;

  const _ExamStatusBadge({required this.exam});

  @override
  Widget build(BuildContext context) {
    final status = _resolveStatus();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomText(
        status.label,
        fontSize: 11,
        color: status.color,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  _ExamStatus _resolveStatus() {
    if (exam.alreadySubmitted) {
      return const _ExamStatus('مكتمل', Colors.blue);
    }
    if (exam.isActive) {
      return const _ExamStatus('نشط', Colors.green);
    }
    return const _ExamStatus('مغلق', Colors.red);
  }
}

class _ExamStatus {
  final String label;
  final Color color;

  const _ExamStatus(this.label, this.color);
}
