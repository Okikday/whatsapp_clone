import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:heroine/heroine.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/common/app_constants.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/constants.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/utilities/formatter.dart';
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
    chatUiController.overscrollOffset.value = 0;

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
                            width: Get.width,
                            chatName: cacheChatModel.chatName,
                            profilePhoto: cacheChatModel.chatProfilePhoto,
                            lastUpdated: Formatter.chatTimeStamp(cacheChatModel.lastUpdated),
                            lastMsg: cacheChatModel.lastMsg,
                            isDarkMode: isDarkMode,
                            isSelected: chatTilesSelected[index] != null,
                            onTap: () async {
                              if (chatTilesSelected.isEmpty) {
                                if (!chatsTabUiController.isChatViewActive.value) {
                                  chatsTabUiController.setIsChatViewActive(true);
                                  _pushToChatView(
                                      cacheChatModel: cacheChatModel,
                                      messageModel: MessageModel.fromMap(TestChatsData.messageList[index]),
                                      height: appUiState.deviceHeight.value);
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
                                final double overlayWidth = height > width ? width * 0.7 : height * 0.7;
                                // chatsTabUiController.triggerAnimation(Offset(details.localPosition.dx, details.localPosition.dy));
                                log("details: dx: ${details.globalPosition.dx} dy: ${details.globalPosition.dy}");
                                CustomOverlay customOverlay = CustomOverlay(context);
                                customOverlay.showOverlay(
                                  child: GestureDetector(

                                    onTap: () {
                                      customOverlay.removeOverlay();
                                    },
                                    child: Container(
                                      constraints: BoxConstraints(maxHeight: height - 200, maxWidth: width - 100),
                                      color: Colors.red,
                                      child: Animate(
                                              //
                                              child: ClipRRect(
                                                child: Container(
                                                  width: overlayWidth,
                                                  height: overlayWidth,
                                                  color: Colors.yellow,
                                                  child: CustomText("data"),
                                                ),
                                              )),
                                    ),
                                  ),);
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
}

Future<void> _pushToChatView({required ChatModel cacheChatModel, required MessageModel messageModel, required double height}) async {
  final ChatView preloadedChatView = ChatView(
    chatModel: cacheChatModel,
    messageModel: messageModel,
  );
  await Future.delayed(const Duration(milliseconds: 250));
  navigator?.push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return preloadedChatView;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeOutCubic;
        final Animation<Offset> offsetAnimation = animation.drive(
          Tween(begin: const Offset(0.0, 0.1), end: Offset.zero).chain(CurveTween(curve: curve)),
        );
        final Animation<double> reverseFadeAnimation = animation.drive(
          Tween<double>(begin: 0, end: 1.0).chain(CurveTween(curve: Curves.fastOutSlowIn)),
        );

        if (animation.status == AnimationStatus.reverse) {
          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(opacity: reverseFadeAnimation, child: child),
          );
        }
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 250),
    ),
  );
}
