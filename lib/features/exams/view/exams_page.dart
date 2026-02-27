import 'package:flutter/material.dart';

class ExamsPage extends StatelessWidget {
  const ExamsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الامتحانات')),
      body: const Center(child: Text('قائمة الامتحانات')),
    );
  }
}
