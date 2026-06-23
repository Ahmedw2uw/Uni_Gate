import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class ExamTimerBadge extends StatelessWidget {
  final Duration remaining;

  const ExamTimerBadge({super.key, required this.remaining});

  @override
  Widget build(BuildContext context) {
    final lowTime = remaining.inMinutes < 2;
    final color = lowTime ? Colors.red : AppColors.primary;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer, size: 16.r, color: color),
          SizedBox(width: 4.w),
          CustomText(
            _formatDuration(remaining),
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}';
  }
}
