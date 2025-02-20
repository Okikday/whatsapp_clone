import 'dart:developer';
import 'dart:ui';

import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:heroine/heroine.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:whatsapp_clone/app/controllers/app_animation_settings.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/utilities/formatter.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';
import 'package:whatsapp_clone/data/app_data.dart';
import 'package:whatsapp_clone/features/chats/views/chat_view.dart';
import 'package:whatsapp_clone/features/chats/views/profile_view.dart';
import 'package:whatsapp_clone/features/chats/views/select_contact_view.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/chat_list_tile.dart';
import 'package:whatsapp_clone/features/home/controllers/chats_tab_ui_controller.dart';
import 'package:whatsapp_clone/models/chat_model.dart';

class ChatsTabLists extends StatelessWidget {
  const ChatsTabLists({
    super.key,
    required this.isDarkMode,
    required this.height,
    required this.width,
    required this.scaffoldBgColor,
    required this.themeData,
  });

  final bool isDarkMode;
  final double height;
  final double width;
  final Color scaffoldBgColor;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: chatsTabUiController.tabChatsListStream.value,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return SliverImplicitlyAnimatedList<ChatModel>(
              items: snapshot.data!,
              removeDuration: Durations.short4,
              insertDuration: Durations.short4,
              updateDuration: Durations.short4,
              areItemsTheSame: (oldItem, newItem) => oldItem.chatId == newItem.chatId,
              itemBuilder: (context, animation, chatModel, index) {
                return SizeTransition(
                  sizeFactor: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: animation, curve: CustomCurves.ease)),
                  child: Obx(
                    () {
                      final chatTilesSelected = chatsTabUiController.chatTilesSelected;

                      return ChatListTile(
                        heroTag: chatModel.chatId,
                        width: Get.width,
                        chatName: chatModel.chatName,
                        profilePhoto: chatModel.chatProfilePhoto,
                        lastUpdated: Formatter.chatTimeStamp(chatModel.lastUpdated),
                        lastMsg: chatModel.lastMsg,
                        isDarkMode: isDarkMode,
                        isSelected: chatTilesSelected[index] != null,
                        onTap: () async {
                          if (chatTilesSelected.isEmpty) {
                            if (chatsTabUiController.allowPagePush.value) {
                              final String? userId = AppData.userId;
                              if(userId == null) return;
                              chatsTabUiController.setAllowPagePush(false);

                              log("allowPage push: ${chatsTabUiController.allowPagePush.value}");
                              final ChatView preloadedChatView = ChatView(
                                chatModel: chatModel,
                                myUserId: userId,
                              );
                              await Future.delayed(const Duration(milliseconds: 250));
                              navigator
                                  ?.push(Utilities.customPageRouteBuilder(preloadedChatView,
                                      curve: appAnimationSettingsController.curve,
                                      transitionDuration: appAnimationSettingsController.transitionDuration,
                                      reverseTransitionDuration: appAnimationSettingsController.reverseTransitionDuration))
                                  .then((onValue) {
                                chatsTabUiController.setAllowPagePush(true);
                              });
                            }
                          } else {
                            if (chatTilesSelected[index] != null) {
                              chatsTabUiController.removeSelectedChatTile(index);
                            } else {
                              chatsTabUiController.selectChatTile(index, chatId: chatModel.chatId);
                            }
                          }
                        },
                        onLongPress: () {
                          if (chatTilesSelected[index] != null) {
                            chatsTabUiController.removeSelectedChatTile(index);
                          } else {
                            chatsTabUiController.selectChatTile(index, chatId: chatModel.chatId);
                          }
                        },
                        onTapProfile: (details) {
                          if (chatTilesSelected.isEmpty) {
                            final double overlayWidth = height > width ? width * 0.65 : height * 0.65;

                            navigator?.push(
                              profileDialogPageRoute(overlayWidth, chatModel, scaffoldBgColor, index, heroTag: chatModel.chatId),
                            );
                          } else {
                            if (chatTilesSelected[index] != null) {
                              chatsTabUiController.removeSelectedChatTile(index);
                            } else {
                              chatsTabUiController.selectChatTile(index, chatId: chatModel.chatId);
                            }
                          }
                        },
                      );
                    },
                  ),
                );
              },
            );
          } else if (snapshot.connectionState == ConnectionState.active && (snapshot.data == null || snapshot.data!.isEmpty)) {
            return SliverToBoxAdapter(
                child: SizedBox(
                    height: height > 120 ? height - 72 : null,
                    width: width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         const CustomText(
                          "Welcome to WhatsApp Clone 🌚",
                          fontStyle: FontStyle.italic,
                          color: WhatsAppColors.emerald,
                        ).animate().fadeOut(duration: const Duration(seconds: 1), curve: Curves.easeIn),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 72,
                          child: ListView.builder(
                              itemCount: 10,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    left: 8,
                                    right: index == 9 ? 8 : 0,
                                  ),
                                  child: const Skeletonizer(
                                      child: Icon(
                                    Icons.person,
                                    size: 64,
                                  )),
                                );
                              }),
                        ),
                        const SizedBox(height: 32),
                        TextButton.icon(
                            style: ButtonStyle(overlayColor: WidgetStatePropertyAll(themeData.primaryColor.withValues(alpha: 0.1))),
                            onPressed: () {
                              navigator?.push(Utilities.customPageRouteBuilder(const SelectContactView()));
                            },
                            icon: Icon(
                              Icons.add_rounded,
                              color: themeData.primaryColor,
                            ),
                            label: CustomText("Start a new chat", color: themeData.primaryColor)),
                        const SizedBox(
                          height: 64,
                        ),
                      ],
                    )));
          } else {
            return SliverSkeletonizer(
              enabled: true,
              effect: const PulseEffect(),
              child: SliverList.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return ChatListTile(
                      width: width,
                      chatName: "chatName",
                      lastMsg: "lastMsg",
                      isDarkMode: isDarkMode,
                      heroTag: "$index",
                      isSelected: false,
                    );
                  }),
            );
          }
        });
  }
}

