import 'package:equatable/equatable.dart';
import 'package:nuigate/features/doctor/domain/entities/doctor_course_entity.dart';

sealed class DoctorCoursesState extends Equatable {
  const DoctorCoursesState();

  @override
  List<Object?> get props => [];
}

class DoctorCoursesInitial extends DoctorCoursesState {
  const DoctorCoursesInitial();
}

class DoctorCoursesLoading extends DoctorCoursesState {
  const DoctorCoursesLoading();
}

class DoctorCoursesLoaded extends DoctorCoursesState {
  final List<DoctorCourseEntity> courses;

  const DoctorCoursesLoaded(this.courses);

  @override
  List<Object?> get props => [courses];
}

class DoctorCoursesFailure extends DoctorCoursesState {
  final String message;

  const DoctorCoursesFailure(this.message);

  @override
  List<Object?> get props => [message];
}
