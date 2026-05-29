// // lib/features/admission/data/models/admission_response_model.dart
// import '../../domain/entities/admission_entity.dart';

// class AdmissionResponseModel {
//   final String? status;
//   final String? message;
//   final dynamic data;
//   final bool? isSuccess;

//   const AdmissionResponseModel({
//     this.status,
//     this.message,
//     this.data,
//     this.isSuccess,
//   });

//   factory AdmissionResponseModel.fromJson(Map<String, dynamic> json) {
//     return AdmissionResponseModel(
//       status: json['status']?.toString(),
//       message: json['message']?.toString(),
//       data: json['data'],
//       isSuccess: json['isSuccess'] as bool? ?? false, // القيمة الافتراضية false
//     );
//   }

//   AdmissionEntity toEntity() => AdmissionEntity(
//     status: status ?? 'Pending',
//     message: message,
//     data: data,
//     isSuccess: isSuccess ?? false,
//   );
// }
