import 'package:nuigate/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:nuigate/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:nuigate/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:nuigate/features/auth/domain/usecases/auth_usecases.dart';
import 'package:nuigate/features/auth/logic/cubit/auth_cubit.dart';
import 'package:nuigate/features/courses/data/datasources/courses_remote_datasource.dart';
import 'package:nuigate/features/courses/data/repositories/courses_repository_impl.dart';
import 'package:nuigate/features/courses/domain/usecases/courses_usecases.dart';
import 'package:nuigate/features/courses/logic/cubit/courses_cubit.dart';
import 'package:nuigate/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:nuigate/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:nuigate/features/dashboard/logic/cubit/dashboard_cubit.dart';
import 'package:nuigate/features/exams/logic/cubit/exams_cubit.dart';
import 'package:nuigate/features/requests/logic/cubit/requests_cubit.dart';
import 'package:nuigate/features/results/logic/results_cubit.dart';
import 'package:nuigate/features/submission/logic/cubit/assignment_cubit.dart';
import 'package:nuigate/network/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceLocator {
  // 1. تعريف المتغيرات الثابتة (Getters)
  static late AuthCubit _authCubit;
  static AuthCubit get authCubit => _authCubit;

  static late CoursesCubit _coursesCubit;
  static CoursesCubit get coursesCubit => _coursesCubit;

  static late DashboardCubit _dashboardCubit;
  static DashboardCubit get dashboardCubit => _dashboardCubit;

  // إضافة الـ ExamsCubit بنفس أسلوب مشروعك
  static late ExamsCubit _examsCubit;
  static ExamsCubit get examsCubit => _examsCubit;

  static late AssignmentCubit _assignmentCubit;
  static AssignmentCubit get assignmentCubit => _assignmentCubit;
  static late ResultsCubit _resultsCubit;
  static ResultsCubit get resultsCubit => _resultsCubit;
  static late RequestsCubit _requestsCubit;
  static RequestsCubit get requestsCubit => _requestsCubit;
  static Future<void> init() async {
    // 1. External Dependencies
    final sharedPreferences = await SharedPreferences.getInstance();

    // 2. Core
    final apiServices = ApiServices();

    // ============= Auth Feature =============
    final authLocalDataSource = AuthLocalDataSourceImpl(sharedPreferences);
    final authRemoteDataSource = AuthRemoteDataSourceImpl(apiServices);
    final authRepository = AuthRepositoryImpl(
      remoteDataSource: authRemoteDataSource,
      localDataSource: authLocalDataSource,
    );

    _authCubit = AuthCubit(
      loginUseCase: LoginUseCase(authRepository),
      getCurrentUserUseCase: GetCurrentUserUseCase(authRepository),
      logoutUseCase: LogoutUseCase(authRepository),
      checkAuthStatusUseCase: CheckAuthStatusUseCase(authRepository),
    );

    // ============= Courses Feature =============
    final coursesRemoteDataSource = CoursesRemoteDataSourceImpl(apiServices);
    final coursesRepository = CoursesRepositoryImpl(
      remoteDataSource: coursesRemoteDataSource,
    );

    _coursesCubit = CoursesCubit(
      getCoursesUseCase: GetCoursesUseCase(coursesRepository),
      getCourseByIdUseCase: GetCourseByIdUseCase(coursesRepository),
      searchCoursesUseCase: SearchCoursesUseCase(coursesRepository),
      authCubit: _authCubit,
    );

    // ============= Dashboard Feature =============
    final dashboardRemoteDataSource = DashboardRemoteDataSourceImpl(
      apiServices,
    );
    final dashboardRepository = DashboardRepositoryImpl(
      dashboardRemoteDataSource,
    );
    _dashboardCubit = DashboardCubit(dashboardRepository);

    // ============= Exams Feature (التعديل الجديد) =============
    // نقوم بتعريف الـ Cubit وتمرير الـ apiServices له مباشرة كما في الأعلى
    _examsCubit = ExamsCubit(apiServices);

    // 2. أضف الـ Getter الخاص بالـ AssignmentCubit هنا 🔑

    // ============= Assignment Feature (إضافة التكليفات) =============
    // 3. قم بتهيئة الـ Cubit وتمرير ما يحتاجه (سواء الـ apiServices مباشرة أو الـ Repository)
    // على سبيل المثال إذا كان يعتمد على ريبوزيتوري:
    // final assignmentRemoteDataSource = AssignmentRemoteDataSourceImpl(apiServices);
    // final assignmentRepository = AssignmentRepositoryImpl(assignmentRemoteDataSource);
    // _assignmentCubit = AssignmentCubit(assignmentRepository);

    // أو إذا كان يستقبل الـ apiServices مباشرة مثل الـ Exams:
    _assignmentCubit = AssignmentCubit(apiServices);
    _resultsCubit = ResultsCubit(apiServices);
    _requestsCubit = RequestsCubit(apiServices);
  }
}
