class ExamInfo {
  final int id;
  final String title;
  final String courseName;
  final String instructorName;
  final int durationMinutes;
  final String startTime;
  final String endTime;
  final bool isActive;
  final int examType;
  final bool alreadySubmitted;
  final bool isInProgress;

  ExamInfo({
    required this.id,
    required this.title,
    required this.courseName,
    required this.instructorName,
    required this.durationMinutes,
    required this.startTime,
    required this.endTime,
    required this.isActive,
    required this.examType,
    required this.alreadySubmitted,
    required this.isInProgress,
  });

  factory ExamInfo.fromJson(Map<String, dynamic> json) {
    return ExamInfo(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      courseName: json['courseName'] ?? '',
      instructorName: json['instructorName'] ?? '',
      durationMinutes: json['durationMinutes'] ?? 0,
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      isActive: json['isActive'] ?? false,
      examType: json['examType'] ?? 0,
      alreadySubmitted: json['alreadySubmitted'] ?? false,
      isInProgress: json['isInProgress'] ?? false,
    );
  }
}

// في ملف exam_model.dart أضف هذا الكلاس
// 1. الموديل الرئيسي لبيانات محاولة الامتحان (الـ Response اللي راجع من الـ start)
class ExamStartResponse {
  final int examResultId;
  final String examTitle;
  final String instructorName;
  final int durationMinutes;
  final String startedAt;
  final String examEndsAt;
  final int remainingSeconds;
  final List<ExamQuestion> questions;

  ExamStartResponse({
    required this.examResultId,
    required this.examTitle,
    required this.instructorName,
    required this.durationMinutes,
    required this.startedAt,
    required this.examEndsAt,
    required this.remainingSeconds,
    required this.questions,
  });

  factory ExamStartResponse.fromJson(Map<String, dynamic> json) {
    return ExamStartResponse(
      examResultId: json['examResultId'] ?? 0,
      examTitle: json['examTitle'] ?? '',
      instructorName: json['instructorName'] ?? '',
      durationMinutes: json['durationMinutes'] ?? 0,
      startedAt: json['startedAt'] ?? '',
      examEndsAt: json['examEndsAt'] ?? '',
      remainingSeconds: json['remainingSeconds'] ?? 0,
      questions: (json['questions'] as List? ?? [])
          .map((q) => ExamQuestion.fromJson(q))
          .toList(),
    );
  }
}

// 2. كلاس السؤال المعدل بالكامل ليتطابق مع الـ JSON
class ExamQuestion {
  final int id;
  final String text;
  final int orderIndex;
  final int marks;
  final int? selectedOptionId; // لتخزين إجابة الطالب الحالية
  final List<ExamOption> options; // تحويلها إلى موديل مخصص وليس String

  const ExamQuestion({
    required this.id,
    required this.text,
    required this.orderIndex,
    required this.marks,
    this.selectedOptionId,
    required this.options,
  });

  factory ExamQuestion.fromJson(Map<String, dynamic> json) {
    return ExamQuestion(
      id: json['id'] ?? 0,
      text: json['questionText'] ?? '',
      orderIndex: json['orderIndex'] ?? 0,
      marks: json['marks'] ?? 0,
      selectedOptionId: json['selectedOptionId'],
      // تحويل الـ options من الـ JSON بشكل صحيح
      options: (json['options'] as List? ?? [])
          .map((o) => ExamOption.fromJson(o))
          .toList(),
    );
  }
}

// 3. كلاس الاختيارات الجديد
class ExamOption {
  final int id;
  final String optionText;

  ExamOption({required this.id, required this.optionText});

  factory ExamOption.fromJson(Map<String, dynamic> json) {
    return ExamOption(
      id: json['id'] ?? 0,
      optionText: json['optionText'] ?? '',
    );
  }
}
