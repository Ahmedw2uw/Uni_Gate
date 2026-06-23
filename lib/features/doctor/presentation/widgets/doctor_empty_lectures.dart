import 'package:flutter/material.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class DoctorEmptyLectures extends StatelessWidget {
  const DoctorEmptyLectures({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: CustomText(
        'لا توجد محاضرات مرفوعة لهذا الكورس بعد.',
        color: Colors.black54,
        textAlign: TextAlign.center,
      ),
    );
  }
}
