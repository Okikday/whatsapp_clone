import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:whatsapp_clone/common/app_constants.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/constants.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/widgets/custom_elevated_button.dart';
import 'package:whatsapp_clone/features/chats/controllers/chats_ui_controller.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/chat_list_tile.dart';

class ChatsTabView extends StatelessWidget {
  const ChatsTabView({super.key});
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
                  return ChatListTile(
                    width: Get.width,
                  ).animate().fadeIn(begin: 0.4, duration: const Duration(milliseconds: 350));
                },
                childCount: 20, // Example number of chats
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
