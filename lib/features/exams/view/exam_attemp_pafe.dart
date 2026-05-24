import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/features/exams/data/exam_info.dart';
import 'package:nuigate/features/exams/presentation/exams_cubit.dart';
import '../../../core/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/custom_text.dart';
// تأكد من عمل import للموديلز الجديدة هنا

class ExamAttemptPage extends StatefulWidget {
  //  نستقبل الاستجابة الكاملة لبدء الامتحان القادمة من الـ Cubit
  final ExamStartResponse examData;

  const ExamAttemptPage({super.key, required this.examData});

  @override
  State<ExamAttemptPage> createState() => _ExamAttemptPageState();
}

class _ExamAttemptPageState extends State<ExamAttemptPage> {
  late final List<ExamQuestion> _questions; 
  int _currentIndex = 0;
  
  //  التعديل: ربط الـ Question ID بالـ Option ID المختار مباشرة للتسليم للسيرفر
  final Map<int, int> _selectedAnswers = {}; 
  
  late Duration _remaining;
  Timer? _timer;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    //  ملء الأسئلة مباشرة من البيانات القادمة من السيرفر
    _questions = widget.examData.questions;
    
    //  ضبط الوقت بالثواني الدقيقة المتبقية من محاولة الطالب الحالية
    _remaining = Duration(seconds: widget.examData.remainingSeconds);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining.inSeconds <= 0) {
        timer.cancel();
        _submitExam(autoSubmit: true); // تسليم تلقائي عند انتهاء الوقت
      } else {
        setState(() {
          _remaining -= const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // دالة تسليم الامتحان للسيرفر
  void _submitExam({bool autoSubmit = false}) async {
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
        content: const CustomText('هل أنت متأكد من رغبتك في إنهاء الامتحان وتسليم الإجابات؟'),
        actions: [
          TextButton(
            onPressed: () {
              print("تم إلغاء التسليم، الطالب عاد للامتحان");
               Navigator.pop(context);},
            child: const CustomText('إلغاء', color: Colors.grey),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              print("تم تأكيد التسليم، يتم الآن إرسال الإجابات للسيرفر");
              Navigator.pop(context); // إغلاق الديالوج
              _executeSubmit();
            },
            child: const CustomText('تسليم الآن', color: Colors.white),
          ),
        ],
      ),
    );
  }

  // تجهيز الـ Payload الفعلي لإرساله للـ API للـ Submit
void _executeSubmit() {
  _timer?.cancel();
  
  final Map<String, dynamic> submitPayload = {
    "examResultId": widget.examData.examResultId,
    "answers": _selectedAnswers.map((qId, optId) => MapEntry(qId.toString(), optId))
  };

  //  تفعيل الاستدعاء بشكل رسمي الآن
  context.read<ExamsCubit>().submitExamAnswers(submitPayload);
  print("تم تجهيز بيانات التسليم وإرسالها للـ Cubit: $submitPayload");
}

  @override
  Widget build(BuildContext context) {
    // التحديث لـ PopScope بدلاً من WillPopScope المهملة في الإصدارات الحديثة
    return PopScope(
      canPop: false, // منع السحب أو العودة بالخلف تماماً لضمان عدم ضياع الإجابات
      child: AppScaffold(
        title: widget.examData.examTitle,
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: _questions.isEmpty
                  ? const Center(child: CustomText('لا توجد أسئلة في هذا الامتحان'))
                  : PageView.builder(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(), 
                      itemCount: _questions.length,
                      onPageChanged: (index) => setState(() => _currentIndex = index),
                      itemBuilder: (context, index) => _buildQuestionCard(_questions[index]),
                    ),
            ),
            if (_questions.isNotEmpty) _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText('السؤال ${_currentIndex + 1}/${_questions.length}', fontWeight: FontWeight.bold),
              _buildTimerBadge(),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: _questions.isEmpty ? 0 : (_currentIndex + 1) / _questions.length,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerBadge() {
    bool lowTime = _remaining.inMinutes < 2;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: lowTime ? Colors.red.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.timer, size: 16, color: lowTime ? Colors.red : AppColors.primary),
          const SizedBox(width: 4),
          CustomText(
            _formatDuration(_remaining),
            color: lowTime ? Colors.red : AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(ExamQuestion question) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(question.text, fontSize: 18, fontWeight: FontWeight.bold),
            const SizedBox(height: 20),
            ...List.generate(question.options.length, (index) {
              final option = question.options[index];
              //  تعديل: التحقق من الاختيار يتم عبر الـ option.id
              bool isSelected = _selectedAnswers[question.id] == option.id;

              return GestureDetector(
                //  تعديل: عند الضغط نقوم بتخزين الـ option.id الفعلي
                onTap: () => setState(() => _selectedAnswers[question.id] = option.id),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.transparent,
                    border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color: isSelected ? AppColors.primary : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      //  تعديل: عرض النص الفعلي للاختيار من الحقل الجديد optionText
                      Expanded(child: CustomText(option.optionText)),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          if (_currentIndex > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () => _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                child: const CustomText('السابق'),
              ),
            ),
          if (_currentIndex > 0) const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () {
                if (_currentIndex < _questions.length - 1) {
                  _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                } else {
                  _submitExam();
                }
              },
              child: CustomText(
                _currentIndex < _questions.length - 1 ? 'التالي' : 'إنهاء وتسليم',
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}";
  }
}