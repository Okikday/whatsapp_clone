import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/common/app_constants.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';
import 'package:whatsapp_clone/common/widgets/custom_elevated_button.dart';

class ChatListTile extends StatelessWidget {
  final double width;
  final String chatName;
  final String lastMsg;
  final String? profilePhoto;
  final String? lastUpdated;
  final int? unreadMsgs;
  final bool? hasStatusUpdate;
  final bool isTyping;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final void Function()? onTapProfile;
  final bool isSelected;
  const ChatListTile(
      {super.key,
      required this.width,
      required this.chatName,
      required this.lastMsg,
      this.profilePhoto,
      this.lastUpdated,
      this.onTap,
      this.unreadMsgs,
      this.hasStatusUpdate,
      this.isTyping = false,
      this.onLongPress,
      this.isSelected = false,
      this.onTapProfile
      });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ColoredBox(
      color: isSelected ? WhatsAppColors.primary.withAlpha(50) : Colors.transparent,
      child: InkWell(
        onTap: () {
          //For when it's long pressed
          isDarkMode ? WhatsAppColors.secondary.withAlpha(70) : WhatsAppColors.primary.withAlpha(70);
          if (onTap != null) onTap!();
        },
        onLongPress: () {
          if (onLongPress != null) onLongPress!();
        },
        child: SizedBox(
          width: width,
          height: 80,
          child: Padding(
            padding: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
            child: Row(
              children: [
                CustomElevatedButton(
                  backgroundColor: WhatsAppColors.accent,
                  pixelWidth: 80,
                  pixelHeight: 80,
                  shape: const CircleBorder(),
                  onClick: () {
                    if(onTapProfile != null) onTapProfile!();
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: profilePhoto != null
                          ? DecorationImage(
                              image: CachedNetworkImageProvider(profilePhoto!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                  ),
                ),
                Expanded(
                    child: Column(
                  spacing: 4,
                  children: [
                    SizedBox(
                      height: 28,
                      child: Row(
                        children: [
                          Expanded(
                              child: CustomWidgets.text(
                            context,
                            chatName,
                            align: TextAlign.left,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                          )),
                          const SizedBox(
                            width: 12,
                          ),
                          CustomWidgets.text(context, lastUpdated, color: isDarkMode ? WhatsAppColors.battleshipGrey : WhatsAppColors.gray),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 28,
                          child: CustomWidgets.text(
                            context,
                            isTyping ? "Typing..." : lastMsg,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isTyping
                                ? Theme.of(context).primaryColor
                                : isDarkMode
                                    ? WhatsAppColors.battleshipGrey
                                    : WhatsAppColors.gray,
                            fontStyle: isTyping ? FontStyle.italic : FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
