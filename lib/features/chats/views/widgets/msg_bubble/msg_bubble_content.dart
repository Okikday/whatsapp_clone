import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:whatsapp_clone/common/utilities/utilities_funcs.dart';
import 'package:whatsapp_clone/features/chats/controllers/chat_view_controller.dart';
import 'package:whatsapp_clone/features/chats/use_cases/functions/msg_bubble_use_cases.dart';
import 'package:whatsapp_clone/features/chats/use_cases/functions/msg_bubble_functions.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/msg_bubble/timestamped_chat_message.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/msg_bubble/build_attachment_widget.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/msg_bubble/build_tagged_msg_widget.dart';
import 'package:whatsapp_clone/models/message_model.dart';

class MsgBubbleContent extends StatelessWidget {
  final ChatViewController chatViewController;
  final MessageModel messageModel;
  final bool hasMedia;
  final bool isSender;
  final Color taggedMsgColor;
  final String messageId;
  final int index;

  const MsgBubbleContent({
    super.key,
    required this.messageModel,
    required this.hasMedia,
    required this.isSender,
    required this.taggedMsgColor,
    required this.messageId,
    required this.index,
    required this.chatViewController,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = appUiState.isDarkMode.value;
    final Color sentAtTextColor = isSender
        ? (isDarkMode ? const Color(0xFF93B28F) : WhatsAppColors.gray)
        : isDarkMode
        ? WhatsAppColors.gray
        : WhatsAppColors.gray;
    final TextStyle msgContentStyle = const CustomText("").effectiveStyle(context).copyWith(
      fontSize: 17,
    );
    final bool hasTaggedMessage = messageModel.taggedMessageId != null && messageModel.taggedMessageId!.isNotEmpty;
    final bool hasAttachment = messageModel.mediaUrl != null &&
        messageModel.mediaUrl!.isNotEmpty &&
        messageModel.messageType != MessageType.text;
    final bool hasMedia = messageModel.mediaUrl != null && messageModel.mediaUrl!.isNotEmpty;
    final bool hasMediaCaption = hasMedia && messageModel.content.isNotEmpty;
    final bool isJustImgOverlay = hasMedia && messageModel.messageType != MessageType.text && !hasMediaCaption;
    final TextStyle sentAtStyle = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: sentAtTextColor,
    );
    final String? dateText = messageModel.sentAt != null ? DateFormat.jm().format(messageModel.sentAt!) : null;
    final double sentAtWidth = MsgBubbleUseCases.calcSentAtWidth(dateText ?? "", isSender, sentAtStyle) + 2 + 8;
    double taggedMsgWidth = hasMedia
        ? appUiState.deviceWidth * 0.7
        : sentAtWidth + UtilitiesFuncs.getTextSize(messageModel.content, msgContentStyle, maxLines: 1).width + 12.0;
    if (hasMedia) taggedMsgWidth = appUiState.deviceWidth.value * 0.7;

    // TODO: Subject to change depending on who's tagged
    final Color taggedNameColor = isDarkMode
        ? (isSender ? const Color(0xFFB3B6DD) : const Color(0xFF84C6A2))
        : (isSender ? const Color(0xFF5D608C) : const Color(0xFF43765F));
    final Color taggedAccentColor = isDarkMode
        ? (isSender ? const Color(0xFFA790FD) : const Color(0xFF22C062))
        : (isSender ? const Color(0xFF1EAA61) : const Color(0xFF1CAB5F));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasTaggedMessage)
          BuildTaggedMsgWidget(
            chatViewController: chatViewController,
            index: index,
            taggedUserName: "Someone",
            taggedMsgContent: messageModel.content,
            hasMedia: false,
            mediaUrl: messageModel.mediaUrl,
            taggedMsgColor: taggedMsgColor,
            isDarkMode: isDarkMode,
            width: taggedMsgWidth,
            taggedAccentColor: taggedAccentColor,
            taggedNameColor: taggedNameColor,
          ),
        if (hasAttachment)
          BuildAttachmentWidget(
            chatViewController: chatViewController,
            msgType: messageModel.messageType,
            mediaUrl: messageModel.mediaUrl!,
            messageId: messageModel.messageId,
            isSender: isSender,
            isJustImgOverlay: isJustImgOverlay,
            chatName: "Someone",
            dateWidget: isJustImgOverlay
                ? DecoratedBox(
              decoration: BoxDecoration(boxShadow: [BoxShadow(blurRadius: 8, color: isSender ? Colors.black54 : Colors.white38)]),
              child: BuildTimeStampWidget(
                date: dateText,
                isSender: isSender,
                deliveredAt: messageModel.deliveredAt,
                sentAtWidth: sentAtWidth,
                sentAtStyle: sentAtStyle,
                iconColor: sentAtTextColor,
              ),
            )
                : null,
          ),
        if (messageModel.content.isNotEmpty || hasMediaCaption)
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 6),
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
                  left: 6,
                ),
                child: BuildTimeStampWidget(
                  date: dateText,
                  isSender: isSender,
                  deliveredAt: messageModel.deliveredAt,
                  sentAtWidth: sentAtWidth,
                  sentAtStyle: sentAtStyle,
                  iconColor: sentAtTextColor,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class BuildTimeStampWidget extends StatelessWidget {
  final String? date;
  final bool isSender;
  final DateTime? deliveredAt;
  final DateTime? readAt;
  final TextStyle sentAtStyle;
  final double sentAtWidth;
  final double iconSize;
  final Color iconColor;
  const BuildTimeStampWidget({
    super.key,
    required this.date,
    required this.isSender,
    this.deliveredAt,
    this.readAt,
    required this.sentAtWidth,
    this.iconSize = 16,
    required this.sentAtStyle,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final CustomText dateText = CustomText(
      date ?? "",
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
              MsgBubbleUseCases.getMsgStatusIcon(
                  readAt != null
                      ? MsgStatus.read
                      : (deliveredAt != null ? MsgStatus.delivered : (date != null ? MsgStatus.offline : MsgStatus.loading)),
                  size: iconSize,
                  iconColor: iconColor)
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