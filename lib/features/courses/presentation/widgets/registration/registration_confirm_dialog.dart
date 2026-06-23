import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class RegistrationConfirmDialog extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onConfirm;

  const RegistrationConfirmDialog({
    super.key,
    required this.selectedCount,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: Row(
        children: [
          Icon(Icons.help_outline, color: AppColors.primary, size: 22.r),
          SizedBox(width: 8.w),
          const Expanded(
            child: CustomText(
              'تأكيد التسجيل',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: CustomText(
        'هل أنت متأكد من تسجيل $selectedCount مقرر؟',
        fontSize: 14,
        color: Colors.black87,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const CustomText('إلغاء', color: Colors.grey),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm();
          },
          child: const CustomText('تأكيد', color: Colors.white),
        ),
      ],
    );
  }
}
