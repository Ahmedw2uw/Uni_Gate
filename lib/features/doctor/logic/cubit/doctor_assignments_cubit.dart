import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/features/doctor/data/models/doctor_assignment_model.dart';
import 'package:nuigate/features/doctor/domain/entities/doctor_assignment_entity.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_assignments_state.dart';
import 'package:nuigate/network/api_services.dart';

class DoctorAssignmentsCubit extends Cubit<DoctorAssignmentsState> {
  final ApiServices apiServices;

  DoctorAssignmentsCubit(this.apiServices) : super(const DoctorAssignmentsState());

  Future<void> loadCourseAssignments(int courseId) async {
    if (courseId <= 0) return;
    emit(state.copyWith(clearMessages: true));
    try {
      final response = await apiServices.get('/instructor/courses/$courseId');
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final assignmentsJson = data['assignments'];
        final assignments = assignmentsJson is List
            ? assignmentsJson
                  .whereType<Map<String, dynamic>>()
                  .map(DoctorAssignmentModel.fromJson)
                  .toList()
            : <DoctorAssignmentEntity>[];
        emit(state.copyWith(assignments: assignments, clearMessages: true));
        return;
      }
      emit(state.copyWith(errorMessage: 'فشل تحميل الواجبات'));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'خطأ: $e'));
    }
  }

  Future<void> uploadAssignment({
    required int courseId,
    required String title,
    required String filePath,
    required String fileName,
    required DateTime dueDate,
    required double maxGrade,
    String? description,
  }) async {
    if (state.isUploading) return;
    emit(state.copyWith(isUploading: true, clearMessages: true));
    try {
      final formData = FormData.fromMap({
        'Title': title,
        'DueDate': dueDate.toIso8601String(),
        'MaxGrade': maxGrade,
        'Description': description ?? '',
        'AttachmentFile': await MultipartFile.fromFile(filePath, filename: fileName),
      });

      final response = await apiServices.post(
        '/instructor/courses/$courseId/assignments',
        data: formData,
        headers: {'Content-Type': 'multipart/form-data'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(state.copyWith(isUploading: false, successMessage: 'تم رفع الواجب بنجاح'));
        await loadCourseAssignments(courseId);
        return;
      }
      emit(state.copyWith(isUploading: false, errorMessage: 'فشل الرفع'));
    } catch (e) {
      emit(state.copyWith(isUploading: false, errorMessage: 'خطأ: $e'));
    }
  }

  Future<void> deleteAssignment({required int courseId, required int assignmentId}) async {
    if (state.isDeleting) return;
    emit(state.copyWith(isDeleting: true, clearMessages: true));
    try {
      final response = await apiServices.delete(
        '/instructor/courses/$courseId/assignments/$assignmentId',
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        emit(state.copyWith(
          isDeleting: false,
          assignments: state.assignments.where((a) => a.assignmentId != assignmentId).toList(),
          successMessage: 'تم حذف الواجب',
        ));
        return;
      }
      emit(state.copyWith(isDeleting: false, errorMessage: 'فشل الحذف'));
    } catch (e) {
      emit(state.copyWith(isDeleting: false, errorMessage: 'خطأ: $e'));
    }
  }

  Future<String?> getAssignmentDownloadUrl({required int courseId, required int assignmentId}) async {
    try {
      final response = await apiServices.get(
        '/instructor/courses/$courseId/assignments/$assignmentId/download',
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
