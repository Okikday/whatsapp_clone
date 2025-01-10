import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:simple_animations/animation_builder/custom_animation_builder.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';
import 'package:whatsapp_clone/common/utilities/utilities_funcs.dart';
import 'package:whatsapp_clone/features/chats/use_cases/models/message_model.dart';

class MsgBubbleFunctions {
  static void onTapDownMsgBubble(ValueNotifier<Color> splashColor, ValueNotifier<Control> animControl, {Color? color}) {
    splashColor.value = color ?? Colors.white.withAlpha(40);
    animControl.value = Control.playFromStart;
  }

  static void onTapUpMsgBubble(
    ValueNotifier<Color> splashColor,
    ValueNotifier<Control> animControl,
  ) {
    Future.delayed(const Duration(milliseconds: 150), () {
      splashColor.value = Colors.transparent;
      animControl.value = Control.playFromStart;
    });
  }

  static Icon getMsgStatusIcon(MsgStatus status) {
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
      size: 16,
      color: Colors.white70,
    );
  }

  static bool doesTextHasSpaceLeft(
    BuildContext context, {
    required bool hasMedia,
    required String content,
    required String? mediaCaption,
    required bool hasMediaCaption,
    required double msgBubbleWidth,
    required TextStyle textStyle,
    double neededSpace = 46.0,
    double horizontalTextPadding = 6.0,
  }) {

    double totalTextWidth = UtilitiesFuncs.getTextSize(
            hasMedia && hasMediaCaption ? mediaCaption! : content, textStyle)
        .width;
    if(hasMedia && hasMediaCaption){
      if(UtilitiesFuncs.getTextSize(mediaCaption!, textStyle).width + neededSpace < msgBubbleWidth) totalTextWidth =  msgBubbleWidth - neededSpace;
    }

    if (totalTextWidth + neededSpace < msgBubbleWidth) return false;
    
    bool doesTextHasSpaceLeft = (msgBubbleWidth - horizontalTextPadding * 2) - (totalTextWidth % (msgBubbleWidth - horizontalTextPadding * 2)) >= neededSpace;
    
    
    return doesTextHasSpaceLeft;
  }
}
