
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';

import 'package:whatsapp_clone/features/chats/use_cases/models/message_model.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/msg_bubble/msg_bubble.dart';

class ChatMsgsView extends StatelessWidget {
  final bool isDarkMode;
  final List<MessageModel> messageModels;
  final double width;
  final double height;
  const ChatMsgsView({
    super.key,
    required this.isDarkMode,
    required this.messageModels,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final List<MessageModel> mockMessageModels = [
      messageModels.first,
      MessageModel.fromMap({...messageModels.first.toMap(), 'messageId': "dup_${messageModels.first.messageId}"}),
      MessageModel.fromMap({...messageModels.first.toMap(), 'messageId': "dup1_${messageModels.first.messageId}"}),
      MessageModel.fromMap({...messageModels.first.toMap(), 'messageId': "dup2_${messageModels.first.messageId}"}),
      MessageModel.fromMap({...messageModels.first.toMap(), 'messageId': "dup3_${messageModels.first.messageId}"}),
      MessageModel.fromMap({...messageModels.first.toMap(), 'messageId': "dup4_${messageModels.first.messageId}"})
    ];
    return Expanded(
      child: SizedBox(
        width: width,
        child: CustomScrollView(
          slivers: [
            const PinnedHeaderSliver(child: Center(child: CustomText("Date",)),),
            SliverList.builder(
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
          ],
        ),
      ),
    );
  }
}

