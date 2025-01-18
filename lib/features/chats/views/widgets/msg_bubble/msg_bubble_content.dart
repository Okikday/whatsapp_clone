import 'dart:developer';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/utilities/utilities_funcs.dart';
import 'package:whatsapp_clone/common/widgets/custom_elevated_button.dart';
import 'package:whatsapp_clone/features/chats/use_cases/models/message_model.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/msg_bubble/controllers/msg_bubble_controller.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/msg_bubble/msg_bubble_content_functions.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/msg_bubble/msg_bubble_functions.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/msg_bubble/timestamped_chat_message.dart';

class MsgBubbleContent extends StatelessWidget {
  final MessageModel messageModel;
  final bool hasMedia;
  final bool isSender;
  final Color taggedMsgColor;

  const MsgBubbleContent({
    super.key,
    required this.messageModel,
    required this.hasMedia,
    required this.isSender,
    required this.taggedMsgColor,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle msgContentStyle = const CustomText("").effectiveStyle(context).copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        );
    final bool hasTaggedMessage = messageModel.taggedMessageID != null && messageModel.taggedMessageID!.isNotEmpty;
    final bool hasAttachment =
        messageModel.mediaUrl != null && messageModel.mediaUrl!.isNotEmpty && MessageTypeExtension.fromInt(messageModel.mediaType) != MessageType.text;
    final bool hasMedia = messageModel.mediaUrl != null && messageModel.mediaUrl!.isNotEmpty;
    final bool hasMediaCaption = hasMedia && messageModel.content.isNotEmpty;
    final bool isJustImgOverlay = hasMedia && MessageTypeExtension.fromInt(messageModel.mediaType) != MessageType.text && !hasMediaCaption;
    const TextStyle sentAtStyle = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: Colors.white70,
    );
    final String dateText = DateFormat.jm().format(messageModel.sentAt);
    final double sentAtWidth = MsgBubbleContentFunctions().calcSentAtWidth(dateText, isSender, sentAtStyle) + 2 + 4;
    double taggedMsgWidth = hasMedia ? appUiState.deviceWidth * 0.7 : sentAtWidth + UtilitiesFuncs.getTextSize(messageModel.content, msgContentStyle, maxLines: 1).width + 12.0;
    if (hasMedia) taggedMsgWidth = appUiState.deviceWidth.value * 0.7;
    // Log size on build

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasTaggedMessage)
          BuildTaggedMsgWidget(
            taggedMsgContent: messageModel.content,
            hasMedia: false,
            mediaUrl: messageModel.mediaUrl,
            taggedMsgColor: taggedMsgColor,
            width: taggedMsgWidth,
          ),
        if (hasAttachment)
          BuildAttachmentWidget(
            messageModel: messageModel,
            isSender: isSender,
            isJustImgOverlay: isJustImgOverlay,
          ),
        if (messageModel.content.isNotEmpty || hasMediaCaption)
          Padding(
            padding: const EdgeInsets.only(left: 6, right: 6),
            child: TimestampedChatMessage(
              sentAtWidth: sentAtWidth,
              expandWidth: hasMedia,
              textSpan: TextSpan(
                text: messageModel.content,
                style: msgContentStyle,
              ),
              sentAt: Padding(
                padding: const EdgeInsets.only(
                  top: 4,
                  left: 4,
                ),
                child: BuildTimeStampWidget(
                  date: dateText,
                  isSender: isSender,
                  deliveredAt: messageModel.deliveredAt,
                  seenAt: messageModel.seenAt,
                  sentAtWidth: sentAtWidth,
                  sentAtStyle: sentAtStyle,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class BuildTaggedMsgWidget extends StatelessWidget {
  final Color accentColor;
  final Color taggedMsgColor;
  final double width;
  final String taggedUserName;
  final bool hasMedia;
  final String taggedMsgContent;
  final String? mediaUrl;
  const BuildTaggedMsgWidget({
    super.key,
    this.accentColor = const Color(0xFFA791F9),
    required this.taggedMsgColor,
    required this.width,
    this.taggedUserName = "Someone", 
    required this.hasMedia, 
    required this.taggedMsgContent,
    this.mediaUrl
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle taggedMsgStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.white.withAlpha(125),
      height: 1.0,
      overflow: TextOverflow.ellipsis
    );
    final TextStyle taggedUserNameStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: accentColor,
      overflow: TextOverflow.clip,
    );
    
    final double msgContentWidth = hasMedia ? width * 0.6 : width - 12;
    final double height = (taggedUserNameStyle.fontSize ?? 15) + (UtilitiesFuncs.getTextLines(taggedMsgContent, taggedMsgStyle, maxWidth: msgContentWidth) * 18) + 18;
    // final double height = UtilitiesFuncs.getTextSize()
    final Image taggedImage = Image.asset(ImagesStrings.imgPlaceholder, height: height,);
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: CustomElevatedButton(
        backgroundColor: WhatsAppColors.accentCompliment1,
        borderRadius: 12,
        pixelWidth: width,
        pixelHeight: height,
        contentPadding: const EdgeInsets.only(bottom: 2),
        onClick: () { },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            spacing: 8,
            children: [
              ColoredBox(
                color: accentColor,
                child: SizedBox(
                  width: 4,
                  height: height,
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: msgContentWidth,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 2, top: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          taggedUserName,
                          style: taggedUserNameStyle,
                        ),
                        SizedBox(
                          width: msgContentWidth,
                          child: CustomText(
                          taggedMsgContent,
                          style: taggedMsgStyle,
                          maxLines: 3,
                          
                        ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
             if(hasMedia) FittedBox(child: taggedImage)
            ],
          ),
        ),
      ),
    );
  }
}

class BuildAttachmentWidget extends StatelessWidget {
  final MessageModel messageModel;
  final bool isSender;
  final bool isJustImgOverlay;
  const BuildAttachmentWidget({super.key, required this.messageModel, required this.isSender, required this.isJustImgOverlay});

  @override
  Widget build(BuildContext context) {
    final MessageType msgType = MessageTypeExtension.fromInt(messageModel.mediaType);

    if (msgType == MessageType.image) {
      // Return Image Attachment
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(width: 6, color: Colors.black26),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(0.5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {},
                  child: CachedNetworkImage(
                    imageUrl: messageModel.mediaUrl!,
                    fit: BoxFit.fitWidth,
                    memCacheWidth: (appUiState.deviceWidth.value * 0.7).truncate(),
                  )),
            ),
          ),
        ),
      );
    } else if (msgType == MessageType.document) {
      return SizedBox(
        child: CustomWidgets.text(context, "Attachment"),
      );
    } else if (msgType == MessageType.video) {
      return SizedBox(
        child: CustomWidgets.text(context, "Attachment"),
      );
    } else if (msgType == MessageType.link) {
      return SizedBox(
        child: CustomWidgets.text(context, "Attachment"),
      );
    } else {
      return SizedBox(
        child: CustomWidgets.text(context, "Attachment"),
      );
    }
  }
}

