import 'package:flutter/material.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class ExamsEmptyState extends StatelessWidget {
  final String message;
  final Color? color;

  const ExamsEmptyState({super.key, required this.message, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(child: CustomText(message, color: color));
  }
}
