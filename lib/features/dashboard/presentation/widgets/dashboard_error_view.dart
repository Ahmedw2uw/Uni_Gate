import 'package:flutter/material.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class DashboardErrorView extends StatelessWidget {
  final String message;

  const DashboardErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isAuthError = message == '401';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 50),
          CustomText(isAuthError ? 'انتهت الجلسة' : 'فشل تحميل البيانات'),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            child: Text(isAuthError ? 'تسجيل الدخول' : 'إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}
