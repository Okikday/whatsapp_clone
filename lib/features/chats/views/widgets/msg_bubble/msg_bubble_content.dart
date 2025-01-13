import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/utilities/formatter.dart';
import 'package:whatsapp_clone/common/utilities/utilities_funcs.dart';
import 'package:whatsapp_clone/common/widgets/custom_elevated_button.dart';
import 'package:whatsapp_clone/features/chats/use_cases/models/message_model.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/msg_bubble/msg_bubble.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/msg_bubble/msg_bubble_content_functions.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/msg_bubble/timestamped_chat_message.dart';

class MsgBubbleContent extends StatelessWidget {
  final MessageModel messageModel;
  final bool hasMedia;
  final bool isSender;
  final Color taggedMsgColor;
  final bool isJustImgOverlay;
  final bool hasMediaCaption;

  const MsgBubbleContent(
      {super.key,
      required this.messageModel,
      required this.hasMedia,
      required this.isSender,
      required this.taggedMsgColor,
      required this.isJustImgOverlay,
      required this.hasMediaCaption});

  @override
  Widget build(BuildContext context) {
    final bool hasTaggedMessage = messageModel.taggedMessageID != null && messageModel.taggedMessageID!.isNotEmpty;
    final bool hasAttachment =
        messageModel.mediaUrl != null && messageModel.mediaUrl!.isNotEmpty && MessageTypeExtension.fromInt(messageModel.mediaType) != MessageType.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasTaggedMessage) BuildTaggedMsgWidget(messageModel: messageModel, taggedMsgColor: taggedMsgColor),
        if (hasAttachment) BuildAttachmentWidget(messageModel: messageModel, isSender: isSender, isJustImgOverlay: isJustImgOverlay),
        if (messageModel.content.isNotEmpty || hasMediaCaption)
          Padding(
            padding: const EdgeInsets.only(left: 6, right: 6),
            child: TimestampedChatMessage(
              expandWidth: hasMedia ? true : false,
                textSpan: TextSpan(
                    text: messageModel.content,
                    style: CustomWidgets.text(context, "", color: Colors.white).style!.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        )),
                sentAt: Padding(
                  padding: const EdgeInsets.only(
                    top: 4,
                  ),
                  child: MsgBubbleContentFunctions.buildDateWidget(context, DateFormat.jm().format(messageModel.sentAt), isSender,
                      deliveredAt: messageModel.deliveredAt, seenAt: messageModel.seenAt),
                )),
          )
      ],
    );
  }
}

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
