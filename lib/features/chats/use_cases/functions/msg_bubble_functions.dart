import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/utilities/utilities_funcs.dart';
import 'package:whatsapp_clone/features/chats/controllers/chat_view_controller.dart';
import 'package:whatsapp_clone/features/chats/use_cases/models/message_model.dart';

class MsgBubbleFunctions {
  static void onLongPress(int index) {
    final Map<int, int?> chatsBubbleSelected = chatViewController.chatsSelected;

    if (chatsBubbleSelected[index] != null) {
      chatViewController.removeSelectedChatBubble(index);
    } else {
      chatViewController.selectChatBubble(index);
    }
  }

  static void onTapBubble(int index) {
    final Map<int, int?> chatsBubbleSelected = chatViewController.chatsSelected;
    if (chatsBubbleSelected.isEmpty) {
      
    } else {
      if (chatsBubbleSelected[index] != null) {
        chatViewController.removeSelectedChatBubble(index);
      } else {
        chatViewController.selectChatBubble(index);
      }
    }
  }

  static void onTapTaggedMsg(int index) {
    // What to do
  }

  static double calcSentAtWidth(String dateText, bool isSender, TextStyle sentAtStyle, {double iconSize = 16.0}) {
    final double textWidth = UtilitiesFuncs.getTextSize(dateText, sentAtStyle).width;
    return isSender ? textWidth + iconSize + 2 : textWidth;
  }

  static Icon getMsgStatusIcon(MsgStatus status, {double? size, Color? iconColor}) {
    final IconData icon = status == MsgStatus.read
        ? Icons.done_all
        : status == MsgStatus.delivered
            ? Icons.done_all
            : status == MsgStatus.offline
                ? Icons.done
                : status == MsgStatus.loading
                    ? Icons.schedule
                    : Icons.access_time;

    return Icon(
      icon,
      size: size,
      color: iconColor,
    );
  }
}
