import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/core/service_locator.dart';
import 'package:nuigate/features/auth/logic/cubit/auth_cubit.dart';
import 'package:nuigate/features/dashboard/logic/cubit/dashboard_cubit.dart';
import 'package:nuigate/features/dashboard/logic/cubit/dashboard_state.dart';
import 'package:nuigate/features/dashboard/presentation/widgets/dashboard_error_view.dart';
import 'package:nuigate/features/dashboard/presentation/widgets/dashboard_success_view.dart';
import 'package:nuigate/shared/widgets/app_scaffold.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServiceLocator.dashboardCubit..getStudentData(),
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          return AppScaffold(
            title: _resolveTitle(state),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                tooltip: 'تسجيل الخروج',
                onPressed: () => _confirmLogout(context),
              ),
            ],
            child: _DashboardBody(state: state),
          );
        },
      ),
    );
  }

  String _resolveTitle(DashboardState state) {
    if (state is DashboardSuccess) {
      return 'أهلا، ${state.userData.name.split(' ').first}';
    }
    return 'لوحة التحكم';
  }

  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('تأكيد الخروج'),
          content: const Text('هل تريد تسجيل الخروج فعلا؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await context.read<AuthCubit>().logout();
              },
              child: const Text('تسجيل الخروج'),
            ),
          ],
        );
      },
    );
  }
}

class _DashboardBody extends StatelessWidget {
  final DashboardState state;

  const _DashboardBody({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state is DashboardLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is DashboardError) {
      return DashboardErrorView(message: (state as DashboardError).message);
    }

    if (state is DashboardSuccess) {
      return DashboardSuccessView(user: (state as DashboardSuccess).userData);
    }

    return const SizedBox.shrink();
  }
}
