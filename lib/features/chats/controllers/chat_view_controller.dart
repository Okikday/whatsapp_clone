import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:whatsapp_clone/features/home/controllers/chats_tab_ui_controller.dart';

final ChatViewController chatViewController = Get.put(ChatViewController());

class ChatViewController extends GetxController {
  RxString messageInput = "".obs;
  RxDouble messageBarHeight = 48.0.obs;
  RxBool isMicTappedDown = false.obs;
  RxBool allowPagePop = true.obs;
  RxMap<int, int?> chatsSelected = <int, int?>{}.obs;

  @override
  void onInit() {
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

  void resetValues() {
    chatViewController.setMessageInput('');
    // setIsChatViewActive(false);
    chatViewController.clearSelectedChatBubble();
  }

  void setMessageInput(String value) => messageInput.value = value;
  void setIsMicTappedDown(bool value) => isMicTappedDown.value = value;
  void selectChatBubble(int index) {
    chatsSelected[index] = index;
    if(allowPagePop.value != false){
      setAllowPagePop(false);
    }
  }
  void removeSelectedChatBubble(int index) {
    chatsSelected[index] != null ? chatsSelected.remove(index) : () {};
    if(chatsSelected.isEmpty){
      setAllowPagePop(true);
    }
  }
  void clearSelectedChatBubble() {
    chatsSelected.clear();
    if(chatsSelected.isEmpty && allowPagePop.value != true){
      setAllowPagePop(true);
    }
  }
  void setAllowPagePop(bool value) => allowPagePop.value = value;
  double checkMessageBarHeight(int numberOfLines, {double fontSize = 18.0, double lineSpacing = 4.0}) {
    const double minHeight = 48.0;
    const double maxHeight = 140.0;

    // Calculate height for the given number of lines
    final double lineHeight = fontSize + lineSpacing;
    double targetHeight = minHeight + (numberOfLines - 1) * lineHeight;

    // Clamp the result between minHeight and maxHeight
    double adjustedHeight = targetHeight.clamp(minHeight, maxHeight);

    // Update the value of messageBarHeight (assumed to be a reactive variable like ValueNotifier)
    messageBarHeight.value = adjustedHeight;
    log("adjustHeight: $adjustedHeight");

    return adjustedHeight;
  }

  void setMessageBarHeight(double value) {
    const double minHeight = 48.0;
    const double maxHeight = 140.0;
    messageBarHeight.value = value.clamp(minHeight, maxHeight);
  }
}
