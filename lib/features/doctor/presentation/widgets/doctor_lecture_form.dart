import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/doctor/presentation/widgets/doctor_lecture_upload_box.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class DoctorLectureForm extends StatelessWidget {
  final TextEditingController titleController;
  final PlatformFile? selectedFile;
  final bool isUploading;
  final VoidCallback onPickFile;
  final VoidCallback onUpload;

  const DoctorLectureForm({
    super.key,
    required this.titleController,
    required this.selectedFile,
    required this.isUploading,
    required this.onPickFile,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CustomText('عنوان المحاضرة', fontWeight: FontWeight.w700),
          SizedBox(height: 8.h),
          TextField(
            controller: titleController,
            textDirection: TextDirection.rtl,
            enabled: !isUploading,
            decoration: InputDecoration(
              hintText: 'أدخل عنوان المحاضرة',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 12.h,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          const CustomText(
            'رفع الملف (PDF أو Video)',
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: 8.h),
          DoctorLectureUploadBox(
            selectedFileName: selectedFile?.name,
            onTap: isUploading ? null : onPickFile,
          ),
          SizedBox(height: 14.h),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 96.w,
              height: 42.h,
              child: FilledButton(
                onPressed: isUploading ? null : onUpload,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: isUploading
                    ? SizedBox(
                        width: 18.r,
                        height: 18.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const CustomText(
                        'رفع',
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
