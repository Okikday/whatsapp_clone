import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/utilities/utilities_funcs.dart';
import 'package:whatsapp_clone/models/message_model.dart';

class MsgBubbleUseCases {
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
