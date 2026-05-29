// States
import 'package:nuigate/features/exams/data/exam_info.dart';

abstract class ExamsState {}

class ExamsInitial extends ExamsState {}

class ExamsLoading extends ExamsState {}

class ExamsSuccess extends ExamsState {
  final List<ExamInfo> exams;
  ExamsSuccess(this.exams);
}

class ExamsFailure extends ExamsState {
  final String message;
  ExamsFailure(this.message);
}

class ExamQuestionsLoading extends ExamsState {}

class ExamQuestionsFailure extends ExamsState {
  final String message;
  ExamQuestionsFailure(this.message);
}

class ExamQuestionsSuccess extends ExamsState {
  final ExamStartResponse examData; // شايل الأسئلة والاختيارات والوقت المتبقي
  ExamQuestionsSuccess(this.examData);
}

// حالات تسليم الامتحان
class ExamSubmitLoading extends ExamsState {}

class ExamSubmitSuccess extends ExamsState {
  final String message;
  ExamSubmitSuccess(this.message);
}

class ExamSubmitFailure extends ExamsState {
  final String errorMessage;
  ExamSubmitFailure(this.errorMessage);
}
