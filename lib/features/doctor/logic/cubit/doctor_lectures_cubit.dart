import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/features/doctor/data/models/doctor_lecture_model.dart';
import 'package:nuigate/features/doctor/domain/entities/doctor_lecture_entity.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_lectures_state.dart';
import 'package:nuigate/network/api_services.dart';

class DoctorLecturesCubit extends Cubit<DoctorLecturesState> {
  final ApiServices apiServices;

  DoctorLecturesCubit(this.apiServices) : super(const DoctorLecturesState());

  void setLectures(List<DoctorLectureEntity> lectures) {
    emit(state.copyWith(lectures: lectures, clearMessages: true));
  }

  Future<void> loadCourseLectures(int courseId) async {
    if (courseId <= 0) return;

    emit(state.copyWith(clearMessages: true));
    try {
      final response = await apiServices.get('/instructor/courses/$courseId');
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final lecturesJson = data['lectures'];
        final lectures = lecturesJson is List
            ? lecturesJson
                  .whereType<Map<String, dynamic>>()
                  .map(DoctorLectureModel.fromJson)
                  .toList()
            : <DoctorLectureEntity>[];
        emit(state.copyWith(lectures: lectures, clearMessages: true));
        return;
      }

      emit(
        state.copyWith(
          errorMessage: 'تعذر تحميل محاضرات الكورس (${response.statusCode})',
        ),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: 'حدث خطأ أثناء تحميل المحاضرات: $e'));
    }
  }

  Future<void> uploadLecture({
    required int courseId,
    required String lectureName,
    required String filePath,
    required String fileName,
    int contentType = 0,
    int semester = 1,
    int orderIndex = 0,
  }) async {
    if (state.isUploading) return;

    emit(state.copyWith(isUploading: true, clearMessages: true));
    try {
      final now = DateTime.now().toUtc();
      final formData = FormData.fromMap({
        'LectureName': lectureName,
        'ContentType': contentType,
        'File': await MultipartFile.fromFile(filePath, filename: fileName),
        'AvailableFrom': now.toIso8601String(),
        'AvailableTo': now.add(const Duration(days: 120)).toIso8601String(),
        'Semester': semester,
        'OrderIndex': orderIndex,
      });

      final response = await apiServices.post(
        '/instructor/courses/$courseId/lectures',
        data: formData,
        headers: {'Content-Type': 'multipart/form-data'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(
          state.copyWith(
            isUploading: false,
            successMessage: 'تم رفع المحاضرة بنجاح',
          ),
        );
        await loadCourseLectures(courseId);
        return;
      }

      emit(
        state.copyWith(
          isUploading: false,
          errorMessage: 'فشل رفع المحاضرة (${response.statusCode})',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isUploading: false,
          errorMessage: 'حدث خطأ أثناء رفع المحاضرة: $e',
        ),
      );
    }
  }

  Future<void> deleteLecture({
    required int courseId,
    required int lectureId,
  }) async {
    if (lectureId <= 0 || state.isDeleting) return;

    emit(state.copyWith(isDeleting: true, clearMessages: true));
    try {
      final response = await apiServices.delete(
        '/instructor/courses/$courseId/lectures/$lectureId',
      );

      if (response.statusCode == 200) {
        emit(
          state.copyWith(
            isDeleting: false,
            lectures: state.lectures
                .where((lecture) => lecture.lectureId != lectureId)
                .toList(),
            successMessage: 'تم حذف المحاضرة',
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          isDeleting: false,
          errorMessage: 'فشل حذف المحاضرة (${response.statusCode})',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isDeleting: false,
          errorMessage: 'حدث خطأ أثناء حذف المحاضرة: $e',
        ),
      );
    }
  }

  Future<String?> getLectureDownloadUrl({
    required int courseId,
    required DoctorLectureEntity lecture,
  }) async {
    if (lecture.fileUrl.isNotEmpty) return lecture.fileUrl;
    if (lecture.lectureId <= 0) return null;

    final response = await apiServices.get(
      '/instructor/courses/$courseId/lectures/${lecture.lectureId}/download',
    );

    if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
      return response.data['fileUrl']?.toString();
    }

    return null;
  }
}
