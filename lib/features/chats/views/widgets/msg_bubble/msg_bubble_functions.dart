
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:simple_animations/animation_builder/custom_animation_builder.dart';
import 'package:whatsapp_clone/features/chats/use_cases/models/message_model.dart';

class MsgBubbleFunctions {
  static void onTapDownMsgBubble() {
    // OnTapDownMsgBubble
    log("Tapped down on message bubble");
  }

  static void onTapUpMsgBubble(
  ) {
    log("Tapped up on message bubble");
  }

  static Icon getMsgStatusIcon(MsgStatus status, {double? size}) {
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
      color: Colors.white70,
    );
  }
}
