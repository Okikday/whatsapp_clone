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
  const ChatListTile({
    super.key,
    required this.width,
    required this.chatName,
    required this.lastMsg,
    this.profilePhoto,
    this.lastUpdated,
    this.onTap,
    this.unreadMsgs,
    this.hasStatusUpdate,
    this.isTyping = false,
    this.onLongPress
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () {
        //For when it's long pressed
        isDarkMode ? WhatsAppColors.secondary.withAlpha(70) : WhatsAppColors.primary.withAlpha(70);
        if (onTap != null) onTap!();
      },
      onLongPress: () {
        if(onLongPress != null) onLongPress!();
      },
      child: Container(
        width: width,
        height: 80,
        padding: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
        child: Row(
          children: [
            CustomElevatedButton(
              backgroundColor: WhatsAppColors.accent,
              pixelWidth: 80,
              pixelHeight: 80,
              shape: const CircleBorder(),
              onClick: () {},
              child: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(80),
                child: profilePhoto != null
                    ? CachedNetworkImage(
                        imageUrl: profilePhoto!,
                        fit: BoxFit.contain,
                      )
                    : null,
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
                        color: isTyping ? Theme.of(context).primaryColor : isDarkMode ? WhatsAppColors.battleshipGrey : WhatsAppColors.gray,
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
    );
  }
}
