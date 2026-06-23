import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/exams/data/exam_info.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class ExamOptionTile extends StatelessWidget {
  final ExamOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const ExamOptionTile({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(15.r),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05)
              : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? AppColors.primary : Colors.grey,
              size: 22.r,
            ),
            SizedBox(width: 12.w),
            Expanded(child: CustomText(option.optionText, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
