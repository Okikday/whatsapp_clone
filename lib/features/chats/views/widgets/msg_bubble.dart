import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/widgets/custom_elevated_button.dart';
import 'package:whatsapp_clone/features/chats/use_cases/models/message_model.dart';

class MsgBubble extends StatelessWidget {
  final MessageModel messageModel;
  final bool isFirstMsg; // Whether this is the first message in a group
  final Color? bgColor;
  final bool isSender; // Whether the message is from the sender
  final bool isSelected;
  final void Function()? onLongPressed;

  const MsgBubble({
    super.key,
    required this.messageModel,
    this.isFirstMsg = false,
    this.bgColor,
    required this.isSender,
    this.isSelected = false,
    this.onLongPressed,
  });

  // Factory constructor for receiver message bubble
  factory MsgBubble.receiver({
    Key? key,
    required MessageModel messageModel,
    bool isFirstMsg = false,
    Color? bgColor,
    bool isSelected = false,
    void Function()? onLongPressed,
  }) {
    return MsgBubble(
      key: key,
      messageModel: messageModel,
      isFirstMsg: isFirstMsg,
      bgColor: bgColor,
      isSender: false,
      isSelected: isSelected,
      onLongPressed: onLongPressed,
    );
  }

  // Factory constructor for sender message bubble
  factory MsgBubble.sender({
    Key? key,
    required MessageModel messageModel,
    bool isFirstMsg = false,
    Color? bgColor,
    bool isSelected = false,
    void Function()? onLongPressed,
  }) {
    return MsgBubble(
      key: key,
      messageModel: messageModel,
      isFirstMsg: isFirstMsg,
      bgColor: bgColor,
      isSender: true,
      isSelected: isSelected,
      onLongPressed: onLongPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final splashColor = ValueNotifier<Color>(Colors.transparent);
    final animControl = ValueNotifier<Control>(Control.play);
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool hasMedia = messageModel.mediaUrl != null && messageModel.mediaUrl!.isNotEmpty;

    void onTapDown({Color? color}) {
      splashColor.value = color ?? Colors.white.withAlpha(40);
      animControl.value = Control.playFromStart;
    }

    void onTapUp() {
      Future.delayed(const Duration(milliseconds: 150), () {
        splashColor.value = Colors.transparent;
        animControl.value = Control.playFromStart;
      });
    }

    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTapDown: (details) => onTapDown(),
      onTapUp: (details) => onTapUp(),
      onTapCancel: () => onTapUp(),
      child: CustomElevatedButton(
        backgroundColor: isSelected ? Theme.of(context).primaryColor.withAlpha(60) : Colors.transparent,
        borderRadius: 0,
        contentPadding: EdgeInsets.only(left: isSender ? 0 : 12, right: isSender ? 12 : 0, top: isFirstMsg ? 4 : 2, bottom: 2),
        overlayColor: Theme.of(context).primaryColor.withAlpha(40),
        pixelWidth: MediaQuery.sizeOf(context).width,
        onClick: () {},
        onLongClick: () {
          if (onLongPressed != null) onLongPressed!();
        },
        child: Align(
          alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              // Whole Message box container
              GestureDetector(
                onTapDown: (details) => onTapDown(),
                onTapUp: (details) => onTapUp(),
                onTapCancel: () => onTapUp(),
                onLongPress: () {
                  if (onLongPressed != null) onLongPressed!();
                },
                child: ValueListenableBuilder<Color>(
                  valueListenable: splashColor,
                  builder: (context, value, child) => CustomAnimationBuilder(
                      control: animControl.value,
                      duration: const Duration(milliseconds: 150),
                      tween: ColorTween(
                        begin: Colors.transparent,
                        end: splashColor.value,
                      ),
                      builder: (context, value, child) {
                        return CustomPaint(
                          foregroundPainter:
                              BubblePainter(isSender: isSender, backgroundColor: value ?? Colors.transparent, showTail: isFirstMsg, canRepaint: true),
                          painter: BubblePainter(isSender: isSender, backgroundColor: bgColor ?? WhatsAppColors.accent, showTail: isFirstMsg),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: hasMedia ? screenWidth * 0.7 : screenWidth * 0.8),
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: 6,
                                    right: 6,
                                    top: 6,
                                    bottom: hasMedia && (messageModel.mediaCaption == null || messageModel.mediaCaption!.isEmpty) ? 6 : 16),
                                child: MsgBubbleContent(
                                  hasMedia: hasMedia,
                                  messageModel: messageModel,
                                )),
                          ),
                        );
                      }),
                ),
              ),

