
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/features/chats/controllers/chat_view_controller.dart';
import 'package:whatsapp_clone/features/chats/use_cases/models/message_model.dart';
import 'package:whatsapp_clone/features/chats/use_cases/functions/msg_bubble_functions.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/msg_bubble/msg_bubble_content.dart';

class MsgBubble extends StatelessWidget {
  final MessageModel messageModel;
  final bool isFirstMsg; // Whether this is the first message in a group
  final Color? bgColor;
  final Color? taggedMsgColor;
  final bool isSender; // Whether the message is from the sender
  final int index;

  const MsgBubble({
    super.key,
    required this.messageModel,
    this.isFirstMsg = false,
    this.bgColor,
    this.taggedMsgColor,
    required this.isSender,
    required this.index,
  });

  // Factory constructor for receiver message bubble
  factory MsgBubble.receiver({
    Key? key,
    required MessageModel messageModel,
    bool isFirstMsg = false,
    Color? bgColor,
    Color? taggedMsgColor,
    required int index,
  }) {
    return MsgBubble(
      key: key,
      messageModel: messageModel,
      isFirstMsg: isFirstMsg,
      bgColor: bgColor,
      taggedMsgColor: taggedMsgColor,
      isSender: false,
      index: index,
    );
  }

  // Factory constructor for sender message bubble
  factory MsgBubble.sender({
    Key? key,
    required MessageModel messageModel,
    bool isFirstMsg = false,
    Color? bgColor,
    Color? taggedMsgColor,
    bool isSelected = false,
    required int index,
  }) {
    return MsgBubble(
      key: key,
      messageModel: messageModel,
      isFirstMsg: isFirstMsg,
      bgColor: bgColor,
      taggedMsgColor: taggedMsgColor,
      isSender: true,
      index: index,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final int? selectedIndex = chatViewController.chatsSelected[index];
        return SizedBox(
        width: appUiState.deviceWidth.value,
        child: Material(
          color: selectedIndex != null ? Theme.of(context).primaryColor.withAlpha(50) : Colors.transparent,
          surfaceTintColor: selectedIndex != null ? Colors.white : Colors.transparent,
          child: InkWell(
            overlayColor: WidgetStatePropertyAll(Theme.of(context).primaryColor.withAlpha(40)),
                  onTap: () {
                    MsgBubbleFunctions.onTapBubble(index);
                  },
                  onLongPress: () {
                    MsgBubbleFunctions.onLongPress(index);
                  },
            child: AnimatedAlign(
              duration: Durations.medium3,
              alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
              child: Obx(
                () {
                  final double width = appUiState.deviceWidth.value;
                  // final double height = appUiState.deviceHeight.value;
                  final bool isDarkMode = appUiState.isDarkMode.value;
                  final bool hasMedia = messageModel.mediaUrl != null && messageModel.mediaUrl!.isNotEmpty;
                  final Color bubbleBgColor = isDarkMode ? (isSender ? WhatsAppColors.msgSentDark : WhatsAppColors.msgReceivedDark) : (isSender ? WhatsAppColors.msgSent : WhatsAppColors.msgReceived);
                  final Color taggedMsgColor = isDarkMode ? (isSender ? WhatsAppColors.taggedMsgSentDark : WhatsAppColors.taggedMsgReceivedDark) : (isSender ? WhatsAppColors.taggedMsgSent : WhatsAppColors.taggedMsgReceived);
                  
                  return ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: hasMedia ? width * 0.7 : width * 0.85),
                    child: Animate(
                      effects: [FadeEffect(begin: selectedIndex != null ? 0.8 : 1.0, end: selectedIndex != null ? 0.8 : 1.0,)],
                      child: Bubble(
                          showNip: true,
                          stick: true,
                          nip: isFirstMsg ? (isSender ? BubbleNip.rightTop : BubbleNip.leftTop) : BubbleNip.no,
                          nipHeight: 12,
                          nipWidth: 10,
                          nipRadius: 2,
                          padding: const BubbleEdges.fromLTRB(4, 4, 4, 4),
                          margin: BubbleEdges.only(left: isSender ? 0 : 10, right: isSender ? 10 : 0, top: isFirstMsg ? 4 : 2, bottom: isFirstMsg ? 4 : 2),
                          radius: const Radius.circular(10),
                          color: selectedIndex != null ? bubbleBgColor : bubbleBgColor,
                          shadowColor: isDarkMode ? Colors.white10 : Colors.black12,
                          child: MsgBubbleContent(
                              messageModel: messageModel,
                              hasMedia: hasMedia,
                              isSender: isSender,
                              messageId: messageModel.messageId,
                              taggedMsgColor: taggedMsgColor,
                              index: index,
                              )),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
              );
      },
    );
  }
}

/*

hasMedia && (messageModel.mediaCaption == null || messageModel.mediaCaption!.isEmpty)
                        ? BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withAlpha(85), blurRadius: 6, spreadRadius: 4, offset: Offset.zero)])
                        */




/*

class BubblePainter extends CustomPainter {
  final bool isSender;
  final Color backgroundColor;
  final bool showTail;
  final bool canRepaint;
  final bool doesTextHasSpaceLeft;
  BubblePainter({this.isSender = false, required this.backgroundColor, required this.showTail, this.canRepaint = false, required this.doesTextHasSpaceLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    final Path path = Path();
    const double tailHeight = 12.0;
    const double tailWidth = 6.0;
    const double borderRadius = 12.0;
    final double adjustedHeight = doesTextHasSpaceLeft ? size.height - 12 : size.height;

    if (isSender) {
      path.addRRect(RRect.fromLTRBAndCorners(
        0,
        0,
        size.width,
        adjustedHeight,
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
        adjustedHeight,
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
*/