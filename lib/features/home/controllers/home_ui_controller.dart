import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';

final HomeUiController homeUiController = Get.put<HomeUiController>(HomeUiController());

class HomeUiController extends GetxController {
  RxInt homeBottomNavBarCurrentIndex = 0.obs;
  Rx<AnimationController?> homeCameraIconAnimController = Rx<AnimationController?>(null);

  @override
  onInit(){
    super.onInit();
    
    homeBottomNavBarCurrentIndex.listen((int value){
      if (value == 1 || value == 3) homeCameraIconAnimController.value?.forward(from: 0);
    });
  }

  @override
  void onClose() {
    homeCameraIconAnimController.value?.dispose();
    super.onClose();
  }

  setHomeBottomNavBarCurrentIndex(int value) => homeBottomNavBarCurrentIndex.value = value;
  sethomeCameraIconAnimController(AnimationController value) => homeCameraIconAnimController.value = value;
}
