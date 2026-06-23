import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/features/doctor/data/models/doctor_exam_model.dart';
import 'package:nuigate/features/doctor/domain/entities/doctor_exam_entity.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_exams_state.dart';
import 'package:nuigate/network/api_services.dart';

class DoctorExamsCubit extends Cubit<DoctorExamsState> {
  final ApiServices apiServices;

  DoctorExamsCubit(this.apiServices) : super(const DoctorExamsState());

  Future<void> loadCourseExams(int courseId) async {
    if (courseId <= 0) return;
    emit(state.copyWith(clearMessages: true));
    try {
      final response = await apiServices.get('/instructor/courses/$courseId');
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final examsJson = data['exams'];
        final exams = examsJson is List
            ? examsJson
                  .whereType<Map<String, dynamic>>()
                  .map(DoctorExamModel.fromJson)
                  .toList()
            : <DoctorExamEntity>[];
        emit(state.copyWith(exams: exams, clearMessages: true));
        return;
      }
      emit(state.copyWith(errorMessage: 'فشل تحميل الامتحانات'));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'خطأ: $e'));
    }
  }

  Future<void> uploadExam({
    required int courseId,
    required String title,
    required String filePath,
    required String fileName,
    required int examType,
    required int durationMinutes,
    required DateTime startTime,
  }) async {
    if (state.isUploading) return;
    emit(state.copyWith(isUploading: true, clearMessages: true));
    try {
      final formData = FormData.fromMap({
        'Title': title,
        'ExamType': examType,
        'DurationMinutes': durationMinutes,
        'StartTime': startTime.toIso8601String(),
        'ExamPaperFile': await MultipartFile.fromFile(filePath, filename: fileName),
      });

      final response = await apiServices.post(
        '/instructor/courses/$courseId/exams',
        data: formData,
        headers: {'Content-Type': 'multipart/form-data'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(state.copyWith(isUploading: false, successMessage: 'تم رفع الامتحان بنجاح'));
        await loadCourseExams(courseId);
        return;
      }
      emit(state.copyWith(isUploading: false, errorMessage: 'فشل الرفع'));
    } catch (e) {
      emit(state.copyWith(isUploading: false, errorMessage: 'خطأ: $e'));
    }
  }

  Future<void> deleteExam({required int courseId, required int examId}) async {
    if (state.isDeleting) return;
    emit(state.copyWith(isDeleting: true, clearMessages: true));
    try {
      final response = await apiServices.delete(
        '/instructor/courses/$courseId/exams/$examId',
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        emit(state.copyWith(
          isDeleting: false,
          exams: state.exams.where((e) => e.examId != examId).toList(),
          successMessage: 'تم حذف الامتحان',
        ));
        return;
      }
      emit(state.copyWith(isDeleting: false, errorMessage: 'فشل الحذف'));
    } catch (e) {
      emit(state.copyWith(isDeleting: false, errorMessage: 'خطأ: $e'));
    }
  }

  Future<String?> getExamDownloadUrl({required int courseId, required int examId}) async {
    try {
      final response = await apiServices.get(
        '/instructor/courses/$courseId/exams/$examId/download',
      );
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return response.data['fileUrl']?.toString();
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }
}
