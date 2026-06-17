import 'package:nuigate/features/doctor/data/datasources/doctor_remote_datasource.dart';
import 'package:nuigate/features/doctor/domain/entities/doctor_course_entity.dart';
import 'package:nuigate/features/doctor/domain/repositories/doctor_repository.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final DoctorRemoteDataSource remoteDataSource;

  DoctorRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<DoctorCourseEntity>> getInstructorCourses() {
    return remoteDataSource.getInstructorCourses();
  }
}
