import 'package:nuigate/features/requests/data/model/request_type_model.dart';
import 'package:nuigate/features/requests/data/model/student_request_model.dart';

abstract class RequestsState {}

class RequestsInitial extends RequestsState {}

// حالة تحميل البيانات الأساسية (الأنواع والجدول)
class RequestsLoading extends RequestsState {}

// حالة نجاح جلب البيانات
class RequestsLoaded extends RequestsState {
  final List<RequestTypeModel> requestTypes;
  final List<StudentRequestModel> myRequests;

  RequestsLoaded({required this.requestTypes, required this.myRequests});
}

// حالات إرسال الطلب الجديد
class SubmitRequestLoading extends RequestsState {}

class SubmitRequestSuccess extends RequestsState {
  final String message;
  SubmitRequestSuccess(this.message);
}

class RequestsFailure extends RequestsState {
  final String errorMessage;
  RequestsFailure(this.errorMessage);
}
