import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/results/data/models/student_result_model.dart';
import 'package:nuigate/features/results/logic/results_cubit.dart';
import 'package:nuigate/features/results/logic/results_state.dart';
import 'package:nuigate/shared/widgets/app_scaffold.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

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

    if (_isInitialized) return;
    _isInitialized = true;

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final year = args?['year'] ?? args?['semester'] ?? 1;
    final studentId = args?['studentId'] ?? 0;

    if (studentId is int && studentId > 0) {
      context.read<ResultsCubit>().fetchStudentResults(
        studentId: studentId,
        year: year is int ? year : int.tryParse(year.toString()) ?? 1,
      );
      return;
    }

    context.read<ResultsCubit>().fetchCurrentStudentResults(
      year: year is int ? year : int.tryParse(year.toString()) ?? 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'النتائج والدرجات',
      child: BlocBuilder<ResultsCubit, ResultsState>(
        builder: (context, state) {
          if (state is ResultsLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (state is ResultsFailure) {
            return _ResultsMessage(message: state.errorMessage, isError: true);
          }

          if (state is ResultsSuccess) {
            final data = state.resultData;
            if (data.years.isEmpty || data.courseResults.isEmpty) {
              return const _ResultsMessage(
                message: 'لا توجد نتائج معلنة لهذا العام حتى الآن.',
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _StudentHeaderCard(data: data),
                  SizedBox(height: 20.h),
                  for (final yearResult in data.years)
                    _YearResultsSection(yearResult: yearResult),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _StudentHeaderCard extends StatelessWidget {
  final StudentResultResponse data;

  const _StudentHeaderCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15.r,
            offset: Offset(0, 8.h),
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8.h),
          CustomText(
            'كود الطالب: ${data.studentCode ?? "غير متوفر"}',
            fontSize: 14,
            color: Colors.black54,
          ),
          SizedBox(height: 4.h),
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

class _YearResultsSection extends StatelessWidget {
  final ResultYear yearResult;

  const _YearResultsSection({required this.yearResult});

  @override
  Widget build(BuildContext context) {
    if (yearResult.results.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: CustomText(
            'السنة الدراسية: ${yearResult.year ?? "غير محددة"}',
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        for (final result in yearResult.results) _ResultTile(result: result),
        SizedBox(height: 8.h),
      ],
    );
  }
}

class _ResultTile extends StatelessWidget {
  final CourseResult result;

  const _ResultTile({required this.result});

  @override
  Widget build(BuildContext context) {
    final grade = result.grade;
    final gradeColor = _gradeColor(grade);

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        childrenPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
        title: CustomText(
          result.courseName ?? 'اسم المادة غير متوفر',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: Wrap(
            spacing: 10.w,
            runSpacing: 8.h,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _InfoChip(label: result.courseCode ?? 'بدون كود'),
              _InfoChip(
                label: 'الدرجة: ${_formatGrade(grade)}',
                color: gradeColor,
              ),
            ],
          ),
        ),
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailLine(
                  label: 'كود المادة',
                  value: result.courseCode ?? '-',
                ),
                _DetailLine(label: 'السنة', value: '${result.year ?? '-'}'),
                _DetailLine(label: 'الدرجة', value: _formatGrade(grade)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _gradeColor(double? grade) {
    if (grade == null) return Colors.black54;
    if (grade < 50) return Colors.red;
    if (grade < 65) return Colors.orange;
    return Colors.green;
  }

  String _formatGrade(double? grade) {
    if (grade == null) return '-';
    if (grade == grade.roundToDouble()) return grade.toInt().toString();
    return grade.toStringAsFixed(1);
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color? color;

  const _InfoChip({required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: CustomText(
        label,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  final String label;
  final String value;

  const _DetailLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 6.h),
      child: CustomText('$label: $value', fontSize: 14, color: Colors.black87),
    );
  }
}

class _ResultsMessage extends StatelessWidget {
  final String message;
  final bool isError;

  const _ResultsMessage({required this.message, this.isError = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: CustomText(
          message,
          fontSize: 15,
          color: isError ? Colors.red : Colors.black54,
          textAlign: TextAlign.center,
          fontWeight: isError ? FontWeight.bold : FontWeight.w600,
        ),
      ),
    );
  }
}
