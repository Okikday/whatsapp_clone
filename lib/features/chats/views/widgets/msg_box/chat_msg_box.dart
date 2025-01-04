
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/widgets/custom_native_text_input.dart';
import 'package:whatsapp_clone/features/chats/controllers/chat_view_controller.dart';
import 'package:whatsapp_clone/features/chats/views/chat_view.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/msg_box/chat_msg_box_functions.dart';

class ChatMsgBox extends StatelessWidget {
  
  const ChatMsgBox({
    super.key,
    required this.width,
    required this.height,
    required this.keyboardHeight,
    required this.isDarkMode,
    required this.scaffoldBgColor,
  });

  final double width;
  final double height;
  final double keyboardHeight;
  final bool isDarkMode;
  final Color scaffoldBgColor;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: keyboardHeight < 10 ? 0 : keyboardHeight,
      left: 0,
      right: 0,
      
      child: Container(
        clipBehavior: Clip.hardEdge,
                width: width,
                padding: EdgeInsets.fromLTRB(4, 2, 4, 4,),
                // transform: Matrix4.translationValues(0, -(height - 200), 0),
                alignment: Alignment.bottomLeft,
                decoration: BoxDecoration(),
          //       decoration: BoxDecoration(
          //         color: isDarkMode ? Colors.black.withAlpha(242) : WhatsAppColors.seaShell,
          //         image: DecorationImage(image: AssetImage(ImagesStrings.chatBackground),
          //           repeat: ImageRepeat.repeatY,
          //         alignment: Alignment.topLeft,
          //         scale: 1.3,
          //         filterQuality: FilterQuality.high,
          //         colorFilter: ColorFilter.mode(isDarkMode ? WhatsAppColors.gray : WhatsAppColors.linen, BlendMode.srcIn),
          //         fit: BoxFit.none)
          // ), 
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Obx(
            () => Row(
              children: [
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: DecoratedBox(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: isDarkMode ? WhatsAppColors.arsenic.withAlpha(40) : WhatsAppColors.seaShell.withAlpha(40),
                                offset: const Offset(0, 1),
                                blurRadius: BlurEffect.neutralBlur,
                                blurStyle: BlurStyle.inner)
                          ], borderRadius: BorderRadius.circular(24)),
                          
                          child: SizedBox(
                            width: 120,
                            height: currChatViewController.messageBarHeight.value,
                            child: MsgInputBar(isDarkMode: isDarkMode,)))),
                ),
                _sendOrMicButton()
              ],
            ),
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
}

class MsgInputBar extends StatelessWidget {
  final bool isDarkMode;
  const MsgInputBar({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return CustomNativeTextInput(
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
      contentPadding: currChatViewController.messageBarHeight > 48.0 ? const EdgeInsets.only(bottom: 2) : const EdgeInsets.only(top: 6, bottom: 2),
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
            ChatMsgBoxFunctions.widgetAttachmentIconButton(isDarkMode: isDarkMode),
            ChatMsgBoxFunctions.widgetCameraIconButton(isDarkMode: isDarkMode, isVisible: currChatViewController.messageInput.isEmpty ? true : false)
          ],
        ),
      ),
    );
  }
}


