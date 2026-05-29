import 'package:flutter/material.dart';
import 'package:nuigate/features/exams/data/exam_info.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class ExamCard extends StatelessWidget {
  final ExamInfo exam;
  final VoidCallback onStart;

  const ExamCard({super.key, required this.exam, required this.onStart});

  @override
  Widget build(BuildContext context) {
    // التحقق من صلاحية الدخول للامتحان
    bool canStart = exam.isActive && !exam.alreadySubmitted;

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
              _buildBadge(exam),
            ],
          ),
          const Divider(height: 24),
          _infoRow(Icons.book_outlined, 'المقرر:', exam.courseName),
          _infoRow(Icons.person_outline, 'المحاضر:', exam.instructorName),
          _infoRow(
            Icons.timer_sharp,
            'المدة المتاحة:',
            '${exam.durationMinutes} دقيقة',
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
                exam.alreadySubmitted
                    ? 'تم تسليم الإجابة'
                    : (exam.isActive ? 'بدء الامتحان' : 'غير متاح حالياً'),
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
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

  Widget _buildBadge(ExamInfo exam) {
    String text = exam.isActive ? 'نشط' : 'مغلق';
    Color color = exam.isActive ? Colors.green : Colors.red;
    if (exam.alreadySubmitted) {
      text = 'مكتمل';
      color = Colors.blue;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomText(
        text,
        fontSize: 11,
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
