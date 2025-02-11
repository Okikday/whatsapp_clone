import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:heroine/heroine.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:whatsapp_clone/app/controllers/app_animation_settings.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/common/app_constants.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/constants.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:whatsapp_clone/features/home/views/sub_widgets/chats_tab_lists.dart';
import 'package:whatsapp_clone/models/chat_model.dart';
import 'package:whatsapp_clone/features/home/controllers/chats_tab_ui_controller.dart';

class ChatsTabView extends StatefulWidget {
  const ChatsTabView({super.key,});

  @override
  State<ChatsTabView> createState() => _ChatsTabViewState();
}

class _ChatsTabViewState extends State<ChatsTabView> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // chatsTabUiController.setOverscrollOffset(0.0);
    final ThemeData themeData = Theme.of(context);
    final Color scaffoldBgColor = themeData.scaffoldBackgroundColor;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) => chatsTabUiController.onChatListsNotification(notification),
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
            final double overscrollOffset = chatsTabUiController.overscrollOffset.value;
            final double width = appUiState.deviceWidth.value;
            final double height = appUiState.deviceHeight.value;

            return StreamBuilder(
              stream: chatsTabUiController.tabChatsListStream.value,
              builder: (context, snapshot) {
                return CustomScrollView(
                  physics: CustomScrollPhysics.android(),
                  slivers: [
                    // Chats filters section that slides from the bottom
                    SliverToBoxAdapter(
                      child: GestureDetector(
                        onTap: () {
                          // log("Tapped on sliding filter!");
                        },
                        child: Builder(builder: (context) {
                          if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                            return AnimatedContainer(
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
                            );
                          }

                          return const SizedBox();
                        }),
                      ),
                    ),
                    // List of Chats
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: Constants.spaceSmall,
                      ),
                    ),

                    ChatsTabLists(
                        isDarkMode: isDarkMode,
                        height: height,
                        width: width,
                        scaffoldBgColor: scaffoldBgColor,
                        themeData: themeData),

                    const SliverToBoxAdapter(
                      child: Divider(),
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.lock_outline_rounded,
                                  size: 14,
                                  color: isDarkMode ? WhatsAppColors.darkTextSecondary : WhatsAppColors.textSecondary,
                                ),
                                CustomRichText(children: [
                                  CustomTextSpanData("Your personal messages are ",
                                      color: isDarkMode ? WhatsAppColors.darkTextSecondary : WhatsAppColors.textSecondary,
                                      fontWeight: FontWeight.w600),
                                  CustomTextSpanData("end-to-end encrypted", color: themeData.primaryColor, fontWeight: FontWeight.w600)
                                ]),
                              ],
                            )),
                      ),
                    ),

                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 72,
                      ),
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}




