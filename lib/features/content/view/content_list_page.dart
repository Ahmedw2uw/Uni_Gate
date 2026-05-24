import 'package:flutter/material.dart';

class ContentListPage extends StatelessWidget {
  const ContentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Center(
          child: const Text(
            'المواد',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: const Center(child: Text('قائمة المحتوى')),
    );
  }
}
//! strart from hear
