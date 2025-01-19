import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/features/chats/use_cases/models/message_model.dart';

class BuildAttachmentWidget extends StatelessWidget {
  final MessageType msgType;
  final String mediaUrl;
  final bool isSender;
  final bool isJustImgOverlay;
  const BuildAttachmentWidget({super.key, required this.msgType, required this.isSender, required this.isJustImgOverlay, required this.mediaUrl});

  @override
  Widget build(BuildContext context) {
    

    if (msgType == MessageType.image) {
      // Return Image Attachment
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(width: 6, color: Colors.black26),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(0.5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {},
                  child: CachedNetworkImage(
                    imageUrl: mediaUrl,
                    fit: BoxFit.fitWidth,
                    memCacheWidth: (appUiState.deviceWidth.value * 0.7).truncate(),
                  )),
            ),
          ),
        ),
      );
    } else if (msgType == MessageType.document) {
      return SizedBox(
        child: CustomWidgets.text(context, "Attachment"),
      );
    } else if (msgType == MessageType.video) {
      return SizedBox(
        child: CustomWidgets.text(context, "Attachment"),
      );
    } else if (msgType == MessageType.link) {
      return SizedBox(
        child: CustomWidgets.text(context, "Attachment"),
      );
    } else {
      return SizedBox(
        child: CustomWidgets.text(context, "Attachment"),
      );
    }
  }
}
