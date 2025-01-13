
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const double revealThreshold = 24.0; // Height needed to fully reveal filters view
const double filterTileHeight = 36;

final ChatsUiController chatUiController = Get.put<ChatsUiController>(ChatsUiController());
class ChatsUiController extends GetxController {
  RxDouble overscrollOffset = 0.0.obs;

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

}
