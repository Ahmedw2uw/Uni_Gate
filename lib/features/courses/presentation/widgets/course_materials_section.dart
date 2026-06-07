import 'package:flutter/material.dart';
import 'package:nuigate/features/courses/presentation/widgets/course_material_tile.dart';

class CourseMaterialsSection extends StatelessWidget {
  final dynamic courseContent;

  const CourseMaterialsSection({super.key, required this.courseContent});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CourseMaterialTile(
          icon: Icons.video_library,
          title: 'محاضرات الفيديو',
          subtitle: 'المحاضرات المسجلة للمقرر',
          onTap: () => _showComingSoon(context, 'سيتم إضافة الفيديوهات قريبا'),
        ),
        const SizedBox(height: 12),
        CourseMaterialTile(
          icon: Icons.file_present,
          title: 'المواد والملفات',
          subtitle: 'الملاحظات والملفات الدراسية',
          onTap: () => _showComingSoon(context, 'سيتم إضافة الملفات قريبا'),
        ),
        const SizedBox(height: 12),
        CourseMaterialTile(
          icon: Icons.assignment,
          title: 'الواجبات والمشاريع',
          subtitle: 'الواجبات والتكاليف الدراسية',
          onTap: () => _showComingSoon(context, 'سيتم إضافة الواجبات قريبا'),
        ),
        const SizedBox(height: 12),
        CourseMaterialTile(
          icon: Icons.quiz,
          title: 'الاختبارات',
          subtitle: 'الامتحانات والاختبارات القصيرة',
          onTap: () => _showComingSoon(context, 'سيتم إضافة الاختبارات قريبا'),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  void _showComingSoon(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
