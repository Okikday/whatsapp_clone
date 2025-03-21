import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';
import 'package:whatsapp_clone/common/utilities/utilities_funcs.dart';
import 'package:whatsapp_clone/common/widgets/custom_native_text_input.dart';
import 'package:whatsapp_clone/data/app_data.dart';
import 'package:whatsapp_clone/data/user_data/user_data.dart';
import 'package:whatsapp_clone/features/chats/controllers/chat_view_controller.dart';
import 'package:whatsapp_clone/features/chats/use_cases/functions/chat_msg_box_functions.dart';
import 'package:whatsapp_clone/features/chats/use_cases/functions/chats_functions.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/msg_box/chat_msg_box_widgets.dart';
import 'package:whatsapp_clone/models/chat_model.dart';
import 'package:whatsapp_clone/models/message_model.dart';


class ChatMsgBox extends StatelessWidget {
  final Color scaffoldBgColor;
  final ChatViewController chatViewController;
  const ChatMsgBox({super.key, required this.scaffoldBgColor, required this.chatViewController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final double keyboardHeight = appUiState.viewInsets.value.bottom;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(right: 4, top: 2),
                      child: DecoratedBox(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: appUiState.isDarkMode.value
                                  ? WhatsAppColors.arsenic.withAlpha(40)
                                  : WhatsAppColors.seaShell.withAlpha(40),
                              offset: const Offset(0, 1),
                              blurRadius: BlurEffect.neutralBlur,
                              blurStyle: BlurStyle.inner)
                        ], borderRadius: BorderRadius.circular(24)),
                        child: MsgInputBar(
                          keyboardHeight: keyboardHeight,
                          isDarkMode: appUiState.isDarkMode.value,
                          currChatViewController: chatViewController,
                        ),
                      )),
                ),
                SendOrMicButtonWidget(
                  chatViewController: chatViewController,
                  isDarkMode: appUiState.isDarkMode.value,
                  scaffoldBgColor: scaffoldBgColor,
                  onTapSend: () async {
                    ChatMsgBoxFunctions(chatViewController).sendMessage();
                  },
                )
              ],
            ),
          ),
          SizedBox(
            height: (keyboardHeight < 20 ? 4 : keyboardHeight + 6),
          )
        ],
      );
    });
  }
}

class MsgInputBar extends StatelessWidget {
  final bool isDarkMode;
  final double keyboardHeight;
  final void Function(
      NativeTextInputModel? args,
      )? callbackFunction;
  final ChatViewController currChatViewController;
  const MsgInputBar({super.key, required this.isDarkMode, this.callbackFunction, required this.currChatViewController, required this.keyboardHeight,});

  @override
  Widget build(BuildContext context) {
    final TextStyle inputTextStyle = TextStyle(color: const CustomText("").style?.color, fontSize: 18, height: 1.2);
    final Color primaryColor = Theme.of(context).primaryColor;

    return Obx(
          () {
        final double maxHeight = (appUiState.deviceHeight.value - (keyboardHeight + kToolbarHeight + appUiState.viewInsets.value.top));

        return Stack(
          children: [
            CustomTextfield(
              selectionHandleColor: primaryColor,
              selectionColor: primaryColor.withValues(alpha: 0.4),
              controller: currChatViewController.textEditingController,
              isEnabled: true,
              constraints: BoxConstraints(
                  minHeight: 48.0,
                  maxHeight: maxHeight > 48.0 ? maxHeight : 48.0
              ),
              hint: "Message",
              maxLines: 6,
              hintStyle: TextStyle(color: isDarkMode ? WhatsAppColors.gray : WhatsAppColors.arsenic),
              backgroundColor: isDarkMode ? WhatsAppColors.arsenic : Colors.white,
              borderRadius: 24,
              cursorColor: primaryColor,
              readOnly: currChatViewController.isKeyboardReadOnly,
              ontap: (){
                currChatViewController.setIsKeyboardReadOnly(false);
              },
              onTapOutside: () {},
              onchanged: (text) {
                if (text == currChatViewController.messageInput.value) return;
                currChatViewController.setMessageInput(text);
              },
              inputContentPadding: const EdgeInsets.only(top: 8, bottom: 2,),
              inputTextStyle: inputTextStyle,

              prefixIcon: const SizedBox(width: 44,),
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
                    const SizedBox(width: 44,),
                    Visibility(
                        visible: currChatViewController.messageInput.isEmpty ? true : false,
                        child: const SizedBox(width: 44,)),
                  ],
                ),
              ),
            ),

            // Overlay of suffix and prefix icon
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: IconButton(
                      style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap,),
                      onPressed: () {},
                      icon: Image.asset(
                        IconStrings.stickers,
                        width: 24,
                        height: 24,
                        color: isDarkMode ? WhatsAppColors.battleshipGrey : WhatsAppColors.arsenic,
                        colorBlendMode: BlendMode.srcIn,
                      ),
                    ),
                  ),

                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.decelerate,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 0,
                      children: [
                        ChatMsgBoxWidgets.widgetAttachmentIconButton(isDarkMode: isDarkMode),
                        ChatMsgBoxWidgets.widgetCameraIconButton(
                            isDarkMode: isDarkMode, isVisible: currChatViewController.messageInput.isEmpty ? true : false)
                      ],
                    ),
                  )
                ],
              ),)
          ],
        );
      },
    );
  }
}

class SendOrMicButtonWidget extends StatelessWidget {
  final bool isDarkMode;
  final Color scaffoldBgColor;
  final ChatViewController chatViewController;
  final void Function()? onTapSend;
  const SendOrMicButtonWidget(
      {super.key, required this.isDarkMode, required this.scaffoldBgColor, required this.chatViewController, this.onTapSend});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () {
        final ChatModel chatModel = chatViewController.chatModel;
        final bool isMsgInputEmpty = chatViewController.messageInput.value.isEmpty;
        return GestureDetector(
          onTapDown: (details) async {
            if (isMsgInputEmpty) {
              chatViewController.setIsMicTappedDown(true);
            }
          },
          onTap: isMsgInputEmpty
              ? null
              : () {
            if (onTapSend != null) onTapSend!();
          },
          onTapUp: (details) {
            if (chatViewController.isMicTappedDown.value != false) chatViewController.setIsMicTappedDown(false);
          },
          onTapCancel: () {
            if (chatViewController.isMicTappedDown.value != false) chatViewController.setIsMicTappedDown(false);
          },
          onLongPress: !isMsgInputEmpty
              ? null
              : () {
            // if (chatViewController.chatsSelected.isNotEmpty) {
            //   chatViewController.clearSelectedChatBubble();
            // }
          },
          onLongPressCancel: () {
            if (chatViewController.chatsSelected.isNotEmpty) {
              chatViewController.clearSelectedChatBubble();
            }
          },
          child: AnimatedScale(
              scale: isMsgInputEmpty
                  ? chatViewController.isMicTappedDown.value
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