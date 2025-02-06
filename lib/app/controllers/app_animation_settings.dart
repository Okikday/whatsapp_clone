// file: app_animation_settings.dart (controller)
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


final appAnimationSettingsController = Get.put(AppAnimationSettings());



class AppAnimationSettings extends GetxController {
  final Rx<Curve> _curve = CustomCurves.defaultIos.obs;
  final RxInt _transitionDuration = 1000.obs;
  final RxInt _reverseTransitionDuration = 250.obs;

  Curve get curve => _curve.value;
  set curve(Curve newCurve) => _curve.value = newCurve;

  int get transitionDuration => _transitionDuration.value;
  set transitionDuration(int duration) =>
      _transitionDuration.value = duration.clamp(100, 5000);

  int get reverseTransitionDuration => _reverseTransitionDuration.value;
  set reverseTransitionDuration(int duration) =>
      _reverseTransitionDuration.value = duration.clamp(100, 5000);

  // Method to reset to default animation settings.
  void resetToDefault() {
    _curve.value = CustomCurves.defaultIos;
    _transitionDuration.value = 1000;
    _reverseTransitionDuration.value = 250;
  }
}


