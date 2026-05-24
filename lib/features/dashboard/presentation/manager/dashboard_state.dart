import '../../../auth/data/models/user_model.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}
class DashboardLoading extends DashboardState {}

class DashboardSuccess extends DashboardState {
  final UserModel userData; 
  DashboardSuccess(this.userData);
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}