import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class DoctorLectureUploadBox extends StatelessWidget {
  final String? selectedFileName;
  final VoidCallback? onTap;

  const DoctorLectureUploadBox({super.key, this.selectedFileName, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        constraints: BoxConstraints(minHeight: 58.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.black26),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.upload_file_outlined, color: Colors.black54, size: 22.r),
            SizedBox(width: 8.w),
            Flexible(
              child: CustomText(
                selectedFileName ?? 'اختر ملف PDF أو Video',
                color: selectedFileName == null
                    ? Colors.black54
                    : AppColors.primary,
                fontSize: 13,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
