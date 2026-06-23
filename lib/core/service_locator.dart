import 'package:nuigate/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:nuigate/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:nuigate/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:nuigate/features/auth/domain/usecases/auth_usecases.dart';
import 'package:nuigate/features/auth/logic/cubit/auth_cubit.dart';
import 'package:nuigate/features/courses/data/datasources/courses_remote_datasource.dart';
import 'package:nuigate/features/courses/data/repositories/courses_repository_impl.dart';
import 'package:nuigate/features/courses/domain/usecases/courses_usecases.dart';
import 'package:nuigate/features/courses/logic/cubit/course_registration_cubit.dart';
import 'package:nuigate/features/courses/logic/cubit/courses_cubit.dart';
import 'package:nuigate/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:nuigate/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:nuigate/features/dashboard/logic/cubit/dashboard_cubit.dart';
import 'package:nuigate/features/doctor/data/datasources/doctor_remote_datasource.dart';
import 'package:nuigate/features/doctor/data/repositories/doctor_repository_impl.dart';
import 'package:nuigate/features/doctor/domain/usecases/doctor_usecases.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_courses_cubit.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_lectures_cubit.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_navigation_cubit.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_assignments_cubit.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_exams_cubit.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_submissions_cubit.dart';
import 'package:nuigate/features/exams/logic/cubit/exams_cubit.dart';
import 'package:nuigate/features/payment/data/datasources/payment_remote_datasource.dart';
import 'package:nuigate/features/payment/data/repositories/payment_repository_impl.dart';
import 'package:nuigate/features/payment/domain/usecases/payment_usecases.dart';
import 'package:nuigate/features/payment/logic/cubit/payment_cubit.dart';
import 'package:nuigate/features/requests/logic/cubit/requests_cubit.dart';
import 'package:nuigate/features/results/logic/results_cubit.dart';
import 'package:nuigate/features/submission/logic/cubit/assignment_cubit.dart';
import 'package:nuigate/network/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceLocator {
  static late AuthCubit _authCubit;
  static AuthCubit get authCubit => _authCubit;

  static late CoursesCubit _coursesCubit;
  static CoursesCubit get coursesCubit => _coursesCubit;

  static late CourseRegistrationCubit _courseRegistrationCubit;
  static CourseRegistrationCubit get courseRegistrationCubit =>
      _courseRegistrationCubit;

  static late DashboardCubit _dashboardCubit;
  static DashboardCubit get dashboardCubit => _dashboardCubit;

  static late ExamsCubit _examsCubit;
  static ExamsCubit get examsCubit => _examsCubit;

  static late AssignmentCubit _assignmentCubit;
  static AssignmentCubit get assignmentCubit => _assignmentCubit;
  static late ResultsCubit _resultsCubit;
  static ResultsCubit get resultsCubit => _resultsCubit;
  static late RequestsCubit _requestsCubit;
  static RequestsCubit get requestsCubit => _requestsCubit;

  static late PaymentCubit _paymentCubit;
  static PaymentCubit get paymentCubit => _paymentCubit;

  static late DoctorCoursesCubit _doctorCoursesCubit;
  static DoctorCoursesCubit get doctorCoursesCubit => _doctorCoursesCubit;

  static late DoctorNavigationCubit _doctorNavigationCubit;
  static DoctorNavigationCubit get doctorNavigationCubit =>
      _doctorNavigationCubit;

  static late DoctorLecturesCubit _doctorLecturesCubit;
  static DoctorLecturesCubit get doctorLecturesCubit => _doctorLecturesCubit;

  static late DoctorAssignmentsCubit _doctorAssignmentsCubit;
  static DoctorAssignmentsCubit get doctorAssignmentsCubit =>
      _doctorAssignmentsCubit;

  static late DoctorExamsCubit _doctorExamsCubit;
  static DoctorExamsCubit get doctorExamsCubit => _doctorExamsCubit;

  static late DoctorSubmissionsCubit _doctorSubmissionsCubit;
  static DoctorSubmissionsCubit get doctorSubmissionsCubit =>
      _doctorSubmissionsCubit;

  static Future<void> init() async {
    final sharedPreferences = await SharedPreferences.getInstance();
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
      getCourseWithContentUseCase: GetCourseWithContentUseCase(
        coursesRepository,
      ),
      getCourseContentUseCase: GetCourseContentUseCase(coursesRepository),
      getMyCoursesUseCase: GetMyCoursesUseCase(coursesRepository),
      authCubit: _authCubit,
    );

    _courseRegistrationCubit = CourseRegistrationCubit(
      getAvailableCoursesUseCase: GetAvailableCoursesUseCase(coursesRepository),
      registerCoursesUseCase: RegisterCoursesUseCase(coursesRepository),
      dropCourseUseCase: DropCourseUseCase(coursesRepository),
      confirmCoursesUseCase: ConfirmCoursesUseCase(coursesRepository),
      checkCourseExistsUseCase: CheckCourseExistsUseCase(coursesRepository),
    );

    // ============= Dashboard Feature =============
    final dashboardRemoteDataSource = DashboardRemoteDataSourceImpl(
      apiServices,
    );
    final dashboardRepository = DashboardRepositoryImpl(
      dashboardRemoteDataSource,
    );
    _dashboardCubit = DashboardCubit(dashboardRepository);

    // ============= Exams Feature =============
    _examsCubit = ExamsCubit(apiServices);

    // ============= Assignment Feature =============
    _assignmentCubit = AssignmentCubit(apiServices);
    _resultsCubit = ResultsCubit(apiServices);
    _requestsCubit = RequestsCubit(apiServices);
    _doctorAssignmentsCubit = DoctorAssignmentsCubit(apiServices);
    _doctorExamsCubit = DoctorExamsCubit(apiServices);
    _doctorSubmissionsCubit = DoctorSubmissionsCubit(apiServices);

    // ============= Doctor Feature =============
    final doctorRemoteDataSource = DoctorRemoteDataSourceImpl(apiServices);
    final doctorRepository = DoctorRepositoryImpl(doctorRemoteDataSource);
    _doctorCoursesCubit = DoctorCoursesCubit(
      getInstructorCoursesUseCase: GetInstructorCoursesUseCase(
        doctorRepository,
      ),
    );
    _doctorNavigationCubit = DoctorNavigationCubit();
    _doctorLecturesCubit = DoctorLecturesCubit(apiServices);

    // ============= Payment Feature =============
    final paymentRemoteDataSource = PaymentRemoteDataSourceImpl(apiServices);
    final paymentRepository = PaymentRepositoryImpl(paymentRemoteDataSource);
    _paymentCubit = PaymentCubit(
      getMyPaymentsUseCase: GetMyPaymentsUseCase(paymentRepository),
      checkoutUseCase: CheckoutUseCase(paymentRepository),
      refundRequestUseCase: RefundRequestUseCase(paymentRepository),
      getPaymentSuccessUseCase: GetPaymentSuccessUseCase(paymentRepository),
    );
  }
}
