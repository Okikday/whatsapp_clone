import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/widgets/custom_native_text_input.dart';
import 'package:whatsapp_clone/features/chats/controllers/chat_view_controller.dart';
import 'package:whatsapp_clone/features/chats/views/chat_view.dart';

class ChatMsgBox extends StatelessWidget {
  const ChatMsgBox({
    super.key,
    required this.keyboardHeight,
    required this.isDarkMode,
    required this.scaffoldBgColor,
  });

  final double keyboardHeight;
  final bool isDarkMode;
  final Color scaffoldBgColor;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: Get.width,
      bottom: keyboardHeight > 100 ? keyboardHeight + 4 : keyboardHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Obx(
          () => Row(
            children: [
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Container(
                      width: 120,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: isDarkMode ? Colors.white.withAlpha(50) : Colors.black.withAlpha(50),
                            offset: const Offset(0, 1),
                            blurRadius: BlurEffect.neutralBlur,
                            blurStyle: BlurStyle.inner)
                      ], borderRadius: BorderRadius.circular(24)),
                      height: currChatViewController.messageBarHeight.value,
                      child: CustomNativeTextInput(
                        isEnabled: true,
                        nativeTextInputController: nativeTextInputController,
                        alignInput: Alignment.center,
                        hint: "Message",
                        hintStyle: TextStyle(color: isDarkMode ? WhatsAppColors.gray : WhatsAppColors.arsenic),
                        backgroundColor: isDarkMode ? WhatsAppColors.arsenic : Colors.white,
                        borderRadius: 24,
                        cursorColor: WhatsAppColors.secondary,
                        highlightColor: Colors.blue,
                        onchanged: (text) {
                          currChatViewController.setMessageInput(text);
                        },
                        contentPadding:
                            currChatViewController.messageBarHeight > 48.0 ? const EdgeInsets.only(bottom: 2) : const EdgeInsets.only(top: 6, bottom: 2),
                        internalArgs: (args) async {
                          final int? lines = args.lines;
                          if (lines != null) {
                            currChatViewController.checkMessageBarHeight(lines, padding: 16);
                          }
                        },
                        inputTextStyle: TextStyle(color: CustomWidgets.text(context, "").style?.color, fontSize: 18),
                        prefixIcon: IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            IconStrings.stickersIcon,
                            width: 24,
                            height: 24,
                            color: isDarkMode ? WhatsAppColors.battleshipGrey : WhatsAppColors.arsenic,
                            colorBlendMode: BlendMode.srcIn,
                          ),
                        ),
                        suffixIcon: AnimatedSize(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.decelerate,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _widgetAttachmentIconButton(isDarkMode: isDarkMode),
                              _widgetCameraIconButton(isVisible: currChatViewController.messageInput.isEmpty ? true : false)
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
              _sendOrMicButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _sendOrMicButton() {
    final bool isMsgInputEmpty = currChatViewController.messageInput.isEmpty;

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

  Widget _widgetCameraIconButton({required bool isVisible}) {
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

Widget _widgetAttachmentIconButton({
  required bool isDarkMode,
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
