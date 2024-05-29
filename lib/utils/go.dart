import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Go {
  /// Similar to **Navigation.push()**
  static to<T>(
    Widget Function() page,
    {
      dynamic arguments,
      Transition? transition,
      bool? opaque,
      Curve curve = Curves.easeInOutCubicEmphasized,
    }
  ) {
    return Get.to<T>(
      page,
      arguments: arguments,
      transition: transition ?? Transition.rightToLeft,
      duration: const Duration(milliseconds: 350),
      curve: curve,
      opaque: opaque
    );
  }

  /// Similar to **Navigation.pushReplacement**
  static Future<dynamic> off(
    dynamic page,
    {
      dynamic arguments,
      Transition? transition,
      Curve curve = Curves.easeInOutCubicEmphasized
    }
  ) async {
    Get.off(
      page,
      arguments: arguments,
      transition: transition ?? Transition.rightToLeft,
      curve: curve,
      duration: const Duration(milliseconds: 350),
    );
  }

  /// Similar to **Navigation.pushAndRemoveUntil()**
  static Future<dynamic> offUntil(
    dynamic page,
    {
      Transition? transition,
      curve = Curves.easeInOutCubicEmphasized
    }
  ) async {
    Get.offUntil(
      GetPageRoute(
        page: page,
        transition: transition ?? Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 350),
        curve: curve
      ),
      (route) => false);
  }
}