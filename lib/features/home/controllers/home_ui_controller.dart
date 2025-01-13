
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/features/home/controllers/chats_tab_ui_controller.dart';

final HomeUiController homeUiController = Get.put<HomeUiController>(HomeUiController());

class HomeUiController extends GetxController {
  Rx<bool> canPop = false.obs;
  RxInt homeBottomNavBarCurrentIndex = 0.obs;
  Rx<AnimationController?> homeCameraIconAnimController = Rx<AnimationController?>(null);
  

  @override
  onInit() async {
    super.onInit();
    homeBottomNavBarCurrentIndex.listen((int value) {
      if (value == 1 || value == 3) {
        homeCameraIconAnimController.value?.forward(from: 0);
      }
      if (value == 0 || value == 2) {
        homeCameraIconAnimController.value?.forward(from: 0);
      }
      if (value != 0) chatsTabUiController.clearSelectedChatTiles();
    });
    
  }

  @override
  void onClose() {
    homeCameraIconAnimController.value?.dispose();
    homeBottomNavBarCurrentIndex.close();
    super.onClose();
  }

  void setHomeBottomNavBarCurrentIndex(int value) => homeBottomNavBarCurrentIndex.value = value;
  void sethomeCameraIconAnimController(AnimationController value) => homeCameraIconAnimController.value = value;
  void setCanPop(bool value) => canPop.value = value;

  
}
