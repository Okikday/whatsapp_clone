import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/common/images_strings.dart';

final HomeUiController homeUiController = Get.put<HomeUiController>(HomeUiController());
class HomeUiController {
  RxInt homeBottomNavBarCurrentIndex = 0.obs;

  setHomeBottomNavBarCurrentIndex(int value) => homeBottomNavBarCurrentIndex.value = value;
}

