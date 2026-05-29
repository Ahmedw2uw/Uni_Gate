import 'dart:convert';

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
      final response = await apiServices.get(
        '/Assignment/my-assignments?courseId=$courseId',
      );
      final List data = response.data;
      final assignments = data.map((e) => AssignmentModel.fromJson(e)).toList();
      emit(AssignmentSuccess(assignments));
    } catch (e) {
      emit(AssignmentFailure("حدث خطأ أثناء جلب التكليفات"));
    }
  }

  // 2. إرسال ملف التكليف للسيرفر
  Future<void> submitAssignment({
    required int assignmentId,
    required String filePath,
  }) async {
    emit(AssignmentUploadLoading());
    try {
      if (filePath.isEmpty) {
        emit(AssignmentUploadFailure("مسار الملف غير صحيح"));
        return;
      }

      // تجهيز البيانات بحروف صغيرة كما يفضلها السيرفر
      FormData formData = FormData.fromMap({
        "assignmentId": assignmentId,
        "file": await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
      });

      final response = await apiServices.post(
        '/Assignment/submit',
        data: formData,
      );

      // السيرفر يعيد statusCode == 200 أو 201
      if (response.statusCode == 200 || response.statusCode == 201) {
        String successMessage = "تم رفع التكليف بنجاح";

        if (response.data != null) {
          // الحماية: التحقق لو كان الرد Map جاهز أو String يحتاج إلى parsing
          if (response.data is Map) {
            successMessage = response.data['message'] ?? successMessage;
          } else if (response.data is String) {
            try {
              final Map<String, dynamic> decodedData = jsonDecode(
                response.data,
              );
              successMessage = decodedData['message'] ?? successMessage;
            } catch (_) {
              // إذا فشل عمل الـ decode نترك الرسالة الافتراضية كما هي
            }
          }
        }

        emit(AssignmentUploadSuccess(successMessage));
      } else {
        emit(AssignmentUploadFailure("فشل رفع الملف للسيرفر"));
      }
    } on DioException catch (dioError) {
      // اصطياد تفاصيل الخطأ بدقة في حال حدوث مشاكل شبكة مستقبلاً
      String errorMessage = "خطأ في الاتصال بالسيرفر أثناء الرفع";

      if (dioError.response?.data != null) {
        if (dioError.response!.data is Map) {
          errorMessage =
              dioError.response!.data['detail'] ??
              dioError.response!.data['title'] ??
              errorMessage;
        } else if (dioError.response!.data is String) {
          try {
            final decodedError = jsonDecode(dioError.response!.data);
            errorMessage =
                decodedError['detail'] ?? decodedError['title'] ?? errorMessage;
          } catch (_) {}
        }
      }

      emit(AssignmentUploadFailure(errorMessage));
    } catch (e) {
      emit(AssignmentUploadFailure("حدث خطأ غير متوقع أثناء معالجة الملف"));
    }
  }
}
