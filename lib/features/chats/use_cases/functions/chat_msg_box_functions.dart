import 'dart:developer';

import 'package:whatsapp_clone/data/app_data.dart';
import 'package:whatsapp_clone/features/chats/controllers/chat_view_controller.dart';


class ChatMsgBoxFunctions{
  final ChatViewController _chatViewController;
  ChatMsgBoxFunctions(ChatViewController chatViewController): _chatViewController = chatViewController;

  Future<void> addChatModelIfNotExist({required bool nameAsPhoneNumber}) async{
    final ChatModel? getChat = await AppData.chats.getChatById(_chatViewController.chatModel.chatId);

    if(getChat == null){
      await AppData.chats.addChat(_chatViewController.chatModel.copyWith(chatName: _chatViewController.chatModel.contactId));
      return;
    }else{
      return;
    }
  }

  sendMessage() async{
    final String content = _chatViewController.messageInput.value;
    _chatViewController.resetMsgBox();
    await _chatViewController.chatServices.sendMessage(content: content, messageType: MessageType.text);
  }

}