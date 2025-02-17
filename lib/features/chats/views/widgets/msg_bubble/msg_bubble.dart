import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:whatsapp_clone/app/controllers/app_layout_settings.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/features/chats/controllers/chat_view_controller.dart';
import 'package:whatsapp_clone/models/message_model.dart';
import 'package:whatsapp_clone/features/chats/use_cases/functions/msg_bubble_functions.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/msg_bubble/custom_bubble.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/msg_bubble/msg_bubble_content.dart';



class MsgBubble extends StatelessWidget {
  final ChatViewController chatViewController;
  final MessageModel messageModel;
  final bool isFirstMsg; // Whether this is the first message in a group
  final Color? bgColor;
  final Color? taggedMsgColor;
  final bool isSender; // Whether the message is from the sender
  final int index;

  const MsgBubble({
    super.key,
    required this.messageModel,
    this.isFirstMsg = false,
    this.bgColor,
    this.taggedMsgColor,
    required this.isSender,
    required this.index, 
    required this.chatViewController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final int? selectedIndex = chatViewController.chatsSelected[index];
        final msgBubbleFunctions = MsgBubbleFunctions(chatViewController);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.5),
          child: SizedBox(
            width: appUiState.deviceWidth.value,
            child: Material(
              color: selectedIndex != null ? Theme.of(context).primaryColor.withAlpha(50) : Colors.transparent,
              surfaceTintColor: selectedIndex != null ? Colors.white : Colors.transparent,
              child: InkWell(
                overlayColor: WidgetStatePropertyAll(Theme.of(context).primaryColor.withAlpha(40)),
                onTap: () {
                  msgBubbleFunctions.onTapBubble(index);
                },
                onLongPress: () {
                  msgBubbleFunctions.onLongPress(index);
                },
                child: AnimatedAlign(
                  duration: Durations.medium3,
                  alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                  child: Obx(
                    () {
                      const double nipWidth = 8.0;
                      // final double height = appUiState.deviceHeight.value;
                      final bool isDarkMode = appUiState.isDarkMode.value;
                      final double leftMargin = isSender ? 0 : 8; // For custom lower res bubble
                      final double rightMargin = isSender ? 8 : 0; // For custom lower res bubble
                      final bool hasMedia = messageModel.mediaUrl != null && messageModel.mediaUrl!.isNotEmpty;
                      final double maxWidth = hasMedia ? (appUiState.deviceWidth.value * 0.7) : appUiState.deviceWidth.value * 0.85;

                      final Color bubbleBgColor = bgColor ?? (isDarkMode
                          ? (isSender ? WhatsAppColors.msgSentDark : WhatsAppColors.msgReceivedDark)
                          : (isSender ? WhatsAppColors.msgSent : WhatsAppColors.msgReceived));
                      final Color taggedMsgColor = isDarkMode
                          ? (isSender ? WhatsAppColors.taggedMsgSentDark : WhatsAppColors.taggedMsgReceivedDark)
                          : (isSender ? WhatsAppColors.taggedMsgSent : WhatsAppColors.taggedMsgReceived);

                      // TODO: make maxWidth 270
                      return Animate(
                        effects: [
                          FadeEffect(
                            begin: selectedIndex != null ? 0.8 : 1.0,
                            end: selectedIndex != null ? 0.8 : 1.0,
                          )
                        ],

                        child: appLayoutSettings.useLowResChatBubble
                            ? LowerResCustomBubble(
                                showNip: isFirstMsg,
                                isNipLeftNotRight: !isSender,
                                isDarkMode: isDarkMode,
                                borderRadius: 10,
                                maxWidth: maxWidth,
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                margin: EdgeInsets.only(left: leftMargin, right: rightMargin, top: isFirstMsg ? 4 : 2, bottom: isFirstMsg ? 4 : 2),
                                bgColor: selectedIndex != null ? bubbleBgColor : bubbleBgColor,
                                child: MsgBubbleContent(
                                  chatViewController: chatViewController,
                                  messageModel: messageModel,
                                  hasMedia: hasMedia,
                                  isSender: isSender,
                                  messageId: messageModel.messageId,
                                  taggedMsgColor: taggedMsgColor,
                                  index: index,
                                ))
                            : CustomBubble(
                                nipHeight: 12,
                                nipWidth: 10,
                                nipRadius: 2,
                                nip: isFirstMsg ? (isSender ? BubbleNip.rightTop : BubbleNip.leftTop) : BubbleNip.none,
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                maxWidth: isFirstMsg ? maxWidth : maxWidth - 8,
                                margin: EdgeInsets.only(
                                    left: isFirstMsg ? (isSender ? 0 : 10) : (isSender ? 0 : (10 + 10 - 2)),
                                    right: isFirstMsg ? (isSender ? 10 : 0) : (isSender ? (10 + 10 - 2) : 0),
                                    top: isFirstMsg ? 4 : 2,
                                    bottom: isFirstMsg ? 4 : 2),
                                radius: const Radius.circular(10),
                                color: selectedIndex != null ? bubbleBgColor : bubbleBgColor,
                                shadowColor: isDarkMode ? Colors.white10 : Colors.black12,
                                elevation: 1,
                                child: MsgBubbleContent(
                                  chatViewController: chatViewController,
                                  messageModel: messageModel,
                                  hasMedia: hasMedia,
                                  isSender: isSender,
                                  messageId: messageModel.messageId,
                                  taggedMsgColor: taggedMsgColor,
                                  index: index,
                                )),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
