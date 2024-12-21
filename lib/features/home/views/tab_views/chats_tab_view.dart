import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:whatsapp_clone/common/app_constants.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/constants.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/utilities/formatter.dart';
import 'package:whatsapp_clone/common/widgets/custom_elevated_button.dart';
import 'package:whatsapp_clone/common/widgets/custom_overlay.dart';
import 'package:whatsapp_clone/features/chats/controllers/chats_ui_controller.dart';
import 'package:whatsapp_clone/features/chats/use_cases/models/chat_model.dart';
import 'package:whatsapp_clone/features/chats/use_cases/models/message_model.dart';
import 'package:whatsapp_clone/features/chats/views/chat_view.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/chat_list_tile.dart';
import 'package:whatsapp_clone/features/home/controllers/home_ui_controller.dart';
import 'package:whatsapp_clone/features/home/views/home_view.dart';
import 'package:whatsapp_clone/general/test_data/test_chats_data.dart';

class ChatsTabView extends StatelessWidget {
  final List<ChatModel> chatModels;
  const ChatsTabView({super.key, required this.chatModels});
  @override
  Widget build(BuildContext context) {
    chatUiController.overscrollOffset.value = 0;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) => chatUiController.onChatListsNotification(notification),
      child: PlayAnimationBuilder(
        duration: const Duration(milliseconds: 100),
        tween: Tween(begin: 0.03, end: 0.0),
        builder: (context, value, child) {
          return AnimatedSlide(
            offset: Offset(0, value),
            duration: const Duration(milliseconds: 100),
            child: child,
          );
        },
        child: CustomScrollView(
          slivers: [
            // Chats filters section that slides from the bottom
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: () {
                  log("Tapped on sliding filter!");
                },
                child: Obx(
                  () {
                    final double overscrollOffset = chatUiController.overscrollOffset.value;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      height: overscrollOffset.clamp(0.0, filterTileHeight),
                      child: Transform.translate(
                        offset: Offset(0, -overscrollOffset.clamp(0.0, filterTileHeight)),
                        child: Transform.translate(
                          offset: Offset(0, overscrollOffset.clamp(0, overscrollOffset.clamp(0.0, filterTileHeight))),
                          child: ColoredBox(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: SizedBox(
                              width: Get.width,
                              height: filterTileHeight,
                              child: ListView.builder(
                                itemCount: AppConstants.defaultChatsFilters.length,
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                                    child: CustomElevatedButton(
                                      backgroundColor: isDarkMode ? const Color(0xFF103629) : const Color(0xFFD8FDD2),
                                      borderRadius: 16,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                      textSize: 12,
                                      textColor: WhatsAppColors.secondary,
                                      label: AppConstants.defaultChatsFilters[index],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // List of Chats
            const SliverToBoxAdapter(
              child: SizedBox(
                height: Constants.spaceSmall,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final ChatModel cacheChatModel = chatModels[index];
                  return Obx(
                    () {
                      final Map<int, int?> chatTilesSelected = homeUiController.chatTilesSelected;
                      return ChatListTile(
                      width: Get.width,
                      chatName: cacheChatModel.chatName,
                      profilePhoto: cacheChatModel.chatProfilePhoto,
                      lastUpdated: Formatter.timeAgo(cacheChatModel.lastUpdated),
                      lastMsg: cacheChatModel.lastMsg,
                      isSelected: chatTilesSelected[index] != null,
                      onTap: () async {
                        if (chatTilesSelected.isEmpty) {
                          await Future.delayed(const Duration(milliseconds: 175), () {
                            Get.to(() => ChatView(chatModel: cacheChatModel, messageModel: MessageModel.fromMap(TestChatsData.messageList[index]),), transition: Transition.downToUp);
                          });
                        } else {
                          if (chatTilesSelected[index] != null) {
                            homeUiController.removeSelectedChatTile(index);
                          } else {
                            homeUiController.selectChatTile(index);
                          }
                        }
                      },
                      onLongPress: () {
                        if (chatTilesSelected[index] != null) {
                          homeUiController.removeSelectedChatTile(index);
                        } else {
                          homeUiController.selectChatTile(index);
                        }
                      },
                      onTapProfile: () {
                        if (chatTilesSelected.isEmpty) {
                        } else {
                          if (chatTilesSelected[index] != null) {
                            homeUiController.removeSelectedChatTile(index);
                          } else {
                            homeUiController.selectChatTile(index);
                          }
                        }
                      },
                    ).animate().fadeIn(begin: 0.4, duration: const Duration(milliseconds: 350));
                    },
                  );
                },
                childCount: chatModels.length, // Example number of chats
              ),
            ),
    
            SliverToBoxAdapter(
              child: SizedBox(
                  height: 32,
                  child: Align(
                      alignment: Alignment.center,
                      child: CustomWidgets.text(context, "Your personal messages will be end-to-end encrypted",
                          align: TextAlign.center, color: WhatsAppColors.secondary))),
            )
          ],
        ),
      ),
    );
  }
}




class ChatSelectionAppBarChild extends StatelessWidget {
  const ChatSelectionAppBarChild({super.key});

  @override
  Widget build(BuildContext context) {
    final Color getCurrIconColor = Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;
    return Row(
      children: [
        BackButton(color: getCurrIconColor,),
        Expanded(child: Obx(() => CustomWidgets.text(context, homeUiController.chatTilesSelected.length.toString(), fontSize: 18, fontWeight: FontWeight.w500))),
        IconButton(onPressed: (){}, icon: Image.asset(IconStrings.pinIconOutlined, width: 24, height: 24, color: getCurrIconColor, colorBlendMode: BlendMode.srcIn,)),
        IconButton(onPressed: (){}, icon: Icon(Icons.delete, color: getCurrIconColor,)),
        IconButton(onPressed: (){}, icon: Icon(Icons.notifications_off_outlined, color: getCurrIconColor)),
        IconButton(onPressed: (){}, icon: Icon(Icons.archive_outlined, color: getCurrIconColor)),
        IconButton(onPressed: (){}, icon: Icon(Icons.more_vert, color: getCurrIconColor))
      ],
    ).animate().slideX(begin: -0.1, end: 0, duration: const Duration(milliseconds: 200)).fadeIn(duration: const Duration(milliseconds: 200));
  }
}