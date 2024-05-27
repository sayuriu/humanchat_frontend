import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Unknown extends StatelessWidget {
  const Unknown({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unknown page'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Get.back()),
      ),
      body: const Center(
        child: Text('The page you are looking for does not exist.'),
      )
    );
  }
}