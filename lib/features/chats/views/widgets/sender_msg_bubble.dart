import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';

class SenderMsgBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isFirstMsg; // Whether this is the first message in a group
  final Color? bgColor;
  final MsgStatus status;

  const SenderMsgBubble({super.key, required this.message, required this.time, this.isFirstMsg = false, this.bgColor, required this.status});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Whole Message box container
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.8),
            clipBehavior: Clip.hardEdge,
            margin: isFirstMsg ? const EdgeInsets.only(right: 8) : null,
            padding: const EdgeInsets.only(left: 12, right: 24, top: 8, bottom: 20),
            decoration: BoxDecoration(
              color: bgColor ?? Colors.white,
              borderRadius: BorderRadius.only(
                topRight: isFirstMsg ? Radius.zero : const Radius.circular(12),
                topLeft: const Radius.circular(12),
                bottomRight: const Radius.circular(12),
                bottomLeft: const Radius.circular(12),
              ),
            ),
            child: CustomWidgets.text(
              context,
              message,
              fontSize: 16,
            ),
          ),

          // Overlay of Date part
          Positioned.fill(
              right: isFirstMsg ? 14 : 8,
              bottom: 2,
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Shows time message was sent
                      Text(
                        time,
                        style: const TextStyle(fontSize: 10, color: Colors.white70),
                      ),

                      //Shows message delivered and sort
                    ],
                  ))),

          // Will show the corner shape if the message is the first in a group of other messages
          if (isFirstMsg)
            Positioned(
              right: 0,
              top: 0,
              width: 10,
              height: 10,
              child: SvgPicture.asset(
                SvgStrings.msgBubbleCornerRight,
                colorFilter: ColorFilter.mode(bgColor ?? Colors.white, BlendMode.srcIn),
              ),
            ),
        ],
      ),
    );
  }
}

enum MsgStatus {
  delivered,
  offline,
  read,
  loading,
}
