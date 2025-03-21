import 'dart:developer';

import 'package:get/get.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';
import 'package:whatsapp_clone/data/app_data.dart';
import 'package:whatsapp_clone/features/chats/use_cases/chat_data_functions/chat_data_functions.dart';

class SelectContactController extends GetxController {
  RxString searchContactText = "".obs;
  RxBool isSearching = false.obs;
  Rx<ChatModel?> searchedChatModel = Rx(null);

  @override
  void onInit() {
    super.onInit();
    searchContactText.value = "";
  }

  setSearchContactText(String value) {
    // log("input: $value");
    return searchContactText.value = value;
  }


  /// Formats a phone number to the international format for Nigeria (+234)
  /// after removing any whitespace. Returns the formatted number or null if invalid.
  Future<void> searchContactOnWhatsApp() async {
    if (isSearching.value) return;

    // Reset previous search result.
    searchedChatModel.value = null;
    isSearching.value = true;

    // Remove whitespace and trim the input.
    final text = _HelperSelectContactController.removeWhitespace(searchContactText.value);

    // Validate the phone number and its length.
    if (!text.isPhoneNumber || text.length < 10 || text.length > 15) {
      isSearching.value = false;
      return;
    }

    // Check if chat exists on device first.
    final ChatModel? checkNumberOnDevice = await AppData.chats.getChatByNumber(text);
    if (checkNumberOnDevice != null) {
      isSearching.value = false;
      return;
    }

    // Normalize the phone number to start with +234 and search on WhatsApp.
    if (text.startsWith('+234')) {
      searchedChatModel.value = await _HelperSelectContactController.getNumberOnWhatsApp(text);
    } else if (text.startsWith('234')) {
      searchedChatModel.value = await _HelperSelectContactController.getNumberOnWhatsApp('+234${text.substring(3)}');
    } else if (text.startsWith('0')) {
      searchedChatModel.value = await _HelperSelectContactController.getNumberOnWhatsApp('+234${text.substring(1)}');
    }
    isSearching.value = false;
  }

}


class _HelperSelectContactController{
  /// Removes all whitespace characters from the input string.
  static String removeWhitespace(String input) => input.replaceAll(RegExp(r'\s+'), '');

  static Future<ChatModel?> getNumberOnWhatsApp(String text) async{
    final Result<ChatModel> chatModelRaw = await ChatFirebaseDataFunctions.getNumberOnWhatsApp(text);
    if(chatModelRaw.isSuccess) return chatModelRaw.value;
    return null;
  }
}