import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/core/app_strings.dart';
import 'package:nuigate/core/service_locator.dart';
import 'package:nuigate/features/auth/logic/cubit/auth_cubit.dart';
import 'package:nuigate/features/auth/logic/cubit/auth_state.dart';
import 'package:nuigate/features/auth/presentation/view/login_page.dart';
import 'package:nuigate/features/content/presentation/view/content_list_page.dart';
import 'package:nuigate/features/courses/logic/cubit/courses_cubit.dart';
import 'package:nuigate/features/courses/presentation/view/courses_page.dart';
import 'package:nuigate/features/dashboard/presentation/view/dashboard_page.dart';
import 'package:nuigate/features/exams/presentation/view/exams_page.dart';
import 'package:nuigate/features/payment/presentation/view/payment_page.dart';
import 'package:nuigate/features/requests/logic/cubit/requests_cubit.dart';
import 'package:nuigate/features/requests/presentation/view/requests_page.dart';
import 'package:nuigate/features/results/logic/results_cubit.dart';
import 'package:nuigate/features/results/presentation/view/results_page.dart';
import 'package:nuigate/features/schedule/presentation/view/schedule_page.dart';
import 'package:nuigate/features/submission/logic/cubit/assignment_cubit.dart';
import 'package:nuigate/features/submission/presentation/view/submission_page.dart';
import 'package:nuigate/utils/pref_helpers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefHelpers.init();
  await ServiceLocator.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: ServiceLocator.authCubit),
        BlocProvider<CoursesCubit>.value(value: ServiceLocator.coursesCubit),
        BlocProvider<AssignmentCubit>.value(
          value: ServiceLocator.assignmentCubit,
        ),
        BlocProvider<ResultsCubit>.value(value: ServiceLocator.resultsCubit),
        BlocProvider<RequestsCubit>.value(value: ServiceLocator.requestsCubit),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appTitle,
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
          ).copyWith(secondary: AppColors.accent),
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(backgroundColor: AppColors.primary),
        ),
        routes: {
          '/login': (ctx) => const LoginPage(),
          '/courses': (ctx) => const CoursesPage(),
          '/schedule': (ctx) => const SchedulePage(),
          '/exams': (ctx) => const ExamsPage(),
          '/results': (ctx) => const ResultsPage(),
          '/content': (ctx) => const ContentListPage(),
          '/submission': (ctx) => const SubmissionPage(),
          '/payment': (ctx) => const PaymentPage(),
          '/requests': (ctx) => const RequestsPage(),
        },
        home: const _HomeWrapper(),
      ),
    );
  }
}

class _HomeWrapper extends StatefulWidget {
  const _HomeWrapper();

  @override
  State<_HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<_HomeWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AuthCubit>().checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          final isAdmin = context.read<AuthCubit>().isAdmin(state);
          if (isAdmin) {
            return const Scaffold(body: Center(child: Text('Admin Dashboard')));
          }
          return const DashboardPage();
        }

        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return const LoginPage();
      },
    );
  }
}
