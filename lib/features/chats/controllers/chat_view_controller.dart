import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';

final ChatViewController currChatViewController = Get.put<ChatViewController>(ChatViewController());

class ChatViewController extends GetxController {
  RxString messageInput = "".obs;

  RxDouble messageBarHeight = 48.0.obs;
  RxBool isMicTappedDown = false.obs;
  RxDouble cacheKeyboardHeight = 0.0.obs;
  Timer? debounceTimer;

  setMessageInput(String value) => messageInput.value = value;
  setIsMicTappedDown(bool value) => isMicTappedDown.value = value;
  
  



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

  void setMessageBarHeight(double value){
    const double minHeight = 48.0;
    const double maxHeight = 140.0;
    messageBarHeight.value = value.clamp(minHeight, maxHeight);
  }
}
