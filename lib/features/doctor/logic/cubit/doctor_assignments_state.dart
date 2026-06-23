import 'package:equatable/equatable.dart';
import 'package:nuigate/features/doctor/domain/entities/doctor_assignment_entity.dart';

class DoctorAssignmentsState extends Equatable {
  final List<DoctorAssignmentEntity> assignments;
  final bool isUploading;
  final bool isDeleting;
  final String? errorMessage;
  final String? successMessage;

  const DoctorAssignmentsState({
    this.assignments = const [],
    this.isUploading = false,
    this.isDeleting = false,
    this.errorMessage,
    this.successMessage,
  });

  DoctorAssignmentsState copyWith({
    List<DoctorAssignmentEntity>? assignments,
    bool? isUploading,
    bool? isDeleting,
    String? errorMessage,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return DoctorAssignmentsState(
      assignments: assignments ?? this.assignments,
      isUploading: isUploading ?? this.isUploading,
      isDeleting: isDeleting ?? this.isDeleting,
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearMessages ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
    assignments,
    isUploading,
    isDeleting,
    errorMessage,
    successMessage,
  ];
}
