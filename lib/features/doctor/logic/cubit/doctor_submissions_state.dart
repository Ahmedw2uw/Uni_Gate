import 'package:equatable/equatable.dart';
import 'package:nuigate/features/doctor/domain/entities/doctor_submission_entity.dart';

class DoctorSubmissionsState extends Equatable {
  final List<DoctorSubmissionEntity> submissions;
  final bool isLoading;
  final bool isGrading;
  final String? errorMessage;
  final String? successMessage;

  const DoctorSubmissionsState({
    this.submissions = const [],
    this.isLoading = false,
    this.isGrading = false,
    this.errorMessage,
    this.successMessage,
  });

  DoctorSubmissionsState copyWith({
    List<DoctorSubmissionEntity>? submissions,
    bool? isLoading,
    bool? isGrading,
    String? errorMessage,
    String? successMessage,
    bool clearMessages = false,
  }) =>
      DoctorSubmissionsState(
        submissions: submissions ?? this.submissions,
        isLoading: isLoading ?? this.isLoading,
        isGrading: isGrading ?? this.isGrading,
        errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
        successMessage: clearMessages ? null : (successMessage ?? this.successMessage),
      );

  @override
  List<Object?> get props => [submissions, isLoading, isGrading, errorMessage, successMessage];
}