class BuildTimeStampWidget extends StatelessWidget {
  final String date;
  final bool isSender;
  final DateTime? seenAt;
  final DateTime? deliveredAt;
  final TextStyle sentAtStyle;
  final double sentAtWidth;
  final double iconSize;
  const BuildTimeStampWidget(
      {super.key,
      required this.date,
      required this.isSender,
      this.seenAt,
      this.deliveredAt,
      required this.sentAtWidth,
      this.iconSize = 16,
      required this.sentAtStyle});

  @override
  Widget build(BuildContext context) {
    final CustomText dateText = CustomText(
      date,
      style: sentAtStyle,
    );
    if (isSender) {
      return SizedBox(
        width: sentAtWidth + iconSize, // 2 for spacing
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 2,
          children: [
            dateText,
            if (isSender)
              MsgBubbleFunctions.getMsgStatusIcon(
                  seenAt != null
                      ? MsgStatus.read
                      : deliveredAt != null
                          ? MsgStatus.delivered
                          : MsgStatus.offline,
                  size: iconSize)
          ],
        ),
      );
    } else {
      return SizedBox(width: sentAtWidth, child: dateText);
    }
  }
}





/*
class BuildTaggedMsgWidget extends StatefulWidget {
  final MessageModel messageModel;
  final Color accentColor;
  final Color taggedMsgColor;
  const BuildTaggedMsgWidget({super.key, required this.messageModel, this.accentColor = const Color(0xFFA791F9), required this.taggedMsgColor});

  @override
  State<BuildTaggedMsgWidget> createState() => _BuildTaggedMsgWidgetState();
}

class _BuildTaggedMsgWidgetState extends State<BuildTaggedMsgWidget> {
  Size? widgetSize;
  final GlobalKey _widgetKey = GlobalKey();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _calculateSize();
  }

  void _calculateSize() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_widgetKey.currentContext != null) {
        final RenderBox renderBox = _widgetKey.currentContext!.findRenderObject() as RenderBox;
        final newSize = renderBox.size;
        if (widgetSize != newSize) {
          setState(() {
            widgetSize = newSize;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _calculateSize();
    log("Build tagged widget: calculateSize()");
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: ClipRRect(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(12),
        child: CustomElevatedButton(
          key: _widgetKey,
          backgroundColor: widget.taggedMsgColor,
          borderRadius: 0,
          overlayColor: Colors.white24,
          onClick: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              SizedBox(
                width: 6,
                height: widgetSize?.height ?? 8,
                child: ColoredBox(color: widget.accentColor),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6, top: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      CustomWidgets.text(
                        context,
                        "Someone",
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: widget.accentColor,
                        overflow: TextOverflow.clip,
                      ),
                      CustomWidgets.text(
                        context,
                        widget.messageModel.content,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withAlpha(125),
                        height: 1.2,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              FittedBox(
                child: Icon(Icons.image, size: widgetSize?.height != null ? widgetSize!.height - 16 : 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}
*/

 