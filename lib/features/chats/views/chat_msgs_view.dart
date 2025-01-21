
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/features/chats/controllers/chat_view_controller.dart';
import 'package:whatsapp_clone/features/chats/use_cases/models/message_model.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/msg_bubble/msg_bubble.dart';

class ChatMsgsView extends StatelessWidget {
  final bool isDarkMode;
  final List<MessageModel> messageModel;
  final double width;
  final double height;
  const ChatMsgsView({super.key, required this.isDarkMode, required this.messageModel, required this.width, required this.height,});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: width,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: ListView.builder(
                    padding: const EdgeInsets.only(top: 12,),
                    itemCount: messageModel.length,
                    itemBuilder: (context, index) {
                      final MessageModel currMsgModel = messageModel[index];
                      return MsgBubble.sender(messageModel: currMsgModel, isFirstMsg: true,);
                    }),
        ),
      ),
    );
  }
}

