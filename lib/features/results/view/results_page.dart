import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final studentName = 'أحمد محمد علي';
    final studentId = '20210567';
    final studentClass = 'الفرقة الرابعة - شعبة الحاسبات';
    final semester = 'الفصل الدراسي الأول 2025/2026';

    final results = [
      {
        'subject': 'البرمجة بلغة C++',
        'code': 'CS101',
        'midterm': 35,
        'final': 38,
        'total': 73,
      },
      {
        'subject': 'الرياضيات المتقدمة',
        'code': 'MATH201',
        'midterm': 40,
        'final': 42,
        'total': 82,
      },
      {
        'subject': 'قواعد البيانات',
        'code': 'CS202',
        'midterm': 32,
        'final': 35,
        'total': 67,
      },
      {
        'subject': 'الخوارزميات',
        'code': 'CS203',
        'midterm': 37,
        'final': 39,
        'total': 76,
      },
      {
        'subject': 'أنظمة التشغيل',
        'code': 'CS204',
        'midterm': 38,
        'final': 40,
        'total': 78,
      },
    ];

    double totalSum = 0;
    for (var result in results) {
      totalSum += (result['total'] as int);
    }
    double gpa = totalSum / results.length;

    return AppScaffold(
      title: 'النتائج',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _StudentInfoCard(
              name: studentName,
              studentId: studentId,
              className: studentClass,
            ),
            const SizedBox(height: 20),
            _SemesterCard(semester: semester, gpa: gpa),
            const SizedBox(height: 20),
            Text(
              'نتائج المواد',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: results.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final result = results[index];
                return _SubjectResultCard(
                  subject: result['subject'] as String,
                  code: result['code'] as String,
                  midterm: result['midterm'] as int,
                  final_: result['final'] as int,
                  total: result['total'] as int,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StudentInfoCard extends StatelessWidget {
  final String name;
  final String studentId;
  final String className;

  const _StudentInfoCard({
    Key? key,
    required this.name,
    required this.studentId,
    required this.className,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.primary, width: 4)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الرقم الجامعي',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      studentId,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'الفرقة والشعبة',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      className,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SemesterCard extends StatelessWidget {
  final String semester;
  final double gpa;

  const _SemesterCard({Key? key, required this.semester, required this.gpa})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              semester,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'المعدل التراكمي',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${gpa.toStringAsFixed(2)} / 100',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: LinearProgressIndicator(
                      value: gpa / 100,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SubjectResultCard extends StatelessWidget {
  final String subject;
  final String code;
  final int midterm;
  final int final_;
  final int total;

  const _SubjectResultCard({
    Key? key,
    required this.subject,
    required this.code,
    required this.midterm,
    required this.final_,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        code,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '$total',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ScoreColumn(label: 'الأول', score: midterm),
                Container(width: 1, height: 30, color: Colors.grey[300]),
                _ScoreColumn(label: 'النهائي', score: final_),
                Container(width: 1, height: 30, color: Colors.grey[300]),
                _ScoreColumn(label: 'المجموع', score: total),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreColumn extends StatelessWidget {
  final String label;
  final int score;

  const _ScoreColumn({Key? key, required this.label, required this.score})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          const SizedBox(height: 5),
          Text(
            '$score',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
