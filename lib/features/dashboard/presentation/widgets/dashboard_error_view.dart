import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class DashboardErrorView extends StatelessWidget {
  final String message;

  const DashboardErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isAuthError = message == '401';

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 50.r),
            SizedBox(height: 12.h),
            CustomText(
              isAuthError ? 'انتهت الجلسة' : 'فشل تحميل البيانات',
              fontSize: 15,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15.h),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/login'),
              child: Text(isAuthError ? 'تسجيل الدخول' : 'إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
