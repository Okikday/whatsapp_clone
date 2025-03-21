import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/utilities/formatter.dart';
import 'package:whatsapp_clone/data/app_data.dart';
import 'package:whatsapp_clone/features/chats/controllers/chat_view_controller.dart';

import 'package:whatsapp_clone/features/chats/views/widgets/msg_bubble/msg_bubble.dart';


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
                stream: AppData.messages.watchMessagesForChat(chatViewController.chatModel.chatId, ascending: true),
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
                    return SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          DecoratedBox(
                            decoration: BoxDecoration(
                                color: isDarkMode ? WhatsAppColors.darkGray : WhatsAppColors.background,
                                borderRadius: BorderRadius.circular(4.0)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8.0),
                              child: CustomText(
                                chatViewController.chatModel.creationTime != null
                                    ? Formatter.chatDate(chatViewController.chatModel.creationTime!)
                                    : Formatter.chatDate(DateTime.now()),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDarkMode ? WhatsAppColors.darkTextSecondary : WhatsAppColors.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 36),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: isDarkMode ? WhatsAppColors.darkGray : WhatsAppColors.background,
                                  borderRadius: BorderRadius.circular(6.0)),
                              // lock icon displayed before
                              child: Material(
                                type: MaterialType.transparency,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(6.0),
                                  onTap: () {},
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                                      child: CustomRichText(textAlign: TextAlign.center, children: [
                                        const WidgetSpan(
                                          child: Icon(
                                            Icons.lock_outline_rounded,
                                            size: 14,
                                            color: Color(0xFFAD9E7B),
                                          ),
                                        ),
                                        CustomTextSpanData(
                                          " Messages and calls are end-to-end-encrypted. No one outside this chat, not even WhatsApp clone, can read or listen to them. Tap to learn more",
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFFAD9E7B),
                                        )
                                      ])),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    final MessageModel message1 = MessageModel(
                      messageId: 'msg_001',
                      chatId: 'chat_123',
                      myId: 'user_456',
                      content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit./n/n',
                      messageType: MessageType.text,
                      sentAt: DateTime.now(),
                      deliveredAt: DateTime.now(),
                      readAt: null,
                      sentTime: DateTime.now(),
                    );

                    final MessageModel message2 = MessageModel(
                      messageId: 'msg_002',
                      chatId: 'chat_123',
                      myId: 'user_456',
                      content: 'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua./n/n',
                      messageType: MessageType.text,
                      sentAt: DateTime.now(),
                      deliveredAt: DateTime.now(),
                      readAt: DateTime.now(),
                      sentTime: DateTime.now(),
                    );
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