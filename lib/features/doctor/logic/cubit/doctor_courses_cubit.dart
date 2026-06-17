import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/features/doctor/domain/usecases/doctor_usecases.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_courses_state.dart';

class DoctorCoursesCubit extends Cubit<DoctorCoursesState> {
  final GetInstructorCoursesUseCase getInstructorCoursesUseCase;

  DoctorCoursesCubit({required this.getInstructorCoursesUseCase})
    : super(const DoctorCoursesInitial());

  Future<void> fetchInstructorCourses() async {
    if (state is DoctorCoursesLoading) return;

    emit(const DoctorCoursesLoading());
    try {
      final courses = await getInstructorCoursesUseCase();
      emit(DoctorCoursesLoaded(courses));
    } catch (e) {
      emit(DoctorCoursesFailure(e.toString()));
    }
  }
}
