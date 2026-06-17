import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/features/doctor/domain/entities/doctor_course_entity.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_navigation_state.dart';

class DoctorNavigationCubit extends Cubit<DoctorNavigationState> {
  DoctorNavigationCubit() : super(const DoctorNavigationState());

  void selectTab(DoctorTab tab) {
    if (tab == state.selectedTab) return;
    emit(state.copyWith(selectedTab: tab));
  }

  void openCourseLectures(DoctorCourseEntity course) {
    emit(
      state.copyWith(selectedTab: DoctorTab.lectures, selectedCourse: course),
    );
  }
}
