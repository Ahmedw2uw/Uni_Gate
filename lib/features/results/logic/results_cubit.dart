import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/features/auth/data/models/user_model.dart';
import 'package:nuigate/network/api_services.dart';
import '../data/models/student_result_model.dart';
import 'results_state.dart';

class ResultsCubit extends Cubit<ResultsState> {
  final ApiServices apiServices;

  ResultsCubit(this.apiServices) : super(ResultsInitial());

  Future<void> fetchCurrentStudentResults({int semester = 1}) async {
    emit(ResultsLoading());
    try {
      final profileResponse = await apiServices.get('/Students/me/profile');
      if (profileResponse.statusCode != 200 ||
          profileResponse.data is! Map<String, dynamic>) {
        emit(ResultsFailure("تعذر تحميل بيانات الطالب قبل جلب النتائج."));
        return;
      }

      final user = UserModel.fromJson(profileResponse.data);
      final studentId = int.tryParse(user.studentCode ?? '') ?? user.studentId;
      debugPrint(
        'Resolved results studentId=$studentId, studentCode=${user.studentCode}, userId=${user.id}',
      );

      if (studentId == null || studentId <= 0) {
        emit(ResultsFailure("تعذر تحديد رقم الطالب لجلب النتائج."));
        return;
      }

      await fetchStudentResults(studentId: studentId, semester: semester);
    } catch (error) {
      emit(ResultsFailure("خطأ في تحميل بيانات الطالب قبل جلب النتائج."));
      debugPrint("Error resolving current student for results: $error");
    }
  }

  Future<void> fetchStudentResults({
    required int studentId,
    int semester = 1,
  }) async {
    emit(ResultsLoading());
    if (studentId <= 0) {
      emit(ResultsFailure("لا يمكن جلب النتائج قبل تحميل بيانات الطالب."));
      return;
    }

    try {
      // تم التعديل إلى GET بناءً على مواصفات سواجر
      final response = await apiServices.get(
        '/Result/$studentId',
        queryParameters: {
          'semester': semester,
        }, //! change S-> to s if not working
      );

      if (response.statusCode == 200 && response.data != null) {
        final resultResponse = StudentResultResponse.fromJson(response.data);
        emit(ResultsSuccess(resultResponse));
      } else if (response.statusCode == 404) {
        emit(ResultsFailure("لا توجد نتائج مسجلة لهذا الطالب في هذا الترم."));
      } else if (response.statusCode == 500) {
        emit(ResultsFailure("تعذر تحميل النتائج من السيرفر حاليا."));
      } else {
        debugPrint(
          "Unexpected results response: ${response.statusCode} - ${response.data}",
        );
        emit(ResultsFailure("فشل جلب تفاصيل الدرجات والنتائج"));
      }
      debugPrint("Results response status: ${response.statusCode}");
    } catch (error) {
      String errorMessage = "خطأ في الاتصال بالسيرفر أثناء جلب النتائج";
      if (error is DioException && error.response != null) {
        // ✅ 1. لو الخطأ 404 أو 500، ثبت الرسالة العربي واخرج
        if (error.response?.statusCode == 404 ||
            error.response?.statusCode == 500) {
          errorMessage = "لا توجد نتائج أو درجات مسجلة لهذا الترم حتى الآن.";
        }
        // 🌟 2. الـ else دي هي اللي هتحمي رسالتك من المسح
        else if (error.response?.data != null) {
          final data = error.response!.data;
          if (data is Map) {
            errorMessage = data['detail'] ?? data['title'] ?? errorMessage;
          }
        }
      } else if (error is String) {
        errorMessage = error;
      }
      emit(ResultsFailure(errorMessage));
      debugPrint("Error fetching results: $error"); // Debug print
    }
  }
}
