import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/utilities/utilities_funcs.dart';
import 'package:whatsapp_clone/features/chats/use_cases/models/message_model.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/msg_bubble/msg_bubble_functions.dart';

class MsgBubbleContentFunctions {
  double calcSentAtWidth(String dateText, bool isSender, TextStyle sentAtStyle, {double iconSize = 16.0}){
      final double textWidth = UtilitiesFuncs.getTextSize(dateText, sentAtStyle).width;
      return isSender ? textWidth + iconSize + 2 : textWidth;
    }
}
