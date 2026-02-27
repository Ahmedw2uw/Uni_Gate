import 'package:flutter/material.dart';

class SubmissionPage extends StatelessWidget {
  const SubmissionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التسليم')),
      body: const Center(child: Text('صفحة التسليم')),
    );
  }
}
