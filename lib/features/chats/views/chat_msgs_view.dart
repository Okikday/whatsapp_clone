import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/widgets/custom_elevated_button.dart';
import 'package:whatsapp_clone/features/chats/use_cases/models/message_model.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/msg_bubble.dart';
import 'dart:math' as math;

class ChatMsgsView extends StatelessWidget {
  final bool isDarkMode;
  final List<MessageModel> messageModel;
  const ChatMsgsView({super.key, required this.isDarkMode, required this.messageModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      decoration: BoxDecoration(
          color: isDarkMode ? Colors.black.withAlpha(242) : WhatsAppColors.seaShell,
          image: DecorationImage(
              opacity: 0.8,
              image: const AssetImage(
                ImagesStrings.chatBackground,
              ),
              colorFilter: ColorFilter.mode(isDarkMode ? WhatsAppColors.gray : WhatsAppColors.linen, BlendMode.srcIn),
              fit: BoxFit.cover)),
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: messageModel.length,
          itemBuilder: (context, index) {
            final MessageModel currMsgModel = messageModel[index];
            return MsgBubble.receiver(messageModel: currMsgModel,);
          }),
    );
  }
}

