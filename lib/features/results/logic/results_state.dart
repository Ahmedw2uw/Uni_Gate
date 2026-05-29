import '../data/models/student_result_model.dart';

abstract class ResultsState {}

class ResultsInitial extends ResultsState {}

class ResultsLoading extends ResultsState {}

class ResultsSuccess extends ResultsState {
  final StudentResultResponse resultData;
  ResultsSuccess(this.resultData);
}

class ResultsFailure extends ResultsState {
  final String errorMessage;
  ResultsFailure(this.errorMessage);
}
