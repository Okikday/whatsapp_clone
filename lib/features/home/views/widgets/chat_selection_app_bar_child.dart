import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:whatsapp_clone/data/app_data.dart';
import 'package:whatsapp_clone/features/home/controllers/chats_tab_ui_controller.dart';

class ChatSelectionAppBarChild extends StatelessWidget {
  const ChatSelectionAppBarChild({super.key});

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
                child: CustomText(chatsTabUiController.chatTilesSelected.length.toString(), fontSize: 18, fontWeight: FontWeight.w500)),
            IconButton(
                onPressed: () {},
                icon: Image.asset(
                  IconStrings.pinOutlined,
                  width: 24,
                  height: 24,
                  color: getCurrIconColor,
                  colorBlendMode: BlendMode.srcIn,
                )),
            IconButton(
                onPressed: () {
                  chatsTabUiController.chatTilesSelected.forEach((key, value) {
                    if (value != null) AppData.chats.deleteChat(value);
                  });
                  chatsTabUiController.clearSelectedChatTiles();
                },
                icon: Icon(
                  Icons.delete,
                  color: getCurrIconColor,
                )),
            IconButton(onPressed: () {}, icon: Icon(Icons.notifications_off_outlined, color: getCurrIconColor)),
            IconButton(onPressed: () {}, icon: Icon(Icons.archive_outlined, color: getCurrIconColor)),
            IconButton(onPressed: () {}, icon: Icon(Icons.more_vert, color: getCurrIconColor))
          ],
        );
      },
    );
  }
}
