import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

final ChatsTabUiController chatsTabUiController = Get.put<ChatsTabUiController>(ChatsTabUiController());

class ChatsTabUiController extends GetxController{
  RxMap<int, int?> chatTilesSelected = <int, int?>{}.obs;
  RxBool isChatViewActive = false.obs;
  final Rx<Offset> animationOffset = Offset.zero.obs;
  
  
  
  @override
  onInit(){
    super.onInit();
    chatTilesSelected.listen((Map<int, int?> value) {
      log("Selected chat tile: ${value.length}");
    });
  }

  @override
  onClose(){
    chatTilesSelected.close();
    super.onClose();
  }
  
  // setChatTilesCount(int index) => chatTilesSelected = List.fi
  void selectChatTile(int index) => chatTilesSelected[index] = index;
  void removeSelectedChatTile(int index) => chatTilesSelected[index] != null ? chatTilesSelected.remove(index) : () {};
  void clearSelectedChatTiles() => chatTilesSelected.clear();
  void setIsChatViewActive(bool value) => isChatViewActive.value = value;

  void startAnimation(Offset tapGlobalPosition) {
    
  }
}