import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  const AppScaffold({Key? key, required this.title, required this.child})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true, elevation: 0),
      body: Directionality(textDirection: TextDirection.rtl, child: child),
      backgroundColor: AppColors.background,
    );
  }
}
