import 'package:flutter/material.dart';
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
      borderRadius: BorderRadius.circular(8),
      child: Container(
        constraints: const BoxConstraints(minHeight: 58),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black26),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.upload_file_outlined, color: Colors.black54),
            const SizedBox(width: 8),
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
