import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfoView extends StatelessWidget {
  const InfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, String>;
    return Scaffold(
      appBar: AppBar(title: Text(args['title']!.tr)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(args['body']!.tr,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.8)),
      ),
    );
  }
}
