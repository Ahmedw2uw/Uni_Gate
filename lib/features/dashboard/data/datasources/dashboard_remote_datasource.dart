import '../../../../../../network/api_services.dart';

abstract class DashboardRemoteDataSource {
  Future<dynamic> getStudentData();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiServices apiServices;

  DashboardRemoteDataSourceImpl(this.apiServices);

  @override
  Future<dynamic> getStudentData() async {
    // تأكد من مسار الـ API الصحيح من الـ Swagger عندك
    final response = await apiServices.get('/Students/me/profile');
    return response.data;
  }
}
