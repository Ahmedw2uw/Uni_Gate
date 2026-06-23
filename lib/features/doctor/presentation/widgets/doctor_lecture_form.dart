import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CustomText('عنوان المحاضرة', fontWeight: FontWeight.w700),
          const SizedBox(height: 8),
          TextField(
            controller: titleController,
            textDirection: TextDirection.rtl,
            enabled: !isUploading,
            decoration: InputDecoration(
              hintText: 'أدخل عنوان المحاضرة',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const CustomText(
            'رفع الملف (PDF أو Video)',
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 8),
          DoctorLectureUploadBox(
            selectedFileName: selectedFile?.name,
            onTap: isUploading ? null : onPickFile,
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 96,
              height: 42,
              child: FilledButton(
                onPressed: isUploading ? null : onUpload,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isUploading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
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
