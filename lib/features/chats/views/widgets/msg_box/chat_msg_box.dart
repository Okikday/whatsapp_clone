
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
      
      child: SizedBox(
        width: width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 2, 4, 4,),
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
                            
                            child: MsgInputBar(isDarkMode: isDarkMode, 
                            callbackFunction: (args, constraints){
                                //nativeTextInputController.updateArguments({'inputBoxHeight': constraints.maxHeight });
                                // currChatViewController.setMessageBarHeight(args!.inputBoxHeight == null ? 48.0 : args.maxHeight!.toDouble());
                                log("padding: ${args!.contentPadding}");
                              },
                            ),),
                            )),
                ),
                ChatMsgBoxFunctions.sendOrMicButton(currChatViewController, isDarkMode, scaffoldBgColor)
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class MsgInputBar extends StatelessWidget {
  final bool isDarkMode;
  final void Function(NativeTextInputModel? args, BoxConstraints constraints)? callbackFunction;
  const MsgInputBar({super.key, required this.isDarkMode, this.callbackFunction});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        log("constraints: $constraints");
        return Obx(
              ()=> CustomNativeTextInput(
                    isEnabled: true,
                    nativeTextInputController: nativeTextInputController,
                    hint: "Message",
                    hintStyle: TextStyle(color: isDarkMode ? WhatsAppColors.gray : WhatsAppColors.arsenic),
                    backgroundColor: isDarkMode ? WhatsAppColors.arsenic : Colors.white,
                    borderRadius: 0,
                    cursorColor: WhatsAppColors.secondary,
                    highlightColor: Colors.blue,
                    onchanged: (text) {
                      currChatViewController.setMessageInput(text);
                    },
                    debugBoxColor: Colors.red,
                    // contentPadding: EdgeInsets.only(
                    //   top: 10, bottom: 10
                    //   // top: currChatViewController.messageBarHeight.value > 48.0 ? 2 : 10, bottom: currChatViewController.messageBarHeight.value > 48.0 ? 2 : 10
                    //   ),
                    // debugBoxColor: Colors.red,
                    contentPadding: EdgeInsets.only(
                      top: 10, bottom: 10
                      // top: currChatViewController.messageBarHeight.value > 48.0 ? 2 : 10, bottom: currChatViewController.messageBarHeight.value > 48.0 ? 2 : 10
                      ),
                    internalArgs: (args) async {
                      final int? lines = args.lines;
                      if(callbackFunction != null) callbackFunction!(args, constraints);
                      if (lines != null) {
                        final double height = currChatViewController.checkMessageBarHeight(lines,);
                        // nativeTextInputController.updateArguments({'inputBoxHeight': height });
                      }
                      log("inputBoxHeight: ${args.maxHeight}");
                      
                      
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
    );
  }
}


