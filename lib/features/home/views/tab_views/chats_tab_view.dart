import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:heroine/heroine.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/common/app_constants.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/constants.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/utilities/formatter.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';
import 'package:whatsapp_clone/common/widgets/custom_elevated_button.dart';
import 'package:whatsapp_clone/common/widgets/custom_overlay.dart';
import 'package:whatsapp_clone/common/widgets/custom_scroll_physics.dart';
import 'package:whatsapp_clone/features/chats/controllers/chats_ui_controller.dart';
import 'package:whatsapp_clone/features/chats/use_cases/models/chat_model.dart';
import 'package:whatsapp_clone/features/chats/use_cases/models/message_model.dart';
import 'package:whatsapp_clone/features/chats/views/chat_view.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/chat_list_tile.dart';
import 'package:whatsapp_clone/features/home/controllers/chats_tab_ui_controller.dart';
import 'package:whatsapp_clone/test_data_folder/test_data/test_chats_data.dart';

class ChatsTabView extends StatelessWidget {
  final List<ChatModel> chatModels;
  const ChatsTabView({super.key, required this.chatModels});
  @override
  Widget build(BuildContext context) {
    chatUiController.setOverscrollOffset(0.0);
    final Color scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) => chatUiController.onChatListsNotification(notification),
      child: PlayAnimationBuilder(
        duration: const Duration(milliseconds: 100),
        tween: Tween(begin: 0.01, end: 0.0),
        builder: (context, value, child) {
          return AnimatedSlide(
            offset: Offset(0, value),
            duration: const Duration(milliseconds: 100),
            child: child,
          );
        },
        child: Obx(
          () {
            final bool isDarkMode = appUiState.isDarkMode.value;
            final double overscrollOffset = chatUiController.overscrollOffset.value;
            final double width = appUiState.deviceWidth.value;
            final double height = appUiState.deviceHeight.value;
            return CustomScrollView(
              physics: CustomScrollPhysics.android(),
              slivers: [
                // Chats filters section that slides from the bottom
                SliverToBoxAdapter(
                  child: GestureDetector(
                    onTap: () {
                      log("Tapped on sliding filter!");
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      height: overscrollOffset.clamp(0.0, filterTileHeight),
                      child: Transform.translate(
                        offset: Offset(0, -overscrollOffset.clamp(0.0, filterTileHeight)),
                        child: Transform.translate(
                          offset: Offset(0, overscrollOffset.clamp(0, overscrollOffset.clamp(0.0, filterTileHeight))),
                          child: ColoredBox(
                            color: scaffoldBgColor,
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
                    childCount: chatModels.length, // Example number of chats
                    (context, index) {
                      final ChatModel cacheChatModel = chatModels[index];
                      return Obx(
                        () {
                          final Map<int, int?> chatTilesSelected = chatsTabUiController.chatTilesSelected;
                          return ChatListTile(
                            heroTag: cacheChatModel.chatId,
                            width: Get.width,
                            chatName: cacheChatModel.chatName,
                            profilePhoto: cacheChatModel.chatProfilePhoto,
                            lastUpdated: Formatter.chatTimeStamp(cacheChatModel.lastUpdated),
                            lastMsg: cacheChatModel.lastMsg,
                            isDarkMode: isDarkMode,
                            selectedIndex: chatTilesSelected[index],
                            onTap: () async {
                              if (chatTilesSelected.isEmpty) {
                                if (!chatsTabUiController.isChatViewActive.value) {
                                  chatsTabUiController.setIsChatViewActive(true);
                                  final ChatView preloadedChatView = ChatView(
                                    chatModel: cacheChatModel,
                                    messageModel: MessageModel.fromMap(TestChatsData.messageList[index]),
                                  );
                                  Future.delayed(const Duration(milliseconds: 250),
                                      () => navigator?.push(Utilities.customPageRouteBuilder(child: preloadedChatView, height: appUiState.deviceHeight.value)));
                                }
                              } else {
                                if (chatTilesSelected[index] != null) {
                                  chatsTabUiController.removeSelectedChatTile(index);
                                } else {
                                  chatsTabUiController.selectChatTile(index);
                                }
                              }
                            },
                            onLongPress: () {
                              if (chatTilesSelected[index] != null) {
                                chatsTabUiController.removeSelectedChatTile(index);
                              } else {
                                chatsTabUiController.selectChatTile(index);
                              }
                            },
                            onTapProfile: (details) {
                              if (chatTilesSelected.isEmpty) {
                                final double overlayWidth = height > width ? width * 0.65 : height * 0.65;

                                navigator?.push(
                                  profileDialogPageRoute(overlayWidth, cacheChatModel, scaffoldBgColor, index),
                                );
                              } else {
                                if (chatTilesSelected[index] != null) {
                                  chatsTabUiController.removeSelectedChatTile(index);
                                } else {
                                  chatsTabUiController.selectChatTile(index);
                                }
                              }
                            },
                          ).animate().fadeIn(begin: 0.1, duration: const Duration(milliseconds: 350));
                        },
                      );
                    },
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
            );
          },
        ),
      ),
    );
  }

  PageRouteBuilder<dynamic> profileDialogPageRoute(double overlayWidth, ChatModel cacheChatModel, Color scaffoldBgColor, int index) {
    return PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, animation, secondaryAnimation) {
        return GestureDetector(
          onTap: () => navigator?.pop(),
          child: ColoredBox(
            color: Colors.black26,
            child: Align(
              alignment: Alignment.center,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
                child: SizedBox(
                  height: overlayWidth + 56,
                  width: overlayWidth,
                  child: Heroine(
                    tag: cacheChatModel.chatId,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                                width: overlayWidth,
                                child: CachedNetworkImage(
                                  imageUrl: cacheChatModel.chatProfilePhoto!,
                                  fit: BoxFit.fitWidth,
                                )),
                            Positioned(
                                top: 0,
                                child: SizedBox(
                                  height: 40,
                                  width: overlayWidth,
                                  child: ClipRRect(
                                    child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                        child: ColoredBox(
                                            color: Colors.black12,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 4),
                                              child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: CustomText(
                                                    cacheChatModel.contactId,
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                            ))),
                                  ),
                                ))
                          ],
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            width: overlayWidth,
                            child: ColoredBox(
                              color: scaffoldBgColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: Image.asset(
                                      IconStrings.chatIconOutlined,
                                      width: 24,
                                      height: 24,
                                      color: WhatsAppColors.primary,
                                    ),
                                    onPressed: () {
                                      chatsTabUiController.setIsChatViewActive(true);
                                      final ChatView preloadedChatView = ChatView(
                                        chatModel: cacheChatModel,
                                        messageModel: MessageModel.fromMap(TestChatsData.messageList[index]),
                                      );

                                      navigator?.pushReplacement(Utilities.customPageRouteBuilder(child: preloadedChatView, height: appUiState.deviceHeight.value));
                                      // Future.delayed(
                                      //     const Duration(milliseconds: 300),
                                      //     () => navigator?.push(chatViewPageRoute(
                                      //         cacheChatModel: cacheChatModel,
                                      //         messageModel: MessageModel.fromMap(TestChatsData.messageList[index]),
                                      //         height: appUiState.deviceHeight.value)));
                                    },
                                  ),
                                  IconButton(
                                    icon: Image.asset(
                                      IconStrings.callsIconOutlined,
                                      width: 24,
                                      height: 24,
                                      color: WhatsAppColors.primary,
                                    ),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: Image.asset(
                                      IconStrings.videoCallIcon,
                                      width: 24,
                                      height: 24,
                                      color: WhatsAppColors.primary,
                                    ),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.info_outline_rounded),
                                    color: WhatsAppColors.primary,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
