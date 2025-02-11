
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';

import 'package:whatsapp_clone/models/message_model.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/msg_bubble/msg_bubble.dart';

class ChatMsgsView extends StatelessWidget {
  final bool isDarkMode;
  final double width;
  final double height;
  const ChatMsgsView({
    super.key,
    required this.isDarkMode,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final List<MessageModel> mockMessageModels = [

    ];
    return Expanded(
      child: SizedBox(
        width: width,
        child: CustomScrollView(
          slivers: [
            const PinnedHeaderSliver(child: Center(child: CustomText("Date",)),),
            SliverPadding(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 12),
              sliver: SliverList.builder(
                  itemCount: mockMessageModels.length,
                  itemBuilder: (context, index) {
                    final MessageModel currMsgModel = mockMessageModels[index];

                    return index == 1 || index == 2
                        ? MsgBubble.receiver(
                            messageModel: currMsgModel,
                            isFirstMsg: index == 2 ? false : true,
                            index: index,
                          )
                        : MsgBubble.sender(
                            messageModel: currMsgModel,
                            isFirstMsg: index == 3 || index == 0 ? true : false,
                            index: index,
                          );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

