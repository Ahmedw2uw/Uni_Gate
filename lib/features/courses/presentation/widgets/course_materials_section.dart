import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/features/courses/data/models/course_content_model.dart';
import 'package:nuigate/features/courses/presentation/widgets/course_material_tile.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseMaterialsSection extends StatelessWidget {
  final dynamic courseContent;

  const CourseMaterialsSection({super.key, required this.courseContent});

  List<CourseContentModel> _extractContents(dynamic content) {
    if (content == null) return [];

    if (content is List<CourseContentModel>) return content;

    if (content is List) {
      return content
          .map((item) {
            if (item is CourseContentModel) return item;
            if (item is Map<String, dynamic>) {
              return CourseContentModel.fromJson(item);
            }
            if (item is Map) {
              return CourseContentModel.fromJson(
                Map<String, dynamic>.from(item),
              );
            }
            return null;
          })
          .whereType<CourseContentModel>()
          .toList();
    }

    if (content is Map<String, dynamic>) {
      final list = content['contents'] ?? content['content'] ?? content['data'];
      return _extractContents(list);
    }

    if (content is Map) {
      final list = content['contents'] ?? content['content'] ?? content['data'];
      return _extractContents(list);
    }

    return [];
  }

  IconData _iconForType(String? type) {
    final value = type?.toLowerCase() ?? '';
    if (value.contains('video') || value == '1') return Icons.video_library;
    if (value.contains('pdf') || value.contains('file') || value == '0') {
      return Icons.file_present;
    }
    if (value.contains('summary') || value.contains('ملخص')) {
      return Icons.summarize;
    }
    if (value.contains('ref') || value.contains('مرجع')) return Icons.book;
    return Icons.school;
  }

  Uri? _resolveFileUri(String rawUrl) {
    final value = rawUrl.trim();
    if (value.isEmpty) return null;

    final parsed = Uri.tryParse(value);
    if (parsed != null && parsed.hasScheme) return parsed;

    if (value.startsWith('/')) {
      return Uri.tryParse('http://uni-gate.runasp.net$value');
    }

    return null;
  }

  Future<void> _downloadContent(
    BuildContext context,
    CourseContentModel content,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final uri = _resolveFileUri(content.fileUrl ?? '');

    if (uri == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('رابط تحميل المحتوى غير متاح')),
      );
      if (kDebugMode) {
        debugPrint(
          'DEBUG CourseMaterialsSection.download -> missing/invalid fileUrl for contentId=${content.id}',
        );
      }
      return;
    }

    if (kDebugMode) {
      debugPrint(
        'DEBUG CourseMaterialsSection.download -> contentId=${content.id} title=${content.lectureName} uri=$uri',
      );
    }

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      messenger.showSnackBar(
        const SnackBar(content: Text('تعذر فتح رابط التحميل على الجهاز')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final contents = _extractContents(courseContent)
      ..sort((a, b) => (a.orderIndex ?? 0).compareTo(b.orderIndex ?? 0));

    if (contents.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.folder_open, size: 48.r, color: Colors.grey),
              SizedBox(height: 12.h),
              const CustomText(
                'لا يوجد محتوى متاح حالياً',
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
      children: contents.map((content) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: CourseMaterialTile(
            icon: _iconForType(content.contentType),
            title: content.lectureName.isEmpty
                ? 'محاضرة بدون عنوان'
                : content.lectureName,
            subtitle: content.contentType ?? 'محاضرة',
            onTap: () => _downloadContent(context, content),
          ),
        );
      }).toList(),
    );
  }
}
