import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


final AppAnimationSettings appAnimationSettingsController = Get.put(AppAnimationSettings());



class AppAnimationSettings extends GetxController {
  final Rx<Curve> _curve = CustomCurves.easeOutCirc.obs;
  final Rx<Duration> _transitionDuration = Durations.medium4.obs;
  final Rx<Duration> _reverseTransitionDuration = Durations.medium1.obs;

  Curve get curve => _curve.value;
  set curve(Curve newCurve) => _curve.value = newCurve;


  Duration get transitionDuration => _transitionDuration.value;
  set transitionDuration(Duration duration) =>
      _transitionDuration.value = Duration(microseconds: duration.inMicroseconds.clamp(100000, 5000000),);

  Duration get reverseTransitionDuration => _reverseTransitionDuration.value;
  set reverseTransitionDuration(Duration duration) =>
      _reverseTransitionDuration.value = Duration(microseconds: duration.inMicroseconds.clamp(100000, 5000000),);

  // Method to reset to default animation settings.
  void resetToDefault() {
    _curve.value = Curves.ease;
    _transitionDuration.value = Durations.medium4;
    _reverseTransitionDuration.value = Durations.medium1;
  }
}


