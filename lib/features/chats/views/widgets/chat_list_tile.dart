
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/features/chats/views/curr_chat_view.dart';

class ChatListTile extends StatelessWidget {
  final double width;
  const ChatListTile({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      overlayColor: WidgetStatePropertyAll(Colors.grey.withOpacity(0.1)),
      onTap: (){
        //For when it's long pressed
        isDarkMode ? WhatsAppColors.secondary.withOpacity(0.25) : WhatsAppColors.primary.withOpacity(0.25);

        Get.to(() => const CurrChatView(), transition: Transition.downToUp);

      },
      onLongPress: () {
        
      },
      child: Container(
        width: width,
        height: 80,
        padding: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
        child: Row(
          children: [
            const CircleAvatar(backgroundColor: Colors.blue, radius: 40,),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 28,
                    child: Row(
                      children: [
                        Expanded(child: CustomWidgets.text(context, "Chat name", align: TextAlign.left, fontSize: 18, fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis,)),
                        const SizedBox(width: 12,),
                        CustomWidgets.text(context, "Yesterday"),
                    ],),
                  ),
                  SizedBox(
                    height: 28,
                    child: Row(
                      children: [
                        // Icon before message, be it photo, doc, read etc
                        CustomWidgets.text(context, "How are you doing?", fontSize: 13),
                      ],
                    ),
                  ),
                ],
              ))
          ],
        ),
      ),
    );
  }
}
