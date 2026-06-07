import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/core/service_locator.dart';
import 'package:nuigate/features/exams/logic/cubit/exams_cubit.dart';
import 'package:nuigate/features/exams/logic/cubit/exams_state.dart';
import 'package:nuigate/features/exams/presentation/view/exam_attempt_page.dart';
import 'package:nuigate/features/exams/presentation/widgets/exams_empty_state.dart';
import 'package:nuigate/features/exams/presentation/widgets/exams_list.dart';
import 'package:nuigate/shared/widgets/app_scaffold.dart';

class ExamsPage extends StatefulWidget {
  const ExamsPage({super.key});

  @override
  State<ExamsPage> createState() => _ExamsPageState();
}

class _ExamsPageState extends State<ExamsPage> {
  late final ExamsCubit _examsCubit;
  bool _isQuestionsDialogVisible = false;

  @override
  void initState() {
    super.initState();
    _examsCubit = ServiceLocator.examsCubit;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _examsCubit.fetchMyExams();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'الامتحانات الإلكترونية',
      child: BlocProvider.value(
        value: _examsCubit,
        child: BlocListener<ExamsCubit, ExamsState>(
          listener: _onExamStateChanged,
          child: BlocBuilder<ExamsCubit, ExamsState>(
            builder: (context, state) {
              if (state is ExamsLoading && _examsCubit.cachedExams.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ExamsFailure) {
                return ExamsEmptyState(
                  message: state.message,
                  color: Colors.red,
                );
              }

              final exams = state is ExamsSuccess
                  ? state.exams
                  : _examsCubit.cachedExams;

              if (exams.isEmpty) {
                return const ExamsEmptyState(message: 'لا توجد امتحانات متاحة');
              }

              return ExamsList(
                exams: exams,
                onStartExam: (exam) =>
                    context.read<ExamsCubit>().startExam(exam.id),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onExamStateChanged(BuildContext context, ExamsState state) {
    if (state is ExamQuestionsLoading) {
      _showQuestionsLoadingDialog(context);
    } else if (state is ExamQuestionsSuccess) {
      _hideQuestionsLoadingDialog(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _examsCubit,
            child: ExamAttemptPage(examData: state.examData),
          ),
        ),
      );
    } else if (state is ExamQuestionsFailure) {
      _hideQuestionsLoadingDialog(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.message)));
    }
  }

  void _showQuestionsLoadingDialog(BuildContext context) {
    if (_isQuestionsDialogVisible) return;
    _isQuestionsDialogVisible = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _hideQuestionsLoadingDialog(BuildContext context) {
    if (!_isQuestionsDialogVisible) return;
    _isQuestionsDialogVisible = false;
    Navigator.of(context, rootNavigator: true).pop();
  }
}
