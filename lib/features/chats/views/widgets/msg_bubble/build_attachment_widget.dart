import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroine/heroine.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:whatsapp_clone/features/chats/controllers/chat_view_controller.dart';
import 'package:whatsapp_clone/features/chats/use_cases/models/message_model.dart';
import 'package:whatsapp_clone/features/chats/views/sub_views/expand_image_view.dart';

class BuildAttachmentWidget extends StatelessWidget {
  final MessageType msgType;
  final String mediaUrl;
  final bool isSender;
  final bool isJustImgOverlay;
  final String messageId;
  final String chatName;
  const BuildAttachmentWidget({super.key, required this.msgType, required this.isSender, required this.isJustImgOverlay, required this.mediaUrl, required this.messageId, required this.chatName});

  @override
  Widget build(BuildContext context) {
    

    if (msgType == MessageType.image) {
      // Return Image Attachment
      return Padding(
        padding: EdgeInsets.only(bottom: isJustImgOverlay ? 0 : 8),
        child: Heroine(
          tag: "msg_bubble_attachment_image$messageId",
          spring: Spring.snappy,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(width: 6, color: Colors.black26),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(0.5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Material(
                  child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: chatViewController.chatsSelected.isNotEmpty ? null : () {
                        if(chatViewController.chatsSelected.isEmpty){
                          Get.to(() => ExpandImageView(imageUrl: mediaUrl, messageId: messageId, chatName: chatName, ), transition: Transition.fade);
                        }
                      },
                      child: CachedNetworkImage(
                        imageUrl: mediaUrl,
                        fit: BoxFit.fitWidth,
                        memCacheWidth: (appUiState.deviceWidth.value * 0.7).truncate(),
                      )),
                ),
              ),
            ),
          ),
        ),
      );
    } else if (msgType == MessageType.document) {
      return const SizedBox(
        child: CustomText("Attachment"),
      );
    } else if (msgType == MessageType.video) {
      return const SizedBox(
        child: CustomText("Attachment"),
      );
    } else if (msgType == MessageType.link) {
      return const SizedBox(
        child: CustomText("Attachment"),
      );
    } else {
      return const SizedBox(
        child: CustomText("Attachment"),
      );
    }
  }
}
