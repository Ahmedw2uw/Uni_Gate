import 'package:equatable/equatable.dart';
import 'package:nuigate/features/courses/domain/entities/course_entity.dart';

abstract class CoursesState extends Equatable {
  const CoursesState();

  @override
  List<Object?> get props => [];
}

class CoursesInitial extends CoursesState {
  const CoursesInitial();
}

class CoursesLoading extends CoursesState {
  const CoursesLoading();
}

class CoursesSuccess extends CoursesState {
  final List<CourseEntity> courses;

  const CoursesSuccess({required this.courses});

  @override
  List<Object?> get props => [courses];
}

class CoursesFailure extends CoursesState {
  final String message;

  const CoursesFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class CoursesUserNotAssigned extends CoursesState {
  const CoursesUserNotAssigned();
}

class CourseDetailsState extends CoursesState {
  final CourseEntity course;

  const CourseDetailsState({required this.course});

  @override
  List<Object?> get props => [course];
}

class CourseContentLoading extends CoursesState {
  const CourseContentLoading();
}

class CourseContentSuccess extends CoursesState {
  final CourseEntity course;
  final dynamic courseContent;

  const CourseContentSuccess({
    required this.course,
    required this.courseContent,
  });

  @override
  List<Object?> get props => [course, courseContent];
}

class CourseContentFailure extends CoursesState {
  final String message;

  const CourseContentFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
