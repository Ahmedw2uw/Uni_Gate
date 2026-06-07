import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/exams/data/exam_info.dart';
import 'package:nuigate/features/exams/logic/cubit/exams_cubit.dart';
import 'package:nuigate/features/exams/logic/cubit/exams_state.dart';
import 'package:nuigate/features/exams/presentation/widgets/exam_attempt_top_bar.dart';
import 'package:nuigate/features/exams/presentation/widgets/exam_navigation_bar.dart';
import 'package:nuigate/features/exams/presentation/widgets/exam_question_card.dart';
import 'package:nuigate/shared/widgets/app_scaffold.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class ExamAttemptPage extends StatefulWidget {
  final ExamStartResponse examData;

  const ExamAttemptPage({super.key, required this.examData});

  @override
  State<ExamAttemptPage> createState() => _ExamAttemptPageState();
}

class _ExamAttemptPageState extends State<ExamAttemptPage> {
  late final List<ExamQuestion> _questions;
  final Map<int, int> _selectedAnswers = {};
  final PageController _pageController = PageController();
  Timer? _timer;
  late Duration _remaining;
  int _currentIndex = 0;
  bool _canLeaveExam = false;

  @override
  void initState() {
    super.initState();
    _questions = widget.examData.questions;
    _remaining = Duration(seconds: widget.examData.remainingSeconds);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExamsCubit, ExamsState>(
      listener: _onExamSubmitStateChanged,
      child: PopScope(
        canPop: _canLeaveExam,
        child: AppScaffold(
          title: widget.examData.examTitle,
          child: Column(
            children: [
              ExamAttemptTopBar(
                currentIndex: _currentIndex,
                totalQuestions: _questions.length,
                remaining: _remaining,
              ),
              Expanded(child: _buildQuestionsPager()),
              if (_questions.isNotEmpty)
                ExamNavigationBar(
                  currentIndex: _currentIndex,
                  totalQuestions: _questions.length,
                  onPrevious: _goToPreviousQuestion,
                  onNextOrSubmit: _goToNextQuestionOrSubmit,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _onExamSubmitStateChanged(BuildContext context, ExamsState state) {
    if (state is ExamSubmitSuccess) {
      _timer?.cancel();
      setState(() => _canLeaveExam = true);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.message)));
      Navigator.of(context).pop();
      return;
    }

    if (state is ExamSubmitFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildQuestionsPager() {
    if (_questions.isEmpty) {
      return const Center(child: CustomText('لا توجد أسئلة في هذا الامتحان'));
    }

    return PageView.builder(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _questions.length,
      onPageChanged: (index) => setState(() => _currentIndex = index),
      itemBuilder: (context, index) {
        final question = _questions[index];
        return ExamQuestionCard(
          question: question,
          selectedOptionId: _selectedAnswers[question.id],
          onOptionSelected: (optionId) {
            setState(() => _selectedAnswers[question.id] = optionId);
          },
        );
      },
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining.inSeconds <= 0) {
        timer.cancel();
        _submitExam(autoSubmit: true);
        return;
      }

      setState(() => _remaining -= const Duration(seconds: 1));
    });
  }

  void _goToPreviousQuestion() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToNextQuestionOrSubmit() {
    if (_currentIndex < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }

    _submitExam();
  }

  void _submitExam({bool autoSubmit = false}) {
    if (autoSubmit) {
      _executeSubmit();
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const CustomText('تأكيد التسليم', fontWeight: FontWeight.bold),
        content: const CustomText(
          'هل أنت متأكد من رغبتك في إنهاء الامتحان وتسليم الإجابات؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const CustomText('إلغاء', color: Colors.grey),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              Navigator.pop(context);
              _executeSubmit();
            },
            child: const CustomText('تسليم الآن', color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _executeSubmit() {
    final submitPayload = <String, dynamic>{
      'examResultId': widget.examData.examResultId,
      'answers': _selectedAnswers.entries
          .map(
            (entry) => {
              'questionId': entry.key,
              'selectedOptionId': entry.value,
            },
          )
          .toList(),
    };

    context.read<ExamsCubit>().submitExamAnswers(submitPayload);
  }
}
