import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomText(
                  exam.title,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              _ExamStatusBadge(exam: exam),
            ],
          ),
          Divider(height: 24.h),
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
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: canStart
                    ? const Color(0xFF10B981)
                    : Colors.grey.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              onPressed: canStart ? onStart : null,
              child: CustomText(
                _buttonLabel,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
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
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18.r,
            color: AppColors.primary.withValues(alpha: 0.6),
          ),
          SizedBox(width: 8.w),
          CustomText(label, fontSize: 13, color: Colors.grey.shade600),
          SizedBox(width: 4.w),
          Expanded(
            child: CustomText(
              value,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
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
    if (exam.alreadySubmitted) return const _ExamStatus('مكتمل', Colors.blue);
    if (exam.isActive) return const _ExamStatus('نشط', Colors.green);
    return const _ExamStatus('مغلق', Colors.red);
  }
}

class _ExamStatus {
  final String label;
  final Color color;

  const _ExamStatus(this.label, this.color);
}
