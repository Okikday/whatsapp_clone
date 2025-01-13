import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/widgets/custom_native_text_input.dart';
import 'package:whatsapp_clone/features/chats/controllers/chat_view_controller.dart';
import 'package:whatsapp_clone/features/chats/views/chat_view.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/msg_box/chat_msg_box_functions.dart';

class ChatMsgBox extends StatelessWidget {
  final Color scaffoldBgColor;
  const ChatMsgBox({
    super.key,
    required this.scaffoldBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final double newHeight = MediaQuery.viewInsetsOf(context).bottom;
        if ((currChatViewController.cacheKeyboardHeight.value - newHeight).abs() > 1) {
          currChatViewController.cacheKeyboardHeight.value = newHeight;
        }
      });
      return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: DecoratedBox(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: appUiState.isDarkMode.value ? WhatsAppColors.arsenic.withAlpha(40) : WhatsAppColors.seaShell.withAlpha(40),
                              offset: const Offset(0, 1),
                              blurRadius: BlurEffect.neutralBlur,
                              blurStyle: BlurStyle.inner)
                        ], borderRadius: BorderRadius.circular(24)),
                        child: SizedBox(
                          width: 120,
                          height: currChatViewController.messageBarHeight.value,
                          child: MsgInputBar(
                            isDarkMode: appUiState.isDarkMode.value,
                            // callbackFunction: (args, constraints){
                            //     log("padding: ${args!.contentPadding}");
                            //   },
                          ),
                        ),
                      )),
                ),
                SendOrMicButtonWidget(isDarkMode: appUiState.isDarkMode.value, scaffoldBgColor: scaffoldBgColor)
              ],
            ),
            Obx(() {
              final double keyboardHeight = appUiState.viewInsets.value.bottom;
              return SizedBox(
                height: keyboardHeight < 40 ? 0 : keyboardHeight + 4,
              );
            })
          ],
        ),
      );
    });
  }
}

class MsgInputBar extends StatelessWidget {
  final bool isDarkMode;
  final void Function(
    NativeTextInputModel? args,
  )? callbackFunction;
  const MsgInputBar({super.key, required this.isDarkMode, this.callbackFunction});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomNativeTextInput(
        isEnabled: true,
        nativeTextInputController: nativeTextInputController,
        hint: "Message",
        hintStyle: TextStyle(color: isDarkMode ? WhatsAppColors.gray : WhatsAppColors.arsenic),
        backgroundColor: isDarkMode ? WhatsAppColors.arsenic : Colors.white,
        borderRadius: 24,
        cursorColor: WhatsAppColors.secondary,
        highlightColor: Colors.blue,
        onchanged: (text) {
          currChatViewController.setMessageInput(text);
        },
        contentPadding: const EdgeInsets.only(top: 2, bottom: 10),
        inputPadding: EdgeInsets.only(
            top: currChatViewController.messageBarHeight.value > 48.0 ? 2 : 4.5, bottom: currChatViewController.messageBarHeight.value > 48.0 ? 2 : 0),
        internalArgs: (args) async {
          final int? lines = args.lines;
          if (callbackFunction != null) callbackFunction!(args);
          if (lines != null) {
            currChatViewController.checkMessageBarHeight(
              lines,
            );
            // nativeTextInputController.updateArguments({'inputBoxHeight': height });
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
      ),
    );
  }
}

class SendOrMicButtonWidget extends StatelessWidget {
  final bool isDarkMode;
  final Color scaffoldBgColor;
  const SendOrMicButtonWidget({super.key, required this.isDarkMode, required this.scaffoldBgColor});

  @override
  Widget build(BuildContext context) {
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
