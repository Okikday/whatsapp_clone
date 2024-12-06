
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';

class ChatListTile extends StatelessWidget {
  final double width;
  const ChatListTile({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      overlayColor: WidgetStatePropertyAll(isDarkMode ? WhatsAppColors.secondary.withOpacity(0.25) : WhatsAppColors.primary.withOpacity(0.25)),
      onTap: (){

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
