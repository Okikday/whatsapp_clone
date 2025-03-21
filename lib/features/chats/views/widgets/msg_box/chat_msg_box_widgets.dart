
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:whatsapp_clone/common/colors.dart';

class ChatMsgBoxWidgets {
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

 
}
