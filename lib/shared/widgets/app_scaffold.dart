import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  const AppScaffold({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Directionality(textDirection: TextDirection.rtl, child: child),
      backgroundColor: AppColors.background,
    );
  }
}
