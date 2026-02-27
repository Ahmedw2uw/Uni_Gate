import 'package:flutter/material.dart';

class ContentListPage extends StatelessWidget {
  const ContentListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المواد')),
      body: const Center(child: Text('قائمة المحتوى')),
    );
  }
}
