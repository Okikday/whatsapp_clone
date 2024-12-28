import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
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

  const MsgBubble({
    super.key,
    required this.messageModel,
    this.isFirstMsg = false,
    this.bgColor,
    required this.isSender,
  });

  // Factory constructor for receiver message bubble
  factory MsgBubble.receiver({
    Key? key,
    required MessageModel messageModel,
    bool isFirstMsg = false,
    Color? bgColor,
  }) {
    return MsgBubble(
      key: key,
      messageModel: messageModel,
      isFirstMsg: isFirstMsg,
      bgColor: bgColor,
      isSender: false,
    );
  }

  // Factory constructor for sender message bubble
  factory MsgBubble.sender({
    Key? key,
    required MessageModel messageModel,
    bool isFirstMsg = false,
    Color? bgColor,
  }) {
    return MsgBubble(
      key: key,
      messageModel: messageModel,
      isFirstMsg: isFirstMsg,
      bgColor: bgColor,
      isSender: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: WhatsAppColors.primary.withAlpha(50),
      onTap: () {},
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Align(
          alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: isSender ? 0 : 12, right: isSender ? 12 : 0, top: 12),
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                // Whole Message box container
                CustomPaint(
                  painter: BubblePainter(isSender: isSender, backgroundColor: bgColor ?? WhatsAppColors.accent),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.8),
                    padding: const EdgeInsets.only(left: 12, right: 24, top: 8, bottom: 8),
                    // Message text
                    child: CustomWidgets.text(
                      context,
                      messageModel.content,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
    
                // Overlay of Date part
                Positioned.fill(
                  right: isFirstMsg && isSender ? 14 : 8,
                  bottom: 2,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Shows time message was sent
                        CustomWidgets.text(
                          context,
                          DateFormat.jm().format(messageModel.sentAt),
                          fontSize: 11, 
                          fontWeight: FontWeight.w500,
                          color: Colors.white70
                        ),
    
                        if(isSender) const SizedBox(width: 2,),
                        // Shows message delivered and sort
                        if (isSender)
                          Icon(
                            _getStatusIcon(messageModel.deliveredAt != null ? MsgStatus.delivered : messageModel.readAt != null ? MsgStatus.read : MsgStatus.loading),
                            size: 12,
                            color: Colors.white70,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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

// CustomPainter for drawing the bubble with color fill
class BubblePainter extends CustomPainter {
  final bool isSender;
  final Color backgroundColor;

  BubblePainter({this.isSender = false, this.backgroundColor = Colors.yellow});

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
        bottomLeft: const Radius.circular(borderRadius),
        bottomRight: const Radius.circular(borderRadius),
      ));
      path.moveTo(size.width + tailWidth - 2, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, tailHeight);
      path.lineTo(size.width + tailWidth - 2, tailWidth);
      path.quadraticBezierTo(size.width + tailWidth + 1, tailWidth / 2, size.width + tailWidth - 2, 0);
    } else {
      path.addRRect(RRect.fromLTRBAndCorners(
        0,
        0,
        size.width,
        size.height,
        topRight: const Radius.circular(borderRadius),
        bottomLeft: const Radius.circular(borderRadius),
        bottomRight: const Radius.circular(borderRadius),
      ));
      path.moveTo(-tailWidth + 2, 0); // Start of the tail on the left
      path.lineTo(0, 0); // Top-left corner
      path.lineTo(0, tailHeight); // Down along the left edge
      path.lineTo(-tailWidth + 2, tailWidth); // Diagonal line for the tail
      path.quadraticBezierTo(-tailWidth - 1, tailWidth / 2, -tailWidth + 2, 0); // Rounded curve
    }

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

enum MsgStatus {
  delivered,
  offline,
  read,
  loading,
}
