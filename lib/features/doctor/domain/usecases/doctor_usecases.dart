import 'package:nuigate/features/doctor/domain/entities/doctor_course_entity.dart';
import 'package:nuigate/features/doctor/domain/repositories/doctor_repository.dart';

class GetInstructorCoursesUseCase {
  final DoctorRepository repository;

  GetInstructorCoursesUseCase(this.repository);

  Future<List<DoctorCourseEntity>> call() {
    return repository.getInstructorCourses();
  }
}
