import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/features/doctor/data/models/doctor_submission_model.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_submissions_state.dart';
import 'package:nuigate/network/api_services.dart';

class DoctorSubmissionsCubit extends Cubit<DoctorSubmissionsState> {
  final ApiServices apiServices;

  DoctorSubmissionsCubit(this.apiServices)
    : super(const DoctorSubmissionsState());

  Future<void> loadCourseSubmissions(int courseId) async {
    if (courseId <= 0) return;

    emit(state.copyWith(isLoading: true, clearMessages: true));
    try {
      final response = await apiServices.get('/instructor/courses/$courseId');
      final data = response.data;
      final submissionsJson = data is Map<String, dynamic>
          ? data['submissions']
          : null;
      final submissions = submissionsJson is List
          ? submissionsJson
                .whereType<Map<String, dynamic>>()
                .map(DoctorSubmissionModel.fromJson)
                .toList()
          : <DoctorSubmissionModel>[];

      emit(state.copyWith(submissions: submissions, isLoading: false));
    } catch (error) {
      _debug('loadCourseSubmissions error: $error');
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'تعذر تحميل تسليمات الطلاب',
        ),
      );
    }
  }

  Future<void> gradeSubmission({
    required int courseId,
    required int submissionId,
    required double grade,
    String feedback = '',
  }) async {
    if (submissionId <= 0 || state.isGrading) return;

    emit(state.copyWith(isGrading: true, clearMessages: true));
    try {
      final response = await apiServices.patch(
        '/instructor/courses/submissions/$submissionId/grade',
        data: {'grade': grade, 'feedback': feedback},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        await loadCourseSubmissions(courseId);
        emit(
          state.copyWith(
            isGrading: false,
            successMessage: 'تم حفظ الدرجة بنجاح',
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          isGrading: false,
          errorMessage: 'تعذر حفظ الدرجة (${response.statusCode})',
        ),
      );
    } catch (error) {
      _debug('gradeSubmission error: $error');
      emit(
        state.copyWith(
          isGrading: false,
          errorMessage: 'حدث خطأ أثناء حفظ الدرجة',
        ),
      );
    }
  }

  Future<String?> getSubmissionFileUrl(int submissionId) async {
    if (submissionId <= 0) return null;

    try {
      final response = await apiServices.get(
        '/instructor/courses/submissions/$submissionId',
      );
      final data = response.data;
      if (response.statusCode == 200 && data is Map<String, dynamic>) {
        return data['fileUrl']?.toString();
      }
    } catch (error) {
      _debug('getSubmissionFileUrl error: $error');
    }

    return null;
  }

  void _debug(String message) {
    if (kDebugMode) debugPrint('DOCTOR_SUBMISSIONS: $message');
  }
}
