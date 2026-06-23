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

  Future<void> fetchCurrentStudentResults({int? year, int? semester}) async {
    emit(ResultsLoading());
    final requestedYear = year ?? semester ?? 1;

    try {
      final profileResponse = await apiServices.get('/Students/me/profile');
      if (profileResponse.statusCode != 200 ||
          profileResponse.data is! Map<String, dynamic>) {
        emit(ResultsFailure('تعذر تحميل بيانات الطالب قبل جلب النتائج.'));
        return;
      }

      final user = UserModel.fromJson(profileResponse.data);
      final studentId = user.studentId ?? int.tryParse(user.studentCode ?? '');
      debugPrint(
        'RESULTS: resolved studentId=$studentId, studentCode=${user.studentCode}, year=$requestedYear',
      );

      if (studentId == null || studentId <= 0) {
        emit(ResultsFailure('تعذر تحديد رقم الطالب لجلب النتائج.'));
        return;
      }

      await fetchStudentResults(studentId: studentId, year: requestedYear);
    } catch (error) {
      emit(ResultsFailure('خطأ في تحميل بيانات الطالب قبل جلب النتائج.'));
      debugPrint('RESULTS: error resolving current student: $error');
    }
  }

  Future<void> fetchStudentResults({
    required int studentId,
    int? year,
    int? semester,
  }) async {
    emit(ResultsLoading());
    final requestedYear = year ?? semester ?? 1;

    if (studentId <= 0) {
      emit(ResultsFailure('لا يمكن جلب النتائج قبل تحميل بيانات الطالب.'));
      return;
    }

    try {
      final response = await apiServices.get(
        '/Result/$studentId',
        queryParameters: {'year': requestedYear},
      );

      debugPrint('RESULTS: response status=${response.statusCode}');

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final resultResponse = StudentResultResponse.fromJson(response.data);
        emit(ResultsSuccess(resultResponse));
        return;
      }

      if (response.statusCode == 404) {
        emit(ResultsFailure('لا توجد نتائج مسجلة لهذا الطالب في هذه السنة.'));
        return;
      }

      if (response.statusCode == 500) {
        emit(ResultsFailure('تعذر تحميل النتائج من السيرفر حالياً.'));
        return;
      }

      debugPrint('RESULTS: unexpected response=${response.data}');
      emit(ResultsFailure('فشل جلب تفاصيل الدرجات والنتائج.'));
    } catch (error) {
      emit(ResultsFailure(_mapResultsError(error)));
      debugPrint('RESULTS: error fetching results: $error');
    }
  }

  String _mapResultsError(Object error) {
    if (error is DioException && error.response != null) {
      final statusCode = error.response?.statusCode;
      if (statusCode == 404) {
        return 'لا توجد نتائج مسجلة لهذا الطالب في هذه السنة.';
      }
      if (statusCode == 500) {
        return 'تعذر تحميل النتائج من السيرفر حالياً.';
      }

      final data = error.response?.data;
      if (data is Map) {
        return data['detail']?.toString() ??
            data['title']?.toString() ??
            'خطأ في الاتصال بالسيرفر أثناء جلب النتائج.';
      }
      if (data is String && data.isNotEmpty) return data;
    }

    if (error is String) return error;
    return 'خطأ في الاتصال بالسيرفر أثناء جلب النتائج.';
  }
}
