import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';

class ReceiverMsgBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isFirstMsg; // Whether this is the first message in a group

  const ReceiverMsgBubble({
    super.key,
    required this.message,
    required this.time,
    this.isFirstMsg = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, top: 5, right: 50, bottom: 5),
      child: Row(
        children: [
          SvgPicture.asset(SvgStrings.msgBubbleCorner1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: isFirstMsg
                  ? null // No default borderRadius when clipping
                  : const BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      topLeft: Radius.circular(0),
                      bottomLeft: Radius.circular(15),
                    ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
