// import 'package:flutter/material.dart';
// import 'package:nuigate/core/app_colors.dart';
// import 'package:nuigate/shared/widgets/app_scaffold.dart';
// import 'package:nuigate/shared/widgets/custom_text.dart';

// class ResultsPage extends StatelessWidget {
//   const ResultsPage({super.key});

//   final List<ResultInfo> _results = const [
//     ResultInfo(
//       course: 'Machine Learning',
//       code: 'ML5412',
//       lecturer: 'د. أميرة غانم',
//       grade: 'A',
//       status: 'ناجح',
//       details: '''المعدل: 95%
// التقييم النهائي: ممتاز
// الواجبات: 100%''',
//     ),
//     ResultInfo(
//       course: 'Databases',
//       code: 'DB4120',
//       lecturer: 'د. أحمد السيد',
//       grade: 'B+',
//       status: 'ناجح',
//       details: '''المعدل: 87%
// التقييم النهائي: جيد جداً
// الواجبات: 90%''',
//     ),
//     ResultInfo(
//       course: 'Software Engineering',
//       code: 'SE4303',
//       lecturer: 'د. نجلاء حسن',
//       grade: 'A-',
//       status: 'ناجح',
//       details: '''المعدل: 90%
// التقييم النهائي: ممتاز
// الواجبات: 92%''',
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return AppScaffold(
//       title: 'النتائج والدرجات',
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(18),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withValues(alpha: 0.05),
//                     blurRadius: 15,
//                     offset: const Offset(0, 8),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: const [
//                   CustomText(
//                     'اسم الطالب: محمد علي علاء',
//                     fontSize: 16,
//                     fontWeight: FontWeight.w700,
//                   ),
//                   SizedBox(height: 8),
//                   CustomText(
//                     'الفصل الدراسي: الأول',
//                     fontSize: 14,
//                     color: Colors.black54,
//                   ),
//                   SizedBox(height: 4),
//                   CustomText(
//                     'Student ID: 123450',
//                     fontSize: 14,
//                     color: Colors.black54,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             ..._results.map((result) => _ResultTile(result: result)),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ResultInfo {
//   final String course;
//   final String code;
//   final String lecturer;
//   final String grade;
//   final String status;
//   final String details;

//   const ResultInfo({
//     required this.course,
//     required this.code,
//     required this.lecturer,
//     required this.grade,
//     required this.status,
//     required this.details,
//   });
// }

// class _ResultTile extends StatelessWidget {
//   final ResultInfo result;

//   const _ResultTile({required this.result});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.03),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: ExpansionTile(
//         tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         childrenPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 10,
//         ),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CustomText(
//               result.course,
//               fontSize: 17,
//               fontWeight: FontWeight.w700,
//             ),
//             const SizedBox(height: 6),
//             Row(
//               children: [
//                 CustomText(result.code, fontSize: 14, color: Colors.black54),
//                 const SizedBox(width: 12),
//                 CustomText(
//                   'المحاضر: ${result.lecturer}',
//                   fontSize: 14,
//                   color: Colors.black54,
//                 ),
//               ],
//             ),
//           ],
//         ),
//         subtitle: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//               decoration: BoxDecoration(
//                 color: AppColors.background,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: CustomText(
//                 'درجة: ${result.grade}',
//                 fontSize: 13,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//             const SizedBox(width: 10),
//             CustomText(
//               result.status,
//               fontSize: 13,
//               color: result.status == 'ناجح' ? Colors.green : Colors.red,
//             ),
//           ],
//         ),
//         children: [
//           Text(
//             result.details,
//             style: const TextStyle(
//               fontSize: 14,
//               color: Colors.black87,
//               height: 1.6,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/features/results/logic/results_cubit.dart';
import 'package:nuigate/features/results/logic/results_state.dart';
import '../../../../core/app_colors.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../../data/models/student_result_model.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      // استقبال الـ Arguments الممررة عند الانتقال للصفحة
      // نتوقع استقبال Map تحتوي على الـ studentId والـ semester ليكون الكود مرناً جداً
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null) {
        final int studentId = args['studentId'] ?? 0;
        final int semester = args['semester'] ?? 1;

        // استدعاء الـ API فوراً بشكل ديناميكي بالبيانات الممررة
        context.read<ResultsCubit>().fetchStudentResults(
          studentId: studentId,
          semester: semester,
        );
      }
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'النتائج والدرجات',
      child: BlocBuilder<ResultsCubit, ResultsState>(
        builder: (context, state) {
          if (state is ResultsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ResultsFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomText(
                  state.errorMessage,
                  fontSize: 15,
                  color: Colors.red,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else if (state is ResultsSuccess) {
            final data = state.resultData;
            if (data.courseResults.isEmpty) {
              return const Center(
                child: CustomText(
                  'لا توجد نتائج معلنة لهذا الفصل الدراسي حتى الآن.',
                  fontSize: 15,
                ),
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildStudentHeaderCard(data),
                  const SizedBox(height: 20),
                  ...data.courseResults.map(
                    (course) => _ResultTile(course: course),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildStudentHeaderCard(StudentResultResponse data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            'اسم الطالب: ${data.studentName ?? "غير متوفر"}',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 8),
          CustomText(
            'الفصل الدراسي: ${data.semester == 1 ? "الأول" : "الثاني"}',
            fontSize: 14,
            color: Colors.black54,
          ),
          const SizedBox(height: 4),
          CustomText(
            'Student ID: ${data.studentId ?? "غير متوفر"}',
            fontSize: 14,
            color: Colors.black54,
          ),
        ],
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  final CourseResult course;
  const _ResultTile({required this.course});

  @override
  Widget build(BuildContext context) {
    Color gradeColor = Colors.green;
    if (course.gradeLevel == 'F') {
      gradeColor = Colors.red;
    } else if (course.gradeLevel?.startsWith('D') ?? false) {
      gradeColor = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        childrenPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              course.courseName ?? 'اسم المادة غير متوفر',
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                CustomText(
                  course.courseCode ?? '',
                  fontSize: 13,
                  color: Colors.black54,
                ),
                if (course.courseCode != null) const SizedBox(width: 12),
                Expanded(
                  child: CustomText(
                    'المحاضر: ${course.instructorName ?? 'غير محدد'}',
                    fontSize: 13,
                    color: Colors.black54,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomText(
                  'الرمز: ${course.gradeLevel ?? '-'}',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: gradeColor,
                ),
              ),
              const SizedBox(width: 12),
              CustomText(
                course.gradeLevel == 'F' ? 'راسب' : 'ناجح',
                fontSize: 13,
                color: course.gradeLevel == 'F' ? Colors.red : Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  'الدرجة النهائية: ${course.finalGrade ?? 0}',
                  fontSize: 14,
                  color: Colors.black87,
                ),
                const SizedBox(height: 6),
                CustomText(
                  'الساعات المعتمدة: ${course.creditHours ?? 0} ساعات',
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
