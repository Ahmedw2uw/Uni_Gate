import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/utils/pref_helpers.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  void updatePage(int index) {
    emit(state.copyWith(currentPage: index));
  }

  void nextPage(int totalPages) {
    if (state.currentPage < totalPages - 1) {
      emit(state.copyWith(currentPage: state.currentPage + 1));
    }
  }

  void previousPage() {
    if (state.currentPage > 0) {
      emit(state.copyWith(currentPage: state.currentPage - 1));
    }
  }

  Future<void> completeOnboarding() async {
    await PrefHelpers.saveOnboardingCompleted(true);
  }
}
