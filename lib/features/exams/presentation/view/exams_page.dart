import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/core/service_locator.dart';
import 'package:nuigate/features/exams/logic/cubit/exams_cubit.dart';
import 'package:nuigate/features/exams/logic/cubit/exams_state.dart';
import 'package:nuigate/features/exams/presentation/view/exam_attempt_page.dart';
import 'package:nuigate/features/exams/presentation/widgets/exam_card.dart';
import 'package:nuigate/shared/widgets/app_scaffold.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

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

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Online Exams',
      child: BlocProvider.value(
        value: _examsCubit,
        child: BlocListener<ExamsCubit, ExamsState>(
          listener: (context, state) {
            if (state is ExamQuestionsLoading) {
              _showQuestionsLoadingDialog(context);
            } else if (state is ExamQuestionsSuccess) {
              _hideQuestionsLoadingDialog(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExamAttemptPage(examData: state.examData),
                ),
              );
            } else if (state is ExamQuestionsFailure) {
              _hideQuestionsLoadingDialog(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: BlocBuilder<ExamsCubit, ExamsState>(
            builder: (context, state) {
              if (state is ExamsLoading && _examsCubit.cachedExams.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ExamsFailure) {
                return Center(
                  child: CustomText(state.message, color: Colors.red),
                );
              }

              final examsList = state is ExamsSuccess
                  ? state.exams
                  : _examsCubit.cachedExams;

              if (examsList.isEmpty) {
                return const Center(child: CustomText('No exams available'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: examsList.length,
                itemBuilder: (context, index) {
                  final exam = examsList[index];
                  return ExamCard(
                    exam: exam,
                    onStart: () =>
                        context.read<ExamsCubit>().startExam(exam.id),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
