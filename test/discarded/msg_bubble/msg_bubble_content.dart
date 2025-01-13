
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/widgets/custom_elevated_button.dart';
import 'package:whatsapp_clone/features/chats/use_cases/models/message_model.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/msg_bubble/msg_bubble_functions.dart';

class MsgBubbleContent extends StatelessWidget {
  final MessageModel messageModel;
  final bool hasMedia;
  final bool doesTextHasSpaceLeft;
  final Text messageContent;
  final Text dateContent;
  final bool isSender;
  final double dateContentWidth;
  final Color taggedMsgColor;
  final bool isJustImgOverlay;
  final bool hasMediaCaption;

  const MsgBubbleContent({
      super.key,
      required this.messageModel,
      required this.hasMedia,
      required this.doesTextHasSpaceLeft,
      required this.dateContent,
      required this.messageContent,
      required this.isSender,
      required this.dateContentWidth,
      required this.taggedMsgColor,
      required this.isJustImgOverlay,
      required this.hasMediaCaption
    });

  @override
  Widget build(BuildContext context) {
    final bool hasTaggedMessage = messageModel.taggedMessageID != null && messageModel.taggedMessageID!.isNotEmpty;
    final bool hasAttachment =
        messageModel.mediaUrl != null && messageModel.mediaUrl!.isNotEmpty && MessageTypeExtension.fromInt(messageModel.mediaType) != MessageType.text;

    // if (!hasMedia) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasTaggedMessage) BuildTaggedMsgWidget(messageModel: messageModel, taggedMsgColor: taggedMsgColor),
        if (hasAttachment) BuildAttachmentWidget(messageModel: messageModel, messageContent: messageContent, isSender: isSender, isJustImgOverlay: isJustImgOverlay),
        if(messageModel.content.isNotEmpty || hasMediaCaption)
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                alignment: WrapAlignment.end,
                spacing: 6.0, // Add spacing between elements if needed
                children: [
                  messageContent,
                  Transform.translate(
                    offset: doesTextHasSpaceLeft ? const Offset(0, -12) : Offset.zero,
                    child: SizedBox(
                      width: isSender ? dateContentWidth + 16 : dateContentWidth + 4,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 2,
                        children: [
                          CustomWidgets.text(
                            context,
                            "1:22AM",
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                          if(isSender)
                          MsgBubbleFunctions.getMsgStatusIcon(messageModel.seenAt != null
                              ? MsgStatus.read
                              : messageModel.deliveredAt != null
                                  ? MsgStatus.delivered
                                  : MsgStatus.offline)
                        ],
                      ),
                    ),
                  ),
                ],
              ))
      ],
    );
    // }

    //  else {
    //   return Column(
    //     spacing: 8,
    //     children: [
    //       if (messageModel.taggedMessageID != null) _buildTaggedMessageWidget(context, messageModel: messageModel),
    //       _buildAttachmentWidget(messageModel),
    //       if (messageModel.mediaCaption != null && messageModel.mediaCaption!.isNotEmpty)
    //         Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 6),
    //           child: CustomWidgets.text(
    //             context,
    //             messageModel.mediaCaption,
    //             fontSize: 16,
    //             fontWeight: FontWeight.w500,
    //             color: Colors.white,
    //             height: 1.1,
    //           ),
    //         )
    //     ],
    //   );
    // }
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
          key: _widgetKey, // Assign the GlobalKey to the widget
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
  final Text messageContent;
  final bool isSender;
  final bool isJustImgOverlay;
  const BuildAttachmentWidget({super.key, required this.messageModel, required this.messageContent, required this.isSender, required this.isJustImgOverlay});

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
