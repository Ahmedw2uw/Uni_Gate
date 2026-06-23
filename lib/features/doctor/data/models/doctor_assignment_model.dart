import 'package:nuigate/features/doctor/domain/entities/doctor_assignment_entity.dart';

class DoctorAssignmentModel extends DoctorAssignmentEntity {
  const DoctorAssignmentModel({
    required super.assignmentId,
    required super.title,
    required super.description,
    super.dueDate,
    required super.maxGrade,
    required super.fileUrl,
    super.createdAt,
  });

  factory DoctorAssignmentModel.fromJson(Map<String, dynamic> json) {
    return DoctorAssignmentModel(
      assignmentId: _toInt(json['assignmentId']),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      dueDate: _toDate(json['dueDate']),
      maxGrade: _toDouble(json['maxGrade']),
      fileUrl: json['fileUrl']?.toString() ?? '',
      createdAt: _toDate(json['createdAt']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
