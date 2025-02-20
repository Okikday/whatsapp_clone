import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:whatsapp_clone/data/app_data.dart';
import 'package:whatsapp_clone/features/chats/controllers/chat_view_controller.dart';

import 'package:whatsapp_clone/models/message_model.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/msg_bubble/msg_bubble.dart';
import 'package:whatsapp_clone/test_data_folder/test_data/test_chats_data.dart';

class ChatMsgsView extends StatelessWidget {
  final bool isDarkMode;
  final double width;
  final double height;
  final String myUserId;
  final ChatViewController chatViewController;
  const ChatMsgsView(
      {super.key,
      required this.isDarkMode,
      required this.width,
      required this.height,
      required this.chatViewController,
      required this.myUserId});

  @override
  Widget build(BuildContext context) {
    final MessageModel message1 = MessageModel(
      messageId: 'msg_001',
      chatId: 'chat_123',
      myId: 'user_456',
      content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      mediaType: MessageType.text.value,
      sentAt: DateTime.now(),
      deliveredAt: DateTime.now(),
      readAt: null,
      isStarred: false,
      isDeleted: false,
      forwardCount: 0,
    );

    final MessageModel message2 = MessageModel(
      messageId: 'msg_002',
      chatId: 'chat_123',
      myId: 'user_456',
      content: 'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      mediaType: MessageType.text.value,
      sentAt: DateTime.now(),
      deliveredAt: DateTime.now(),
      readAt: DateTime.now(),
      isStarred: true,
      isDeleted: false,
      forwardCount: 1,
    );

    return Expanded(
      child: SizedBox(
        width: width,
        child: CustomScrollView(
          slivers: [
            // const PinnedHeaderSliver(
            //   child: Center(
            //       child: CustomText(
            //     "Date",
            //   )),
            // ),

            // TODO: Add the First chat's header, check disappearing messages, chatting this person for the first time and all that.
            StreamBuilder<List<MessageModel>>(
                stream: AppData.messages.watchMessagesForChat(chatViewController.chatModel.chatId),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return SliverPadding(
                      padding: const EdgeInsetsDirectional.symmetric(vertical: 12),
                      sliver: SliverList.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final MessageModel messageModel = snapshot.data![index];
                            return MsgBubble(
                              messageModel: messageModel,
                              isFirstMsg: index == 3 || index == 0 ? true : false,
                              index: index,
                              isSender: myUserId == messageModel.myId,
                              chatViewController: chatViewController,
                            );
                          }),
                    );
                  } else if (snapshot.connectionState == ConnectionState.active && (snapshot.data == null || snapshot.data!.isEmpty)) {
                    return const SliverToBoxAdapter(child: Center(child: SizedBox(child: CustomText("First Chat"))));
                  } else {
                    return SliverPadding(
                      padding: const EdgeInsetsDirectional.symmetric(vertical: 12),
                      sliver: SliverList.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            final MessageModel message = (index % 2 == 0) ? message1 : message2;

                            if (index % 2 == 0) {
                              return Skeletonizer(
                                enabled: true,
                                child: MsgBubble(
                                  messageModel: message,
                                  isFirstMsg: index == 2 ? false : true,
                                  index: index,
                                  isSender: false,
                                  chatViewController: chatViewController,
                                ),
                              );
                            } else {
                              return Skeletonizer(
                                enabled: true,
                                child: MsgBubble(
                                  bgColor: Colors.grey,
                                  messageModel: message,
                                  isFirstMsg: index == 3 || index == 0 ? true : false,
                                  index: index,
                                  isSender: true,
                                  chatViewController: chatViewController,
                                ),
                              );
                            }
                          }),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
