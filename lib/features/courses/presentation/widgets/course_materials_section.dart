import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/features/courses/data/models/course_content_model.dart';
import 'package:nuigate/features/courses/presentation/widgets/course_material_tile.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class CourseMaterialsSection extends StatelessWidget {
  final dynamic courseContent;

  const CourseMaterialsSection({super.key, required this.courseContent});

  List<CourseContentModel> _extractContents(dynamic content) {
    if (content == null) return [];
    if (content is List) {
      return content
          .whereType<Map<String, dynamic>>()
          .map((e) => CourseContentModel.fromJson(e))
          .toList();
    }
    if (content is Map<String, dynamic>) {
      final list = content['contents'] ?? content['data'];
      if (list is List) {
        return list
            .whereType<Map<String, dynamic>>()
            .map((e) => CourseContentModel.fromJson(e))
            .toList();
      }
    }
    return [];
  }

  IconData _iconForType(String? type) {
    final t = type?.toLowerCase() ?? '';
    if (t.contains('video')) return Icons.video_library;
    if (t.contains('pdf') || t.contains('file')) return Icons.file_present;
    if (t.contains('summary') || t.contains('ملخص')) return Icons.summarize;
    if (t.contains('ref') || t.contains('مرجع')) return Icons.book;
    return Icons.school;
  }

  void _openContent(BuildContext context, CourseContentModel content) {
    final url = content.fileUrl;
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('رابط المحتوى غير متاح')));
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('فتح: ${content.lectureName}')));
  }

  @override
  Widget build(BuildContext context) {
    final contents = _extractContents(courseContent);

    if (contents.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.folder_open, size: 48.r, color: Colors.grey),
              SizedBox(height: 12.h),
              const CustomText(
                'لا يوجد محتوى متاح حاليا',
                fontSize: 14,
                color: Colors.grey,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        ...contents.map((content) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: CourseMaterialTile(
              icon: _iconForType(content.contentType),
              title: content.lectureName,
              subtitle: content.contentType ?? 'محاضرة',
              onTap: () => _openContent(context, content),
            ),
          );
        }),
      ],
    );
  }
}
