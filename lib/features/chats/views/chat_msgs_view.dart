
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/features/chats/use_cases/models/message_model.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/msg_bubble/msg_bubble.dart';
import 'package:whatsapp_clone/test_data_folder/test_data/test_chats_data.dart';

class ChatMsgsView extends StatelessWidget {
  final bool isDarkMode;
  final List<MessageModel> messageModels;
  final double width;
  final double height;
  const ChatMsgsView({super.key, required this.isDarkMode, required this.messageModels, required this.width, required this.height,});

  @override
  Widget build(BuildContext context) {
    final List<MessageModel> mockMessageModels = [
      messageModels.first,
      MessageModel.fromMap({...messageModels.first.toMap(), 'messageId': "dup_${messageModels.first.messageId}"})
    ];
    return Expanded(
      child: SizedBox(
        width: width,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: ListView.builder(
                    padding: const EdgeInsets.only(top: 12,),
                    itemCount: mockMessageModels.length,
                    itemBuilder: (context, index) {
                      final MessageModel currMsgModel = mockMessageModels[index];
                      
                      return index == 0 ? 
                       MsgBubble.receiver(messageModel: currMsgModel, isFirstMsg: true,) : MsgBubble.sender(messageModel: currMsgModel, isFirstMsg: true,);
                    }),
        ),
      ),
    );
  }
}

