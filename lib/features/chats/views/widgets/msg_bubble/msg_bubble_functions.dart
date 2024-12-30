import 'package:flutter/material.dart';
import 'package:simple_animations/animation_builder/custom_animation_builder.dart';
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
      size: 12,
      color: Colors.white70,
    );
  }

}