              // Overlay of Date part
              Positioned.fill(
                right: messageModel.mediaCaption != null && messageModel.mediaCaption!.isNotEmpty ? 6 : 8,
                bottom: messageModel.mediaCaption != null && messageModel.mediaCaption!.isNotEmpty ? 0 : 6,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                    decoration: hasMedia && (messageModel.mediaCaption == null || messageModel.mediaCaption!.isEmpty)
                        ? BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withAlpha(85), blurRadius: 6, spreadRadius: 4, offset: Offset.zero)])
                        : null,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 6),
                        // Shows time message was sent
                        CustomWidgets.text(context, DateFormat.jm().format(messageModel.sentAt),
                            fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white70),

                        if (isSender)
                          const SizedBox(
                            width: 2,
                          ),

                        // Shows message delivered and sort
                        if (isSender)
                          Icon(
                            _getStatusIcon(messageModel.deliveredAt != null
                                ? MsgStatus.delivered
                                : messageModel.readAt != null
                                    ? MsgStatus.read
                                    : MsgStatus.loading),
                            size: 12,
                            color: Colors.white70,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getStatusIcon(MsgStatus status) {
    switch (status) {
      case MsgStatus.delivered:
        return Icons.done_all;
      case MsgStatus.offline:
        return Icons.schedule;
      case MsgStatus.read:
        return Icons.done_all;
      case MsgStatus.loading:
        return Icons.access_time;
    }
  }
}

class MsgBubbleContent extends StatelessWidget {
  final bool hasMedia;
  final MessageModel messageModel;
  const MsgBubbleContent({super.key, required this.hasMedia, required this.messageModel});

  @override
  Widget build(BuildContext context) {
    if (!hasMedia) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          children: [
            if (messageModel.taggedMessageID != null) _buildTaggedMessageWidget(context, messageModel: messageModel),
            Expanded(
              child: CustomWidgets.text(
                context,
                messageModel.content,
                fontSize: 16,
                color: Colors.white,
                height: 1.1,
              ),
            ),
          ],
        ),
      );
    } else {
      return Column(
        spacing: 8,
        children: [
          if (messageModel.taggedMessageID != null) _buildTaggedMessageWidget(context, messageModel: messageModel),
          _buildAttachmentWidget(messageModel),
          if (messageModel.mediaCaption != null && messageModel.mediaCaption!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: CustomWidgets.text(
                context,
                messageModel.mediaCaption,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                height: 1.1,
              ),
            )
        ],
      );
    }
  }
}

Widget _buildTaggedMessageWidget(BuildContext context, {required MessageModel messageModel}) {
  return SizedBox(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 120),
            child: const SizedBox(
              width: 20,
              height: 120,
              child: ColoredBox(color: Colors.deepPurpleAccent),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 6,
              children: [
                CustomWidgets.text(
                  context,
                  messageModel.content,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.deepPurpleAccent,
                ),
                CustomWidgets.text(
                  context,
                  messageModel.content,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withAlpha(125),
                  height: 1.1,
                ),
              ],
            ),
          ),
          const Icon(
            Icons.image,
            size: 100,
          ),
        ],
      ),
    ),
  );
}

Widget _buildAttachmentWidget(MessageModel messageModel) {
  return ClipRRect(
    clipBehavior: Clip.hardEdge,
    borderRadius: BorderRadius.circular(6),
    child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () {},
        child: ImageFiltered(
          imageFilter: ColorFilter.mode(Colors.black.withAlpha(40), BlendMode.colorBurn),
          child: CachedNetworkImage(
            imageUrl: messageModel.mediaUrl!,
            fit: BoxFit.fitWidth,
          ),
        )),
  );
}

// CustomPainter for drawing the bubble with color fill
class BubblePainter extends CustomPainter {
  final bool isSender;
  final Color backgroundColor;
  final bool showTail;
  final bool canRepaint;
  BubblePainter({this.isSender = false, required this.backgroundColor, required this.showTail, this.canRepaint = false});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    final Path path = Path();
    const double tailHeight = 12.0;
    const double tailWidth = 6.0;
    const double borderRadius = 12.0;

    if (isSender) {
      path.addRRect(RRect.fromLTRBAndCorners(
        0,
        0,
        size.width,
        size.height,
        topLeft: const Radius.circular(borderRadius),
        topRight: Radius.circular(showTail ? 0 : borderRadius),
        bottomLeft: const Radius.circular(borderRadius),
        bottomRight: const Radius.circular(borderRadius),
      ));
      if (showTail) {
        path.moveTo(size.width + tailWidth - 2, 0);
        path.lineTo(size.width, 0);
        path.lineTo(size.width, tailHeight);
        path.lineTo(size.width + tailWidth - 2, tailWidth);
        path.quadraticBezierTo(size.width + tailWidth + 1, tailWidth / 2, size.width + tailWidth - 2, 0);
      }
    } else {
      path.addRRect(RRect.fromLTRBAndCorners(
        0,
        0,
        size.width,
        size.height,
        topRight: const Radius.circular(borderRadius),
        topLeft: Radius.circular(showTail ? 0 : borderRadius),
        bottomLeft: const Radius.circular(borderRadius),
        bottomRight: const Radius.circular(borderRadius),
      ));
      if (showTail) {
        path.moveTo(-tailWidth + 2, 0); // Start of the tail on the left
        path.lineTo(0, 0); // Top-left corner
        path.lineTo(0, tailHeight); // Down along the left edge
        path.lineTo(-tailWidth + 2, tailWidth); // Diagonal line for the tail
        path.quadraticBezierTo(-tailWidth - 1, tailWidth / 2, -tailWidth + 2, 0); // Rounded curve
      }
    }

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return canRepaint;
  }
}
