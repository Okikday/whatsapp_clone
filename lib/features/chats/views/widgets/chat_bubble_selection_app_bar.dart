import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:whatsapp_clone/features/chats/controllers/chat_view_controller.dart';

class ChatBubbleSelectionAppBar extends StatelessWidget {
  final ChatViewController chatViewController;
  const ChatBubbleSelectionAppBar({super.key, required this.chatViewController});

  @override
  Widget build(BuildContext context) {

    return Obx(
          () {
        final Color getCurrIconColor = appUiState.isDarkMode.value ? Colors.white : Colors.black;
        return Row(
          children: [
            BackButton(
              color: getCurrIconColor,
            ),
            Expanded(
                child: CustomText(chatViewController.chatsSelected.length.toString(), fontSize: 18, fontWeight: FontWeight.w500)),
            IconButton(
                onPressed: () {},
                icon: Image.asset(IconStrings.arrowTurnLeft, color: getCurrIconColor, width: 24, height: 24,)),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.delete,
                  color: getCurrIconColor,
                )),
            IconButton(
                onPressed: () {},
                icon: Image.asset(IconStrings.forward, color: getCurrIconColor, width: 24, height: 24,)),
            IconButton(onPressed: () {}, icon: Icon(Icons.archive_outlined, color: getCurrIconColor)),
            IconButton(onPressed: () {}, icon: Icon(Icons.more_vert, color: getCurrIconColor))
          ],
        ).animate().slideX(begin: -0.1, end: 0, duration: const Duration(milliseconds: 200)).fadeIn(duration: const Duration(milliseconds: 200));
      },
    );
  }
}