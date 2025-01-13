import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/features/home/controllers/chats_tab_ui_controller.dart';

class ChatSelectionAppBarChild extends StatelessWidget {
  const ChatSelectionAppBarChild({super.key});

  @override
  Widget build(BuildContext context) {
    final Color getCurrIconColor = Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;
    return Row(
      children: [
        BackButton(
          color: getCurrIconColor,
        ),
        Expanded(
            child: Obx(() => CustomWidgets.text(context, chatsTabUiController.chatTilesSelected.length.toString(), fontSize: 18, fontWeight: FontWeight.w500))),
        IconButton(
            onPressed: () {},
            icon: Image.asset(
              IconStrings.pinIconOutlined,
              width: 24,
              height: 24,
              color: getCurrIconColor,
              colorBlendMode: BlendMode.srcIn,
            )),
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.delete,
              color: getCurrIconColor,
            )),
        IconButton(onPressed: () {}, icon: Icon(Icons.notifications_off_outlined, color: getCurrIconColor)),
        IconButton(onPressed: () {}, icon: Icon(Icons.archive_outlined, color: getCurrIconColor)),
        IconButton(onPressed: () {}, icon: Icon(Icons.more_vert, color: getCurrIconColor))
      ],
    ).animate().slideX(begin: -0.1, end: 0, duration: const Duration(milliseconds: 200)).fadeIn(duration: const Duration(milliseconds: 200));
  }
}
