import 'package:nuigate/features/doctor/domain/entities/doctor_course_entity.dart';

abstract class DoctorRepository {
  Future<List<DoctorCourseEntity>> getInstructorCourses();
}
