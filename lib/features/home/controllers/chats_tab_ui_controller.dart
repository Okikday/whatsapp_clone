import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

final ChatsTabUiController chatsTabUiController = Get.put<ChatsTabUiController>(ChatsTabUiController());

const double revealThreshold = 24.0; // Height needed to fully reveal filters view
const double filterTileHeight = 36;

class ChatsTabUiController extends GetxController{
  RxMap<int, int?> chatTilesSelected = <int, int?>{}.obs;
  RxBool allowPagePush = true.obs;
  
  final Rx<Offset> animationOffset = Offset.zero.obs;
  RxDouble overscrollOffset = 0.0.obs;

  setOverscrollOffset(double value) => overscrollOffset.value = value;
  onChatListsNotification(Notification notification) {
    if (notification is OverscrollNotification) {
      final double overScroll = notification.overscroll;
      if(overScroll < 0.0){
        overscrollOffset.value += overScroll.abs();
      if (overscrollOffset.value < 0) overscrollOffset.value = 0.0;
      if (overscrollOffset.value > revealThreshold) overscrollOffset.value = filterTileHeight;
      }
    } else if (notification is ScrollEndNotification) {
      if (overscrollOffset.value < revealThreshold) {
        overscrollOffset.value = 0.0;
      }
    }
    return true;
  }
  
  
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
  void setAllowPagePush(bool value)=> allowPagePush.value = value;

  void startAnimation(Offset tapGlobalPosition) {
    
  }
}