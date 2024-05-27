import 'dart:async';

import 'package:get/get.dart';

String? validateEmail(String email) {
  if (email.isEmpty) {
    return 'Email is required';
  }
  if (!GetUtils.isEmail(email)) {
    return 'Invalid email';
  }
  return null;
}


String? validatePassword(String password) {
  if (password.length < 8) {
      return 'At least 8 characters required';
    }
  return null;
}

String? validateUsername(String username) {
  if (username.isEmpty) {
    return 'Username is required';
  }
  if (!GetUtils.isUsername(username)) {
    return 'Invalid username';
  }
  return null;
}

Future<T?> Function(T)?  validateWithReactive<T>(RxBool reactiveState, FutureOr<T?> Function(T) validator) {
  return (T value) async {
    reactiveState.value = false;
    final result = await validator(value);
    reactiveState.value = result == null;
    return result;
  };
}