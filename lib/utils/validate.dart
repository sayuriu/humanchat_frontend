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

T? Function(T) validateWithReactive<T>(RxBool reactiveState, T? Function(T) validator) {
  return (T value) {
    reactiveState.value = false;
    final result = validator(value);
    reactiveState.value = result == null;
    return result;
  };
}