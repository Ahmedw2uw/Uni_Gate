import 'package:nuigate/features/doctor/domain/entities/doctor_exam_entity.dart';

class DoctorExamModel extends DoctorExamEntity {
  const DoctorExamModel({
    required super.examId,
    required super.title,
    required super.examType,
    required super.durationMinutes,
    super.startTime,
    required super.fileUrl,
    super.createdAt,
  });

  factory DoctorExamModel.fromJson(Map<String, dynamic> json) {
    return DoctorExamModel(
      examId: _toInt(json['examId']),
      title: json['title']?.toString() ?? '',
      examType: _toInt(json['examType']),
      durationMinutes: _toInt(json['durationMinutes']),
      startTime: _toDate(json['startTime']),
      fileUrl: json['fileUrl']?.toString() ?? '',
      createdAt: _toDate(json['createdAt']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
