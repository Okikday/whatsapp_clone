
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:whatsapp_clone/common/utilities/utilities_funcs.dart';
import 'package:whatsapp_clone/common/widgets/custom_native_text_input.dart';
import 'package:whatsapp_clone/features/chats/controllers/chat_view_controller.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/msg_box/chat_msg_box_functions.dart';

class ChatMsgBox extends StatelessWidget {
  final Color scaffoldBgColor;
  final ChatViewController currChatViewController;
  const ChatMsgBox({super.key, required this.scaffoldBgColor, required this.currChatViewController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final double keyboardHeight = appUiState.viewInsets.value.bottom;
      return SizedBox(
        height: currChatViewController.messageBarHeight.value + (keyboardHeight < 40 ? 4 : keyboardHeight + 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(right: 4, top: 2),
                  child: DecoratedBox(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: appUiState.isDarkMode.value ? WhatsAppColors.arsenic.withAlpha(40) : WhatsAppColors.seaShell.withAlpha(40),
                          offset: const Offset(0, 1),
                          blurRadius: BlurEffect.neutralBlur,
                          blurStyle: BlurStyle.inner)
                    ], borderRadius: BorderRadius.circular(24)),
                    child: MsgInputBar(
                      isDarkMode: appUiState.isDarkMode.value,
                      currChatViewController: currChatViewController,
                    ),
                  )),
            ),
            SendOrMicButtonWidget(
              isDarkMode: appUiState.isDarkMode.value,
              scaffoldBgColor: scaffoldBgColor,
              currChatViewController: currChatViewController,
            )
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
  final ChatViewController currChatViewController;
  const MsgInputBar({super.key, required this.isDarkMode, this.callbackFunction, required this.currChatViewController});

  @override
  Widget build(BuildContext context) {
    final TextStyle inputTextStyle = TextStyle(color: const CustomText("").style?.color, fontSize: 18, height: 1.2);
    return Obx(
      () => CustomTextfield(
        pixelHeight: currChatViewController.messageBarHeight.value,
        isEnabled: true,
        hint: "Message",
        hintStyle: TextStyle(color: isDarkMode ? WhatsAppColors.gray : WhatsAppColors.arsenic),
        backgroundColor: isDarkMode ? WhatsAppColors.arsenic : Colors.white,
        borderRadius: 24,
        cursorColor: WhatsAppColors.secondary,
        onTapOutside: () {},
        onchanged: (text) {
          if (text == currChatViewController.messageInput.value) return;
          currChatViewController.setMessageInput(text);
          currChatViewController.checkMessageBarHeight(
            UtilitiesFuncs.getTextLines(text, inputTextStyle, maxWidth: appUiState.deviceWidth.value - 168) - 1,
            lineHeight: 18 * 1.2,
          );
        },
        inputContentPadding: EdgeInsets.only(
            top: currChatViewController.messageBarHeight.value == 48.0 ? 0 : 8, bottom: currChatViewController.messageBarHeight.value == 48.0 ? 0 : 2),
        inputTextStyle: inputTextStyle,
        prefixIcon: IconButton(
          onPressed: () {},
          icon: Image.asset(
            IconStrings.stickers,
            width: 24,
            height: 24,
            color: isDarkMode ? WhatsAppColors.battleshipGrey : WhatsAppColors.arsenic,
            colorBlendMode: BlendMode.srcIn,
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
        alwaysShowSuffixIcon: true,
        suffixIcon: AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.decelerate,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 0,
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
  final ChatViewController currChatViewController;
  const SendOrMicButtonWidget({super.key, required this.isDarkMode, required this.scaffoldBgColor, required this.currChatViewController});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final bool isMsgInputEmpty = currChatViewController.messageInput.value.isEmpty;
        return Padding(
          padding: EdgeInsets.only(top: (currChatViewController.messageBarHeight.value - 48).clamp(0, 140)),
          child: GestureDetector(
            onTapDown: (details) {
              currChatViewController.setIsMicTappedDown(true);
            },
            onTapUp: (details) => currChatViewController.setIsMicTappedDown(false),
            onTapCancel: () => currChatViewController.setIsMicTappedDown(false),
            onLongPress: () {
              if (chatViewController.chatsSelected.isNotEmpty) {
                chatViewController.clearSelectedChatBubble();
              }
            },
            onLongPressCancel: () {
              if (chatViewController.chatsSelected.isNotEmpty) {
                chatViewController.clearSelectedChatBubble();
              }
            },
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
                            IconStrings.send,
                            width: 26,
                            height: 26,
                            color: scaffoldBgColor,
                            colorBlendMode: BlendMode.srcIn,
                          ))),
          ),
        );
      },
    );
  }
}








/*
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
*/