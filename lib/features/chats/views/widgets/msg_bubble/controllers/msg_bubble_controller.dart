import 'package:get/get.dart';

class MsgBubbleController extends GetxController{
  Rx<double?> textLongestLineWidth = 0.0.obs;

  void setTextLongestLineWidth(double? value) => textLongestLineWidth.value = value;
}