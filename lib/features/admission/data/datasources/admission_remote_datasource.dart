// // lib/features/admission/data/datasources/admission_remote_datasource.dart
// import 'package:nuigate/network/api_services.dart';
// import '../models/admission_response_model.dart';

// abstract class AdmissionRemoteDataSource {
//   Future<AdmissionResponseModel> getAdmissionStatus(String nationalId);
// }

// class AdmissionRemoteDataSourceImpl implements AdmissionRemoteDataSource {
//   final ApiServices apiServices;

//   AdmissionRemoteDataSourceImpl(this.apiServices);

//   @override
//   Future<AdmissionResponseModel> getAdmissionStatus(String nationalId) async {
//     // التأكد من أن الـ Endpoint صحيح حسب الـ API لديك
//     final response = await apiServices.get('/api/Admission/status/$nationalId');
//     return AdmissionResponseModel.fromJson(response.data);
//   }
// }