PageRouteBuilder<dynamic> profileDialogPageRoute(double overlayWidth, ChatModel cacheChatModel, Color scaffoldBgColor, int index,
    {required String heroTag}) {
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
                  tag: heroTag,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                              width: overlayWidth,
                              child: cacheChatModel.chatProfilePhoto != null && cacheChatModel.chatProfilePhoto!.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: cacheChatModel.chatProfilePhoto!,
                                      fit: BoxFit.fitWidth,
                                    )
                                  : Image.asset(ImagesStrings.imgPlaceholder)),
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
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Image.asset(
                                    IconStrings.chatOutlined,
                                    width: 24,
                                    height: 24,
                                    color: WhatsAppColors.primary,
                                  ),
                                  onPressed: () async {
                                    if (chatsTabUiController.allowPagePush.value) {
                                      final String? userId = AppData.userId;
                                      if(userId == null) return;
                                      chatsTabUiController.setAllowPagePush(false);
                                      final ChatView preloadedChatView = ChatView(
                                        chatModel: cacheChatModel,
                                        myUserId: userId,
                                      );
                                      await Future.delayed(Durations.medium1);
                                      navigator
                                          ?.pushReplacement(Utilities.customPageRouteBuilder(preloadedChatView,
                                              curve: appAnimationSettingsController.curve,
                                              transitionDuration: appAnimationSettingsController.transitionDuration,
                                              reverseTransitionDuration: appAnimationSettingsController.reverseTransitionDuration))
                                          .then((onValue) {
                                        chatsTabUiController.setAllowPagePush(true);
                                      });
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Image.asset(
                                    IconStrings.callsOutlined,
                                    width: 24,
                                    height: 24,
                                    color: WhatsAppColors.primary,
                                  ),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: Image.asset(
                                    IconStrings.videoCall,
                                    width: 24,
                                    height: 24,
                                    color: WhatsAppColors.primary,
                                  ),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await Future.delayed(Durations.medium1);
                                    navigator?.pushReplacement(Utilities.customPageRouteBuilder(ProfileView(chatModel: cacheChatModel),
                                        curve: appAnimationSettingsController.curve,
                                        transitionDuration: appAnimationSettingsController.transitionDuration,
                                        reverseTransitionDuration: appAnimationSettingsController.reverseTransitionDuration));
                                  },
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
