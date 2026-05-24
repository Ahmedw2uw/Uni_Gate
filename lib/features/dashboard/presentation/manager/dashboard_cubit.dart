import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/features/dashboard/data/datasources/data/repositories/dashboard_repository_impl.dart';
import '../../../auth/data/models/user_model.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepositoryImpl repository;

  DashboardCubit(this.repository) : super(DashboardInitial());

  Future<void> getStudentData() async {
    emit(DashboardLoading());
    try {
      final data = await repository.getStudentData();
      final userModel = UserModel.fromJson(data);
      emit(DashboardSuccess(userModel)); 
    } catch (e) {
      String error = e.toString();
      // معالجة خطأ التوكن المنتهي 401
      emit(DashboardError(error.contains('401') ? "401" : error));
    }
  }
}