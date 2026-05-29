import 'package:nuigate/features/submission/data/models/assignment_submission.dart';

abstract class AssignmentState {}

class AssignmentInitial extends AssignmentState {}

// حالات جلب التكليفات للمادة
class AssignmentLoading extends AssignmentState {}

class AssignmentSuccess extends AssignmentState {
  final List<AssignmentModel> assignments;
  AssignmentSuccess(this.assignments);
}

class AssignmentFailure extends AssignmentState {
  final String errorMessage;
  AssignmentFailure(this.errorMessage);
}

// حالات رفع/إرسال حل التكليف
class AssignmentUploadLoading extends AssignmentState {}

class AssignmentUploadSuccess extends AssignmentState {
  final String message;
  AssignmentUploadSuccess(this.message);
}

class AssignmentUploadFailure extends AssignmentState {
  final String errorMessage;
  AssignmentUploadFailure(this.errorMessage);
}
