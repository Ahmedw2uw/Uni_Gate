import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/features/payment/payment_page.dart';
import 'package:nuigate/features/requests/requests_page.dart';
import 'package:nuigate/features/submission/presentation/cubit/assignment_cubit.dart';
import 'core/app_colors.dart';
import 'core/app_strings.dart';
import 'core/service_locator.dart';
import 'utils/pref_helpers.dart';
import 'features/auth/view/login_page.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/auth_state.dart';
import 'features/courses/presentation/cubit/courses_cubit.dart';
import 'features/dashboard/view/dashboard_page.dart';
import 'features/courses/view/courses_page.dart';
import 'features/schedule/view/schedule_page.dart';
import 'features/exams/view/exams_page.dart';
import 'features/results/view/results_page.dart';
import 'features/content/view/content_list_page.dart';
import 'features/submission/presentation/view/submission_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة PrefHelpers (SharedPreferences)
  await PrefHelpers.init();

  // تهيئة الـ Service Locator
  await ServiceLocator.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) {
            final cubit = ServiceLocator.authCubit;
            // استدعاء checkAuthStatus بعد بناء الشجرة
            // WidgetsBinding.instance.addPostFrameCallback((_) {
            //   cubit.checkAuthStatus();
            // });
            return cubit;
          },
        ),
        BlocProvider<CoursesCubit>.value(
  value: ServiceLocator.coursesCubit,
),
        BlocProvider<AssignmentCubit>(
  create: (context) => ServiceLocator.assignmentCubit, 
),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appTitle,
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar')],
        localizationsDelegates: [
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

/// Wrapper لاختيار الصفحة الأولى حسب حالة المصادقة
class _HomeWrapper extends StatefulWidget {
  const _HomeWrapper();

  @override
  State<_HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<_HomeWrapper> {
  @override
  void initState() {
    super.initState();
    // التحقق من حالة المصادقة عند بدء التطبيق
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          // التحقق من دور المستخدم
          final authCubit = context.read<AuthCubit>();
          final isAdmin = authCubit.isAdmin(state);

          // إذا كان Admin، عرض Admin Dashboard
          if (isAdmin) {
            return const Scaffold(
              body: Center(child: Text('📊 Admin Dashboard')),
            );
          }

          // وإلا، عرض User Dashboard
          return const DashboardPage();
        } else if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
