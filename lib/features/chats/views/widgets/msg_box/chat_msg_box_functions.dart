import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/features/chats/controllers/chat_view_controller.dart';

class ChatMsgBoxFunctions {
  static Widget widgetAttachmentIconButton({
    required bool isDarkMode,
    void Function()? onPressed,
  }) {
    return IconButton(
        onPressed: () {},
        icon: RotatedBox(
          quarterTurns: 3,
          child: Icon(
            Icons.attachment,
            color: isDarkMode ? WhatsAppColors.battleshipGrey : WhatsAppColors.arsenic,
          ),
        ));
  }

  static Widget widgetCameraIconButton({required bool isDarkMode, required bool isVisible}) {
    return Visibility(
      visible: isVisible,
      child: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.camera_alt_outlined,
            color: isDarkMode ? WhatsAppColors.battleshipGrey : WhatsAppColors.arsenic,
          )).animate().fadeIn(),
    );
  }

  static Widget sendOrMicButton(ChatViewController currChatViewController, bool isDarkMode, Color scaffoldBgColor) {
    final bool isMsgInputEmpty = currChatViewController.messageInput.value.isEmpty;

    return GestureDetector(
      onTapDown: (details) => currChatViewController.setIsMicTappedDown(true),
      onTapUp: (details) => currChatViewController.setIsMicTappedDown(false),
      onTapCancel: () => currChatViewController.setIsMicTappedDown(false),
      child: AnimatedScale(
          scale: isMsgInputEmpty
              ? currChatViewController.isMicTappedDown.value
                  ? 1.25
                  : 1
              : 1,
          duration: const Duration(milliseconds: 100),
          child: CircleAvatar(
              radius: 24,
              backgroundColor: isDarkMode ? WhatsAppColors.secondary : WhatsAppColors.primary,
              child: isMsgInputEmpty
                  ? Icon(Icons.mic, size: 28, color: scaffoldBgColor)
                  : Image.asset(
                      IconStrings.sendIcon,
                      width: 26,
                      height: 26,
                      color: scaffoldBgColor,
                      colorBlendMode: BlendMode.srcIn,
                    ))),
    );
  }
}
