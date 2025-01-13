import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/features/chats/use_cases/models/message_model.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/msg_bubble/msg_bubble_functions.dart';

class MsgBubbleContentFunctions {
  static Widget buildDateWidget(
    BuildContext context,
    String date,
    bool isSender, {
    required DateTime? seenAt,
    required DateTime? deliveredAt,
  }) {
    final CustomText dateText = CustomWidgets.text(
      context,
      date,
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: Colors.white70,
    );
    return isSender
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 2,
            children: [
              dateText,
              if (isSender)
                MsgBubbleFunctions.getMsgStatusIcon(seenAt != null
                    ? MsgStatus.read
                    : deliveredAt != null
                        ? MsgStatus.delivered
                        : MsgStatus.offline)
            ],
          )
        : dateText;
  }
}
