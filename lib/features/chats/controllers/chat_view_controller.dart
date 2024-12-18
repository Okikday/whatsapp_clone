import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';

final ChatViewController currChatViewController = Get.put<ChatViewController>(ChatViewController());

class ChatViewController extends GetxController {
  RxString messageInput = "".obs;

  RxDouble messageBarHeight = 48.0.obs;
  RxBool isMicTappedDown = false.obs;

  @override
  onInit(){
    super.onInit();
    precacheImage(const ExactAssetImage(SvgStrings.msgBubbleCornerLeft, ), Get.context!);
    precacheImage(const ExactAssetImage(SvgStrings.msgBubbleCornerRight, ), Get.context!);
  }

  setMessageInput(String value) => messageInput.value = value;
  setIsMicTappedDown(bool value) => isMicTappedDown.value = value;

  void checkMessageBarHeight(int numberOfLines, {double fontSize = 18.0, double lineSpacing = 4.0, double padding = 0.0}) {
    const double minHeight = 48.0;
    const double maxHeight = 140.0;
    final double lineHeight = fontSize + lineSpacing;
    double targetHeight = numberOfLines * lineHeight + padding;
    messageBarHeight.value = targetHeight.clamp(minHeight, maxHeight);
  }
}
