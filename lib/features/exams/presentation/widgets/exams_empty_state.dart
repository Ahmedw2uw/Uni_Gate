import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class ExamsEmptyState extends StatelessWidget {
  final String message;
  final Color? color;

  const ExamsEmptyState({super.key, required this.message, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: CustomText(
          message,
          color: color,
          fontSize: 15,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
