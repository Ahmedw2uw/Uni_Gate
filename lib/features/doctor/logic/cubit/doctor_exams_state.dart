import 'package:equatable/equatable.dart';
import 'package:nuigate/features/doctor/domain/entities/doctor_exam_entity.dart';

class DoctorExamsState extends Equatable {
  final List<DoctorExamEntity> exams;
  final bool isUploading;
  final bool isDeleting;
  final String? errorMessage;
  final String? successMessage;

  const DoctorExamsState({
    this.exams = const [],
    this.isUploading = false,
    this.isDeleting = false,
    this.errorMessage,
    this.successMessage,
  });

  DoctorExamsState copyWith({
    List<DoctorExamEntity>? exams,
    bool? isUploading,
    bool? isDeleting,
    String? errorMessage,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return DoctorExamsState(
      exams: exams ?? this.exams,
      isUploading: isUploading ?? this.isUploading,
      isDeleting: isDeleting ?? this.isDeleting,
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearMessages ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
    exams,
    isUploading,
    isDeleting,
    errorMessage,
    successMessage,
  ];
}
