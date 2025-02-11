import 'package:get/get.dart';

final AppLayoutSettings appLayoutSettings = Get.put(AppLayoutSettings());

class AppLayoutSettings extends GetxController{
  final RxBool _useLowResChatBubble = true.obs;

  set useLowResChatBubble(bool value) => _useLowResChatBubble.value = value;
  bool get useLowResChatBubble => _useLowResChatBubble.value;

}