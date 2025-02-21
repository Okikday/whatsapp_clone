import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/data/app_data.dart';
import 'package:whatsapp_clone/data/user_data/user_data.dart';
import 'package:whatsapp_clone/models/chat_model.dart';

class ChatViewController extends GetxController {
  final Rx<ChatModel> _chatModel;
  final RxString _myUserId;
  ChatViewController(ChatModel chatModel, String myUserId): _chatModel = chatModel.obs, _myUserId = myUserId.obs;

  final TextEditingController textEditingController = TextEditingController();
  RxString messageInput = "".obs;
  RxDouble messageBarHeight = 48.0.obs;
  RxBool isMicTappedDown = false.obs;
  RxBool allowPagePop = true.obs;
  RxMap<int, int?> chatsSelected = <int, int?>{}.obs;

  @override
  void onInit() async{
    super.onInit();
    setMessageInput('');
    chatsSelected.listen((Map<int, int?> value) {
      log("Selected chat: ${value.length}");
    });
  }

  @override
  void onClose() {
    chatsSelected.close();
    super.onClose();
  }

  ChatModel get chatModel => _chatModel.value;

  void resetValues() {
    setMessageInput('');
    // setIsChatViewActive(false);
    clearSelectedChatBubble();
  }

  void setMessageInput(String value) => messageInput.value = value;
  void setIsMicTappedDown(bool value) => isMicTappedDown.value = value;
  void selectChatBubble(int index) {
    chatsSelected[index] = index;
    if (allowPagePop.value != false) {
      setAllowPagePop(false);
    }
  }

  void removeSelectedChatBubble(int index) {
    chatsSelected[index] != null ? chatsSelected.remove(index) : () {};
    if (chatsSelected.isEmpty) {
      setAllowPagePop(true);
    }
  }

  void clearSelectedChatBubble() {
    chatsSelected.clear();
    if (chatsSelected.isEmpty && allowPagePop.value != true) {
      setAllowPagePop(true);
    }
  }

  void setAllowPagePop(bool value) => allowPagePop.value = value;
  void checkMessageBarHeight(int numberOfLines, {double lineHeight = 18.0 * 1.2, int maxNumOfLines = 7}) {
    const double minHeight = 48.0;
    final double maxHeight = lineHeight * maxNumOfLines;
    final double adjustedHeight = numberOfLines == 1
        ? (minHeight + (numberOfLines - 1) * lineHeight).clamp(minHeight, maxHeight)
        : ((numberOfLines - 1).round() * lineHeight + 32).clamp(minHeight, maxHeight);

    if (adjustedHeight != messageBarHeight.value) messageBarHeight.value = adjustedHeight;
  }

  void resetMsgBarHeight() => messageBarHeight.value = 48.0;
}
