import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

final AppUiState appUiState = Get.put<AppUiState>(AppUiState());

class AppUiState extends GetxController with WidgetsBindingObserver {
  final RxBool isDarkMode = false.obs;
  final RxDouble deviceHeight = 0.0.obs;
  final RxDouble deviceWidth = 0.0.obs;
  final Rx<EdgeInsets> viewInsets = EdgeInsets.zero.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    final context = Get.context;
    if (context != null) updateState(context);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeMetrics() {
    final FlutterView? instanceImplicitView = WidgetsBinding.instance.platformDispatcher.implicitView;
    final Size? size = instanceImplicitView?.physicalSize;
    final ViewPadding? systemViewInsets = instanceImplicitView?.viewInsets;
    final double? devicePixelRatioTemp = instanceImplicitView?.devicePixelRatio;
    if (systemViewInsets != null) viewInsets.value = EdgeInsets.fromViewPadding(systemViewInsets, devicePixelRatioTemp ?? 1.0);
    if (size != null && devicePixelRatioTemp != null) {
      final double logicalWidth = size.width / devicePixelRatioTemp;
      final double logicalHeight = size.height / devicePixelRatioTemp;
      if (deviceWidth.value != logicalWidth) deviceWidth.value = logicalWidth;
      if (deviceHeight.value != logicalHeight) deviceHeight.value = logicalHeight;
    }
  }

  @override
  void didChangePlatformBrightness() {
    final bool isDarkModeTemp = WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    if (isDarkModeTemp != isDarkMode.value) isDarkMode.value = isDarkModeTemp;
    log("width: Changed brightness");
  }

  void updateState(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final EdgeInsets viewInsetsTemp = MediaQuery.of(context).viewInsets;
    final bool isDarkModeTemp = Theme.of(context).brightness == Brightness.dark;

    if (viewInsets.value != viewInsetsTemp) viewInsets.value = viewInsetsTemp;
    if (isDarkModeTemp != isDarkMode.value) isDarkMode.value = isDarkModeTemp;
    if (size.width != deviceWidth.value || size.height != deviceHeight.value) {
      deviceWidth.value = size.width;
      deviceHeight.value = size.height;
    }
  }
}
