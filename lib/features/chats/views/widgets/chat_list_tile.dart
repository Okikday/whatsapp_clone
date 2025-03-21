import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:heroine/heroine.dart';
import 'package:whatsapp_clone/common/app_constants.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';

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
  final void Function(TapUpDetails details)? onTapProfile;
  final bool isSelected;
  final String heroTag;

  final bool isDarkMode;
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
    this.onLongPress,
    required this.isSelected,
    this.onTapProfile,
    required this.isDarkMode,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: isSelected ? (isDarkMode ? WhatsAppColors.msgSentDark : WhatsAppColors.msgSent) : Colors.transparent,
      child: Material(
        type: MaterialType.transparency,
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
              padding: const EdgeInsets.only(right: 16, top: 12, bottom: 12, left: 12),
              child: Row(
                spacing: 12,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Badge(
                        isLabelVisible: isSelected,
                        offset: const Offset(-10, -15),
                        alignment: Alignment.bottomRight,
                        backgroundColor: Colors.transparent,
                        label: CircleAvatar(
                            radius: 12,
                            backgroundColor: isDarkMode ? WhatsAppColors.msgSentDark : WhatsAppColors.msgSent,
                            child: Icon(
                              FontAwesomeIcons.solidCircleCheck,
                              size: 20,
                              color: isDarkMode ? WhatsAppColors.secondary : WhatsAppColors.primary,
                            )).animate().scale(duration: const Duration(milliseconds: 150)),
                        child: Container(
                          width: 50,
                          height: 50,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor
                          ),
                          child: GestureDetector(
                            onTapDown: (details) {},
                            onTapUp: (details) {
                              if (onTapProfile != null) onTapProfile!(details);
                            },
                            child: Heroine(
                              tag: heroTag,
                              spring: Spring.snappy,
                              child: CircleAvatar(
                                backgroundColor: isDarkMode ? WhatsAppColors.battleshipGrey : WhatsAppColors.darkGray,
                                child: (profilePhoto != null && profilePhoto!.isNotEmpty)
                                    ? CachedNetworkImage(imageUrl: profilePhoto!, fit: BoxFit.cover,)
                                    : Image.asset(IconStrings.userIcon, fit: BoxFit.cover,),
                              ),
                            ),
                          ),
                        ),
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
                                child: CustomText(
                              chatName.isNotEmpty ? chatName : "unknown",
                              textAlign: TextAlign.left,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontStyle: chatName.isNotEmpty ? FontStyle.normal : FontStyle.italic,
                              overflow: TextOverflow.ellipsis,
                            )),
                            const SizedBox(
                              width: 12,
                            ),
                            CustomText(lastUpdated ?? "void date", color: isDarkMode ? WhatsAppColors.battleshipGrey : WhatsAppColors.gray),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            height: 28,
                            child: CustomText(
                              isTyping ? "Typing..." : (lastMsg.isEmpty ? "Start chatting" : lastMsg),
                              overflow: TextOverflow.ellipsis,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isTyping
                                  ? Theme.of(context).primaryColor
                                  : isDarkMode
                                      ? WhatsAppColors.battleshipGrey
                                      : WhatsAppColors.gray,
                              fontStyle: isTyping || lastMsg.isEmpty ? FontStyle.italic : FontStyle.normal,
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
      ),
    );
  }
}
