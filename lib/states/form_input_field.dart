import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormInputFieldState extends GetxController {
  var errorMessage = ''.obs;
  late final TextEditingController controller;
  final String? Function(String)? validator;
  bool isInitd = false;

  FormInputFieldState({this.validator, String initialText = ''}) {
    controller = TextEditingController(text: initialText);
  }

  @override
  void onReady() {
    controller.addListener(() {
      if (validator == null) return;
      errorMessage.value = validator!(controller.text) ?? '';
      update();
    });
  }
}