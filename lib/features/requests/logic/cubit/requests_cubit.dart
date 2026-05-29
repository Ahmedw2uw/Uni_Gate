import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/features/requests/data/model/request_type_model.dart';
import 'package:nuigate/features/requests/data/model/student_request_model.dart';
import 'package:nuigate/features/requests/logic/requests_state.dart';
import 'package:nuigate/network/api_services.dart';

class RequestsCubit extends Cubit<RequestsState> {
  final ApiServices apiServices;

  List<RequestTypeModel> currentTypes = [];
  List<StudentRequestModel> currentRequests = [];
  bool _isFetching = false;

  RequestsCubit(this.apiServices) : super(RequestsInitial());

  Future<void> fetchRequestsPageData({bool force = false}) async {
    if (_isFetching) return;
    if (!force && currentTypes.isNotEmpty && currentRequests.isNotEmpty) {
      emit(
        RequestsLoaded(requestTypes: currentTypes, myRequests: currentRequests),
      );
      return;
    }

    _isFetching = true;
    emit(RequestsLoading());
    try {
      final responses = await Future.wait([
        apiServices.get('/StudentRequest/request-types'),
        apiServices.get('/StudentRequest/my-requests'),
      ]);

      final typesResponse = responses[0];
      final historyResponse = responses[1];

      if (typesResponse.statusCode == 200 && typesResponse.data is List) {
        currentTypes = (typesResponse.data as List)
            .whereType<Map<String, dynamic>>()
            .map(RequestTypeModel.fromJson)
            .toList(growable: false);
      }

      if (historyResponse.statusCode == 200 && historyResponse.data is List) {
        currentRequests = (historyResponse.data as List)
            .whereType<Map<String, dynamic>>()
            .map(StudentRequestModel.fromJson)
            .toList(growable: false);
      }

      _emitLoaded();
    } catch (e) {
      _handleError(e);
    } finally {
      _isFetching = false;
    }
  }

  Future<void> refreshMyRequests() async {
    try {
      final response = await apiServices.get('/StudentRequest/my-requests');
      if (response.statusCode == 200 && response.data is List) {
        currentRequests = (response.data as List)
            .whereType<Map<String, dynamic>>()
            .map(StudentRequestModel.fromJson)
            .toList(growable: false);
      }
      _emitLoaded();
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> submitNewRequest({
    required int requestType,
    required String details,
    String? filePath,
  }) async {
    if (state is SubmitRequestLoading) return;

    emit(SubmitRequestLoading());
    try {
      final formData = FormData.fromMap({
        'RequestType': requestType,
        'Details': details.trim(),
      });

      if (filePath != null && filePath.isNotEmpty) {
        final fileName = filePath.split(RegExp(r'[\\/]')).last;
        formData.files.add(
          MapEntry(
            'Attachment',
            await MultipartFile.fromFile(filePath, filename: fileName),
          ),
        );
      }

      final response = await apiServices.post(
        '/StudentRequest',
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(SubmitRequestSuccess('تم إرسال الطلب بنجاح'));
        await refreshMyRequests();
      } else {
        emit(RequestsFailure(_extractServerMessage(response.data)));
        _emitLoaded();
      }
    } catch (e) {
      _handleError(e);
    }
  }

  void _emitLoaded() {
    emit(
      RequestsLoaded(requestTypes: currentTypes, myRequests: currentRequests),
    );
  }

  void _handleError(dynamic error) {
    var errorMessage = 'حدث خطأ غير متوقع';
    if (error is DioException && error.response != null) {
      if (error.response?.statusCode == 401) {
        errorMessage = 'انتهت الجلسة، برجاء تسجيل الدخول مجددا.';
      } else {
        errorMessage = _extractServerMessage(error.response?.data);
      }
    } else if (error is String) {
      errorMessage = error;
    }

    emit(RequestsFailure(errorMessage));
    if (currentTypes.isNotEmpty || currentRequests.isNotEmpty) {
      _emitLoaded();
    }
  }

  String _extractServerMessage(dynamic data) {
    if (data is Map) {
      return data['detail']?.toString() ??
          data['message']?.toString() ??
          data['title']?.toString() ??
          'حدث خطأ في الخادم';
    }
    return 'حدث خطأ أثناء إرسال الطلب';
  }
}
