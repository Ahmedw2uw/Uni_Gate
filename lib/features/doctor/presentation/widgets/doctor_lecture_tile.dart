import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/doctor/domain/entities/doctor_lecture_entity.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class DoctorLectureTile extends StatelessWidget {
  final DoctorLectureEntity lecture;
  final bool isDeleting;
  final VoidCallback onDownload;
  final VoidCallback onDelete;

  const DoctorLectureTile({
    super.key,
    required this.lecture,
    required this.isDeleting,
    required this.onDownload,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isVideo =
        lecture.contentType.toLowerCase().contains('video') ||
        lecture.fileUrl.toLowerCase().contains('.mp4');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40.r,
            height: 40.r,
            child: IconButton(
              tooltip: 'حذف',
              padding: EdgeInsets.zero,
              onPressed: isDeleting ? null : onDelete,
              icon: Icon(Icons.delete_outline, color: Colors.red, size: 22.r),
            ),
          ),
          SizedBox(
            width: 40.r,
            height: 40.r,
            child: IconButton(
              tooltip: 'تنزيل',
              padding: EdgeInsets.zero,
              onPressed: onDownload,
              icon: Icon(
                Icons.download_outlined,
                color: AppColors.primary,
                size: 22.r,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomText(
                  lecture.lectureName,
                  fontWeight: FontWeight.w700,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 3.h),
                CustomText(
                  _formatMeta(lecture),
                  fontSize: 11,
                  color: Colors.black45,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Icon(
            isVideo
                ? Icons.video_camera_back_outlined
                : Icons.picture_as_pdf_outlined,
            color: AppColors.primary,
            size: 20.r,
          ),
        ],
      ),
    );
  }

  String _formatMeta(DoctorLectureEntity lecture) {
    final date = lecture.availableFrom;
    if (date == null) return lecture.contentType;
    return '${lecture.contentType} - ${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
