import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:nuigate/features/submission/data/models/assignment_submission.dart';
import 'package:nuigate/network/api_services.dart';

import 'assignment_state.dart';

class AssignmentCubit extends Cubit<AssignmentState> {
  final ApiServices apiServices;
  
  AssignmentCubit(this.apiServices) : super(AssignmentInitial());

  // 1. جلب تكليفات مادة معينة
  Future<void> fetchCourseAssignments(int courseId) async {
    emit(AssignmentLoading());
    try {
      final response = await apiServices.get('/Assignment/my-assignments?courseId=$courseId');
      final List data = response.data;
      final assignments = data.map((e) => AssignmentModel.fromJson(e)).toList();
      emit(AssignmentSuccess(assignments));
    } catch (e) {
      emit(AssignmentFailure("حدث خطأ أثناء جلب التكليفات"));
    }
  }

  // 2. إرسال ملف التكليف للسيرفر
  Future<void> submitAssignment({required int assignmentId, required String filePath}) async {
    emit(AssignmentUploadLoading());
    try {
      // تجهيز الملف كـ Multipart file لرفعه للسيرفر
      FormData formData = FormData.fromMap({
        "AssignmentId": assignmentId,
        "File": await MultipartFile.fromFile(filePath, filename: filePath.split('/').last),
      });

      final response = await apiServices.post('Assignment/submit', data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(AssignmentUploadSuccess("تم رفع التكليف بنجاح"));
      } else {
        emit(AssignmentUploadFailure("فشل رفع الملف للسيرفر"));
      }
    } catch (e) {
      emit(AssignmentUploadFailure("خطأ في الاتصال بالسيرفر أثناء الرفع"));
    }
  }
}