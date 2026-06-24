import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class DoctorEmptyLectures extends StatelessWidget {
  const DoctorEmptyLectures({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h),
      child: const CustomText(
        'لا توجد محاضرات مرفوعة لهذا الكورس بعد.',
        color: Colors.black54,
        textAlign: TextAlign.center,
      ),
    );
  }
}
