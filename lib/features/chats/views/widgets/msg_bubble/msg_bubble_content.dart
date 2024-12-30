import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/widgets/custom_elevated_button.dart';
import 'package:whatsapp_clone/features/chats/use_cases/models/message_model.dart';

class MsgBubbleContent extends StatelessWidget {
  final MessageModel messageModel;
  const MsgBubbleContent({super.key, required this.messageModel});

  @override
  Widget build(BuildContext context) {
    // if (!hasMedia) {
    return Column(
      spacing: 6,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (messageModel.taggedMessageID != null) BuildTaggedMsgWidget(messageModel: messageModel),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: CustomWidgets.text(
            context,
            messageModel.content,
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            height: 1.1,
          ),
        ),
      ],
    );
    // }

    //  else {
    //   return Column(
    //     spacing: 8,
    //     children: [
    //       if (messageModel.taggedMessageID != null) _buildTaggedMessageWidget(context, messageModel: messageModel),
    //       _buildAttachmentWidget(messageModel),
    //       if (messageModel.mediaCaption != null && messageModel.mediaCaption!.isNotEmpty)
    //         Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 6),
    //           child: CustomWidgets.text(
    //             context,
    //             messageModel.mediaCaption,
    //             fontSize: 16,
    //             fontWeight: FontWeight.w500,
    //             color: Colors.white,
    //             height: 1.1,
    //           ),
    //         )
    //     ],
    //   );
    // }
  }
}



class BuildTaggedMsgWidget extends StatefulWidget {
  final MessageModel messageModel;
  final Color accentColor;
  const BuildTaggedMsgWidget({super.key, required this.messageModel, this.accentColor = const Color(0xFFA791F9)});

  @override
  State<BuildTaggedMsgWidget> createState() => _BuildTaggedMsgWidgetState();
}

class _BuildTaggedMsgWidgetState extends State<BuildTaggedMsgWidget> {
  Size? widgetSize;
  final GlobalKey _widgetKey = GlobalKey();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _calculateSize();
  }

  void _calculateSize() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_widgetKey.currentContext != null) {
        final RenderBox renderBox = _widgetKey.currentContext!.findRenderObject() as RenderBox;
        final newSize = renderBox.size;
        if (widgetSize != newSize) {
          setState(() {
            widgetSize = newSize;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _calculateSize();
    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(12),
      child: CustomElevatedButton(
        key: _widgetKey, // Assign the GlobalKey to the widget
        backgroundColor: WhatsAppColors.accentCompliment1,
        borderRadius: 0,
        overlayColor: Colors.white24,
        onClick: () {
          
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            SizedBox(width: 6,
              height: widgetSize?.height ?? 8, child: ColoredBox(color: widget.accentColor),),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6, top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    CustomWidgets.text(
                      context,
                      "Someone",
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: widget.accentColor,
                      overflow: TextOverflow.clip,
                    ),
                    CustomWidgets.text(
                      context,
                      widget.messageModel.content,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withAlpha(125),
                      height: 1.2,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
                
            FittedBox(
                      child: Icon(Icons.image, size: widgetSize?.height != null ? widgetSize!.height - 16 : 16),
                    )
          ],
        ),
      ),
    );
  }
}

Widget _buildAttachmentWidget(MessageModel messageModel) {
  return ClipRRect(
    clipBehavior: Clip.hardEdge,
    borderRadius: BorderRadius.circular(6),
    child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () {},
        child: ImageFiltered(
          imageFilter: ColorFilter.mode(Colors.black.withAlpha(40), BlendMode.colorBurn),
          child: CachedNetworkImage(
            imageUrl: messageModel.mediaUrl!,
            fit: BoxFit.fitWidth,
          ),
        )),
  );
}
