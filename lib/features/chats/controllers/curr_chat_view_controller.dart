import 'package:get/get.dart';

final CurrChatViewController currChatViewController = Get.put<CurrChatViewController>(CurrChatViewController());
class CurrChatViewController extends GetxController{
  RxDouble messageBarHeight = 48.0.obs;
  RxString messageInput = "".obs;

  setMessageBarHeight(double value) => messageBarHeight.value = value;
  setMessageInput(String value) => messageInput.value = value;
}