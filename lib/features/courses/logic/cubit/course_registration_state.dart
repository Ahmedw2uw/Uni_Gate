import 'package:equatable/equatable.dart';
import 'package:nuigate/features/courses/domain/entities/course_entity.dart';

abstract class CourseRegistrationState extends Equatable {
  const CourseRegistrationState();

  @override
  List<Object?> get props => [];
}

class CourseRegistrationInitial extends CourseRegistrationState {
  const CourseRegistrationInitial();
}

class AvailableCoursesLoading extends CourseRegistrationState {
  const AvailableCoursesLoading();
}

class AvailableCoursesLoaded extends CourseRegistrationState {
  final List<CourseEntity> courses;
  final List<String> selectedCourseIds;
  final int totalCreditHours;

  const AvailableCoursesLoaded({
    required this.courses,
    required this.selectedCourseIds,
    required this.totalCreditHours,
  });

  AvailableCoursesLoaded copyWith({
    List<CourseEntity>? courses,
    List<String>? selectedCourseIds,
    int? totalCreditHours,
  }) {
    return AvailableCoursesLoaded(
      courses: courses ?? this.courses,
      selectedCourseIds: selectedCourseIds ?? this.selectedCourseIds,
      totalCreditHours: totalCreditHours ?? this.totalCreditHours,
    );
  }

  @override
  List<Object?> get props => [courses, selectedCourseIds, totalCreditHours];
}

class AvailableCoursesError extends CourseRegistrationState {
  final String message;

  const AvailableCoursesError({required this.message});

  @override
  List<Object?> get props => [message];
}

class CourseRegistrationSubmitting extends CourseRegistrationState {
  const CourseRegistrationSubmitting();
}

class CourseRegistrationSuccess extends CourseRegistrationState {
  final String message;

  const CourseRegistrationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class CourseRegistrationFailure extends CourseRegistrationState {
  final String message;

  const CourseRegistrationFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class CourseDroppedSuccess extends CourseRegistrationState {
  const CourseDroppedSuccess();
}

class CoursesConfirmedSuccess extends CourseRegistrationState {
  const CoursesConfirmedSuccess();
}
