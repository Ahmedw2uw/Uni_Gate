import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/network/api_services.dart';
import '../data/models/student_result_model.dart';
import 'results_state.dart';

class ResultsCubit extends Cubit<ResultsState> {
  final ApiServices apiServices;

  ResultsCubit(this.apiServices) : super(ResultsInitial());

  Future<void> fetchStudentResults({
    required int studentId,
    int semester = 1,
  }) async {
    emit(ResultsLoading());
    try {
      // تم التعديل إلى GET بناءً على مواصفات سواجر
      final response = await apiServices.get(
        '/Result/$studentId',
        queryParameters: {
          'Semester': semester,
        }, //! change S-> to s if not working
      );

      if (response.statusCode == 200 && response.data != null) {
        final resultResponse = StudentResultResponse.fromJson(response.data);
        emit(ResultsSuccess(resultResponse));
      } else {
        emit(ResultsFailure("فشل جلب تفاصيل الدرجات والنتائج"));
      }
      debugPrint("Response Data: ${response.data}"); // Debug print
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
