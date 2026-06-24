import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class DoctorEmptyCourses extends StatelessWidget {
  const DoctorEmptyCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: const CustomText(
          'لا توجد كورسات مسندة لهذا الدكتور حالياً',
          fontSize: 15,
          color: Colors.black54,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
