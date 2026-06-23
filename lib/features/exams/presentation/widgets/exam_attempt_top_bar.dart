import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/exams/presentation/widgets/exam_timer_badge.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class ExamAttemptTopBar extends StatelessWidget {
  final int currentIndex;
  final int totalQuestions;
  final Duration remaining;

  const ExamAttemptTopBar({
    super.key,
    required this.currentIndex,
    required this.totalQuestions,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomText(
                  'السؤال ${currentIndex + 1}/$totalQuestions',
                  fontWeight: FontWeight.bold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 10.w),
              ExamTimerBadge(remaining: remaining),
            ],
          ),
          SizedBox(height: 10.h),
          LinearProgressIndicator(
            value: totalQuestions == 0
                ? 0
                : (currentIndex + 1) / totalQuestions,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          ),
        ],
      ),
    );
  }
}
