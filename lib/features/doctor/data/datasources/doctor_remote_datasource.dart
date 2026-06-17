import 'package:nuigate/features/doctor/data/models/doctor_course_model.dart';
import 'package:nuigate/network/api_services.dart';

abstract class DoctorRemoteDataSource {
  Future<List<DoctorCourseModel>> getInstructorCourses();
}

class DoctorRemoteDataSourceImpl implements DoctorRemoteDataSource {
  final ApiServices apiServices;

  DoctorRemoteDataSourceImpl(this.apiServices);

  @override
  Future<List<DoctorCourseModel>> getInstructorCourses() async {
    final response = await apiServices.get('/instructor/courses');

    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map(DoctorCourseModel.fromJson)
          .toList();
    }

    throw Exception('Failed to load instructor courses');
  }
}
