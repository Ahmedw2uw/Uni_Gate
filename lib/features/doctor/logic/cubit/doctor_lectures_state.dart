import 'package:equatable/equatable.dart';
import 'package:nuigate/features/doctor/domain/entities/doctor_lecture_entity.dart';

class DoctorLecturesState extends Equatable {
  final List<DoctorLectureEntity> lectures;
  final bool isUploading;
  final bool isDeleting;
  final String? errorMessage;
  final String? successMessage;

  const DoctorLecturesState({
    this.lectures = const [],
    this.isUploading = false,
    this.isDeleting = false,
    this.errorMessage,
    this.successMessage,
  });

  DoctorLecturesState copyWith({
    List<DoctorLectureEntity>? lectures,
    bool? isUploading,
    bool? isDeleting,
    String? errorMessage,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return DoctorLecturesState(
      lectures: lectures ?? this.lectures,
      isUploading: isUploading ?? this.isUploading,
      isDeleting: isDeleting ?? this.isDeleting,
      errorMessage: clearMessages ? null : errorMessage,
      successMessage: clearMessages ? null : successMessage,
    );
  }

  @override
  List<Object?> get props => [
    lectures,
    isUploading,
    isDeleting,
    errorMessage,
    successMessage,
  ];
}
