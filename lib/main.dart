import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/app_colors.dart';
import 'core/app_strings.dart';
import 'features/auth/view/login_page.dart';
import 'features/dashboard/view/dashboard_page.dart';
import 'features/courses/view/courses_page.dart';
import 'features/schedule/view/schedule_page.dart';
import 'features/profile/view/profile_page.dart';
import 'features/exams/view/exams_page.dart';
import 'features/results/view/results_page.dart';
import 'features/content/view/content_list_page.dart';
import 'features/submission/view/submission_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        '/': (ctx) => const DashboardPage(),
        '/courses': (ctx) => const CoursesPage(),
        '/schedule': (ctx) => const SchedulePage(),
        '/profile': (ctx) => const ProfilePage(),
        '/exams': (ctx) => const ExamsPage(),
        '/results': (ctx) => const ResultsPage(),
        '/content': (ctx) => const ContentListPage(),
        '/submission': (ctx) => const SubmissionPage(),
      },
      initialRoute: '/login',
    );
  }
}
