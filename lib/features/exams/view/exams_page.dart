import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/core/service_locator.dart';
import 'package:nuigate/features/exams/presentation/exams_cubit.dart';
import 'package:nuigate/features/exams/presentation/exams_state.dart';
import 'package:nuigate/features/exams/view/exam_attemp_pafe.dart'; // تأكد من صحة اسم الملف لديك لقراءة الصفحة
import 'package:nuigate/features/exams/widgets/exam_card.dart';
import 'package:nuigate/shared/widgets/app_scaffold.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class ExamsPage extends StatelessWidget {
  const ExamsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // تخزين نسخة الـ Cubit لضمان استخدام نفس الـ Instance في الـ Builder والـ Listener
    final examsCubit = ServiceLocator.examsCubit..fetchMyExams();

    return AppScaffold(
      title: 'الامتحانات الإلكترونية',
      // استخدام BlocProvider لتوفير الـ Cubit لكل الـ Widgets الشجرية بالأسفل
      child: BlocProvider.value(
        value: examsCubit,
        child: BlocListener<ExamsCubit, ExamsState>(
          listener: (context, state) {
            // 1. عند البدء في تحميل الأسئلة، نظهر مؤشر تحميل (Loading Dialog)
            if (state is ExamQuestionsLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            // 2. عند تحميل الأسئلة بنجاح، نغلق الـ Dialog وننتقل لصفحة الامتحان بالبيانات الجديدة
            if (state is ExamQuestionsSuccess) {
              Navigator.pop(context); // إغلاق الـ Loading Dialog
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExamAttemptPage(examData: state.examData),
                ),
              );
            }

            // 3. في حال فشل تحميل الأسئلة، نغلق الـ Dialog ونعرض رسالة الخطأ
            if (state is ExamQuestionsFailure) {
              Navigator.pop(context); // إغلاق الـ Loading Dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: BlocBuilder<ExamsCubit, ExamsState>(
            builder: (context, state) {
              // التعامل مع الحالات الأساسية لعرض قائمة الامتحانات
              if (state is ExamsLoading) {
                return const Center(child: CircularProgressIndicator());
              } 
              
              else if (state is ExamsSuccess || 
                       state is ExamQuestionsLoading || 
                       state is ExamQuestionsSuccess || 
                       state is ExamQuestionsFailure) {
                
                // جلب الامتحانات من الـ Cubit مباشرة لتفادي اختفائها أثناء تبدل الـ States الفرعية للأسئلة
                final examsList = examsCubit.state is ExamsSuccess 
                    ? (examsCubit.state as ExamsSuccess).exams 
                    : <dynamic>[]; // سيعود بالقائمة السابقة في حال تغير الـ State داخلياً

                if (examsList.isEmpty && state is ExamsSuccess) {
                  return const Center(child: CustomText('لا توجد امتحانات حالياً'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: examsList.length,
                  itemBuilder: (context, index) {
                    final exam = examsList[index];
                    return ExamCard(
                      exam: exam,
                      onStart: () {
                        print("بدء الامتحان: ${exam.title} (ID: ${exam.id})");
                        // طلب الأسئلة من السيرفر وبدء الامتحان
                        context.read<ExamsCubit>().startExam(exam.id);
                      },
                    );
                  },
                );
              } 
              
              else if (state is ExamsFailure) {
                return Center(child: CustomText(state.message, color: Colors.red));
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}