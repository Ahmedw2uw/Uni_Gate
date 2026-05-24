import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/custom_text.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  final List<ResultInfo> _results = const [
    ResultInfo(
      course: 'Machine Learning',
      code: 'ML5412',
      lecturer: 'د. أميرة غانم',
      grade: 'A',
      status: 'ناجح',
      details: '''المعدل: 95%
التقييم النهائي: ممتاز
الواجبات: 100%''',
    ),
    ResultInfo(
      course: 'Databases',
      code: 'DB4120',
      lecturer: 'د. أحمد السيد',
      grade: 'B+',
      status: 'ناجح',
      details: '''المعدل: 87%
التقييم النهائي: جيد جداً
الواجبات: 90%''',
    ),
    ResultInfo(
      course: 'Software Engineering',
      code: 'SE4303',
      lecturer: 'د. نجلاء حسن',
      grade: 'A-',
      status: 'ناجح',
      details: '''المعدل: 90%
التقييم النهائي: ممتاز
الواجبات: 92%''',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'النتائج والدرجات',
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  CustomText(
                    'اسم الطالب: محمد علي علاء',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 8),
                  CustomText(
                    'الفصل الدراسي: الأول',
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  SizedBox(height: 4),
                  CustomText(
                    'Student ID: 123450',
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ..._results.map((result) => _ResultTile(result: result)),
          ],
        ),
      ),
    );
  }
}

class ResultInfo {
  final String course;
  final String code;
  final String lecturer;
  final String grade;
  final String status;
  final String details;

  const ResultInfo({
    required this.course,
    required this.code,
    required this.lecturer,
    required this.grade,
    required this.status,
    required this.details,
  });
}

class _ResultTile extends StatelessWidget {
  final ResultInfo result;

  const _ResultTile({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.accent.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        childrenPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              result.course,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                CustomText(result.code, fontSize: 14, color: Colors.black54),
                const SizedBox(width: 12),
                CustomText(
                  'المحاضر: ${result.lecturer}',
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ],
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomText(
                'درجة: ${result.grade}',
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 10),
            CustomText(
              result.status,
              fontSize: 13,
              color: result.status == 'ناجح' ? Colors.green : Colors.red,
            ),
          ],
        ),
        children: [
          Text(
            result.details,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
