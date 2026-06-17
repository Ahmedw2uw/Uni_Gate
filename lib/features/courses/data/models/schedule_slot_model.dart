class ScheduleSlotModel {
  final int id;
  final int? dayOfWeek;
  final String? startTime;
  final String? endTime;
  final String? room;
  final int? semester;
  final int? academicYear;
  final String? slotType;

  const ScheduleSlotModel({
    required this.id,
    this.dayOfWeek,
    this.startTime,
    this.endTime,
    this.room,
    this.semester,
    this.academicYear,
    this.slotType,
  });

  factory ScheduleSlotModel.fromJson(Map<String, dynamic> json) {
    return ScheduleSlotModel(
      id: json['id'] ?? 0,
      dayOfWeek: json['dayOfWeek'] is int ? json['dayOfWeek'] : null,
      startTime: json['startTime']?.toString(),
      endTime: json['endTime']?.toString(),
      room: json['room']?.toString(),
      semester: json['semester'] is int ? json['semester'] : null,
      academicYear: json['academicYear'] is int ? json['academicYear'] : null,
      slotType: json['slotType']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'dayOfWeek': dayOfWeek,
    'startTime': startTime,
    'endTime': endTime,
    'room': room,
    'semester': semester,
    'academicYear': academicYear,
    'slotType': slotType,
  };
}
