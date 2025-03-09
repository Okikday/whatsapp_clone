import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/data/app_data.dart';


final ChatsTabUiController chatsTabUiController = Get.put<ChatsTabUiController>(ChatsTabUiController());

const double revealThreshold = 24.0; // Height needed to fully reveal filters view
const double filterTileHeight = 36;

class ChatsTabUiController extends GetxController{
  RxMap<int, String?> chatTilesSelected = <int, String?>{}.obs;
  RxBool allowPagePush = true.obs;
  final Rx<Offset> animationOffset = Offset.zero.obs;
  RxDouble overscrollOffset = 0.0.obs;

  Rx<Stream<List<ChatModel>>> tabChatsListStream = AppData.chats.watchAllChats().obs;

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


  // @override
  // onInit(){
  //   super.onInit();
  //
  //   // chatTilesSelected.listen((Map<int, String?> value) {
  //   //   log("Selected chat tile: ${value.length}");
  //   // });
  // }

  @override
  onClose(){
    chatTilesSelected.close();
    tabChatsListStream.close();
    super.onClose();
  }



  // setChatTilesCount(int index) => chatTilesSelected = List.fi
  void selectChatTile(int index, {required String? chatId}) => chatTilesSelected[index] = chatId;
  void removeSelectedChatTile(int index) => chatTilesSelected[index] != null ? chatTilesSelected.remove(index) : () {};
  void clearSelectedChatTiles() => chatTilesSelected.clear();
  void setAllowPagePush(bool value) => allowPagePush.value = value;

}