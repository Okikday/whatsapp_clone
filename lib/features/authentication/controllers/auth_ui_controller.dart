import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/common/colors.dart';

final AuthUiController authUiController = Get.put<AuthUiController>(AuthUiController());
class AuthUiController extends GetxController{
  Rx<Color> systemNavBarColor = WhatsAppColors.background.obs;

  setSystemNavBarColor(Color value) => systemNavBarColor.value = value;
  
}