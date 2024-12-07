import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/common/app_constants.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/constants.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/widgets/custom_elevated_button.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/chat_list_tile.dart';

class ChatsTabView extends StatefulWidget {
  const ChatsTabView({super.key});
  @override
  State<ChatsTabView> createState() => _ChatsTabViewState();
}

class _ChatsTabViewState extends State<ChatsTabView> {
  double overscrollOffset = 0.0;
  final double revealThreshold = 24.0; // Height needed to fully reveal filters view
  static const double filterTileHeight = 36;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is OverscrollNotification) {
          setState(() {
            overscrollOffset += notification.overscroll.abs();
            if (overscrollOffset < 0) overscrollOffset = 0.0;
            if (overscrollOffset > revealThreshold) overscrollOffset = filterTileHeight;
          });
        } else if (notification is ScrollEndNotification) {
          setState(() {
            if (overscrollOffset < revealThreshold) {
              overscrollOffset = 0.0;
            }
          });
        }
        return true;
      },
      child: CustomScrollView(
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
                                textSize: 12 * (overscrollOffset / filterTileHeight).clamp(0.0, 1.0),
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
          const SliverToBoxAdapter(child: SizedBox(height: Constants.spaceSmall,),),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ChatListTile(
                  width: Get.width,
                ).animate().fadeIn(begin: 0.5, duration: const Duration(milliseconds: 350));
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
      ).animate().slideY(begin: 0.05, end: 0, duration: const Duration(milliseconds: 300), curve: Curves.decelerate,),
    );
  }
}
