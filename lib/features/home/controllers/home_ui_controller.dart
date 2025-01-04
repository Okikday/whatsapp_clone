import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/common/app_constants.dart';
import 'package:whatsapp_clone/features/home/views/home_view.dart';
import 'package:whatsapp_clone/features/home/views/tab_views/chats_tab_view.dart';

final HomeUiController homeUiController = Get.put<HomeUiController>(HomeUiController());

class HomeUiController extends GetxController {
  Rx<bool> isDarkMode = true.obs;
  Rx<bool> canPop = false.obs;
  RxInt homeBottomNavBarCurrentIndex = 0.obs;
  Rx<AnimationController?> homeCameraIconAnimController = Rx<AnimationController?>(null);
  Rx<PreferredSize> currHomeAppBar = const PreferredSize(preferredSize: Size.zero, child: SizedBox()).obs;
  RxMap<int, int?> chatTilesSelected = <int, int?>{}.obs;
  Rx<BuildContext?> homeContext = Rx<BuildContext?>(null);
  RxList<Effect> homeCamIconAnimCtrlEffects = AppConstants.homeCamAnimforwardEffect.obs;

  @override
  onInit() async {
    super.onInit();
    homeBottomNavBarCurrentIndex.listen((int value) { 
      if (value == 1 || value == 3) {
        homeCamIconAnimCtrlEffects.value = AppConstants.homeCamAnimforwardEffect;
        homeCameraIconAnimController.value?.forward(from: 0);
      }
      if(value == 0 || value == 2){
        homeCamIconAnimCtrlEffects.value = AppConstants.homeCamAnimBackwardEffect;
        homeCameraIconAnimController.value?.forward(from: 0);
      }
      if (value != 0) clearSelectedChatTiles();
    });
    chatTilesSelected.listen((Map<int, int?> value) {
      if (value.isNotEmpty) {
        setChatSelectionAppBar(context: homeContext.value);
      } else {
        updateHomeAppBar(context: homeContext.value);
      }
    });
  }

  @override
  void onClose() {
    homeCameraIconAnimController.value?.dispose();
    super.onClose();
  }

  void _setCurrHomeAppBar(PreferredSize widget) => currHomeAppBar.value = widget;
  void setIsDarkMode(bool value) => isDarkMode.value = value;
  void setHomeBottomNavBarCurrentIndex(int value) => homeBottomNavBarCurrentIndex.value = value;
  void sethomeCameraIconAnimController(AnimationController value) => homeCameraIconAnimController.value = value;
  void setCanPop(bool value) => canPop.value = value;
  void updateHomeContext(BuildContext context) => homeContext.value = context;
  void setHomecamIconAnimCtrlEffects(List<Effect> effects) => homeCamIconAnimCtrlEffects.value = effects;

  // setChatTilesCount(int index) => chatTilesSelected = List.fi
  void selectChatTile(int index) => chatTilesSelected[index] = index;
  void removeSelectedChatTile(int index) => chatTilesSelected[index] != null ? chatTilesSelected.remove(index) : () {};
  void clearSelectedChatTiles() => chatTilesSelected.clear();

  setChatSelectionAppBar({BuildContext? context}){
    _setCurrHomeAppBar(customAppBar(
      homeContext.value ?? Get.context!, 
            scaffoldBgColor: Theme.of(context ?? Get.context!).scaffoldBackgroundColor,
            padding: EdgeInsets.only(left: Get.width > Get.height ? Get.width * 0.05 : 8, right: Get.width > Get.height ? Get.width * 0.05 : 0),
            child: const ChatSelectionAppBarChild()));
  }

  void updateHomeAppBar({BuildContext? context}) {
    if (chatTilesSelected.isEmpty) {
      _setCurrHomeAppBar(customAppBar(homeContext.value ?? Get.context!, scaffoldBgColor: Theme.of(context ?? Get.context!).scaffoldBackgroundColor, child: const NormalAppBarChild()));
    }
    if(chatTilesSelected.isNotEmpty){
      setChatSelectionAppBar(context: homeContext.value);
    }
  }
}
