import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/widgets/custom_elevated_button.dart';
import 'package:whatsapp_clone/features/chats/controllers/chat_view_controller.dart';
import 'package:whatsapp_clone/features/chats/controllers/chats_ui_controller.dart';
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
    return SizedBox(
      height: height,
      width: width,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        
        
        child: DecoratedBox(
          decoration: BoxDecoration(
      
            color: isDarkMode ? Colors.black.withAlpha(242) : WhatsAppColors.seaShell,
            image: DecorationImage(
                image: const AssetImage(
                  ImagesStrings.chatBackground,
                ),
                repeat: ImageRepeat.repeat,
                alignment: Alignment.topLeft,
                scale: 1.3,
                filterQuality: FilterQuality.high,
                colorFilter: ColorFilter.mode(isDarkMode ? WhatsAppColors.darkGray : WhatsAppColors.linen, BlendMode.srcIn),
                fit: BoxFit.none)
      
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.only(top: 12,),
                    itemCount: messageModel.length,
                    itemBuilder: (context, index) {
                      final MessageModel currMsgModel = messageModel[index];
                      return MsgBubble.receiver(messageModel: currMsgModel, isFirstMsg: true,);
                    }),
              ),
          
              Obx(() {
                final double keyboardHeight = appUiState.viewInsets.value.bottom;
                return SizedBox(height: currChatViewController.messageBarHeight.value + (keyboardHeight < 40 ? 0 : keyboardHeight) + 8,);
              })
            ],
          ),
        ),
      ),
    );
  }
}

