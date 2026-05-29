import '../datasources/dashboard_remote_datasource.dart';

// لو عندك Domain Layer (Repository Interface) يفضل تعمل implements ليه هنا
class DashboardRepositoryImpl {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl(this.remoteDataSource);

  Future<Map<String, dynamic>> getStudentData() async {
    try {
      final data = await remoteDataSource.getStudentData();
      return data as Map<String, dynamic>;
    } catch (e) {
      throw Exception("فشل تحميل بيانات الداشبورد: $e");
    }
  }
}
