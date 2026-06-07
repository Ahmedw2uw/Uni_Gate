// States
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/features/exams/data/exam_info.dart';
import 'package:nuigate/features/exams/logic/cubit/exams_state.dart';
import 'package:nuigate/network/api_services.dart';

// Cubit
class ExamsCubit extends Cubit<ExamsState> {
  final ApiServices apiServices;
  List<ExamInfo> _cachedExams = [];

  List<ExamInfo> get cachedExams => List.unmodifiable(_cachedExams);

  ExamsCubit(this.apiServices) : super(ExamsInitial());

  Future<void> fetchMyExams() async {
    emit(ExamsLoading());
    try {
      final response = await apiServices.get('/Exam/my-exams');
      // تأكد من مسار البيانات في الـ response حسب الـ Dio Wrapper اللي عندك
      final List data = response.data;
      _cachedExams = data.map((e) => ExamInfo.fromJson(e)).toList();
      emit(ExamsSuccess(_cachedExams));
    } catch (e) {
      emit(ExamsFailure("حدث خطأ في جلب الامتحانات"));
    }
  }

  Future<void> startExam(int examId) async {
    emit(ExamQuestionsLoading()); // 💡 يُفضل عمل State مخصصة لتحميل الأسئلة
    try {
      final response = await apiServices.post('/Exam/$examId/start');

      // السيرفر هنا بيرجع Map مباشرة {...} مش List
      if (response.statusCode != 200 || response.data is! Map) {
        emit(ExamQuestionsFailure("فشل في تحميل أسئلة الامتحان"));
        return;
      }

      final data = Map<String, dynamic>.from(response.data as Map);

      // بنعمل parse باستخدام الموديل الجديد اللي جواه الـ questions والـ options
      final examStartData = ExamStartResponse.fromJson(data);

      // بتبعت الـ state الجديدة ومعاها بيانات الامتحان والأسئلة كاملة
      emit(ExamQuestionsSuccess(examStartData));
    } catch (e) {
      emit(ExamQuestionsFailure("فشل في تحميل أسئلة الامتحان"));
    }
  }

  Future<void> submitExamAnswers(Map<String, dynamic> submitPayload) async {
    emit(ExamSubmitLoading()); // تغيير الحالة إلى جاري التسليم
    try {
      // إرسال البيانات للسيرفر عبر الـ POST request
      final response = await apiServices.post(
        '/Exam/submit',
        data: submitPayload,
      );

      // التحقق من نجاح العملية حسب شكل استجابة السيرفر لديك
      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(ExamSubmitSuccess("تم تسليم الامتحان بنجاح!"));
      } else {
        emit(ExamSubmitFailure("فشل تسليم الامتحان، يرجى المحاولة مرة أخرى"));
      }
    } catch (e) {
      emit(ExamSubmitFailure("حدث خطأ أثناء الاتصال بالسيرفر لتسليم الإجابات"));
    }
  }
}
