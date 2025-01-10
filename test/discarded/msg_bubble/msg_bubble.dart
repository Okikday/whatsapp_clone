// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:simple_animations/simple_animations.dart';
// import 'package:whatsapp_clone/common/colors.dart';
// import 'package:whatsapp_clone/common/custom_widgets.dart';
// import 'package:whatsapp_clone/common/utilities/utilities_funcs.dart';
// import 'package:whatsapp_clone/common/widgets/custom_elevated_button.dart';
// import 'package:whatsapp_clone/features/chats/use_cases/models/message_model.dart';
// import 'package:whatsapp_clone/features/chats/views/widgets/msg_bubble/msg_bubble_functions.dart';
// import 'package:whatsapp_clone/features/chats/views/widgets/msg_bubble/msg_bubble_content.dart';

// class MsgBubble extends StatelessWidget {
//   final MessageModel messageModel;
//   final bool isFirstMsg; // Whether this is the first message in a group
//   final Color? bgColor;
//   final Color? taggedMsgColor;
//   final bool isSender; // Whether the message is from the sender
//   final bool isSelected;
//   final void Function()? onLongPressed;

//   const MsgBubble({
//     super.key,
//     required this.messageModel,
//     this.isFirstMsg = false,
//     this.bgColor,
//     this.taggedMsgColor,
//     required this.isSender,
//     this.isSelected = false,
//     this.onLongPressed,
//   });

//   // Factory constructor for receiver message bubble
//   factory MsgBubble.receiver({
//     Key? key,
//     required MessageModel messageModel,
//     bool isFirstMsg = false,
//     Color? bgColor,
//     Color? taggedMsgColor,
//     bool isSelected = false,
//     void Function()? onLongPressed,
//   }) {
//     return MsgBubble(
//       key: key,
//       messageModel: messageModel,
//       isFirstMsg: isFirstMsg,
//       bgColor: bgColor,
//       taggedMsgColor: taggedMsgColor,
//       isSender: false,
//       isSelected: isSelected,
//       onLongPressed: onLongPressed,
//     );
//   }

//   // Factory constructor for sender message bubble
//   factory MsgBubble.sender({
//     Key? key,
//     required MessageModel messageModel,
//     bool isFirstMsg = false,
//     Color? bgColor,
//     Color? taggedMsgColor,
//     bool isSelected = false,
//     void Function()? onLongPressed,
//   }) {
//     return MsgBubble(
//       key: key,
//       messageModel: messageModel,
//       isFirstMsg: isFirstMsg,
//       bgColor: bgColor,
//       taggedMsgColor: taggedMsgColor,
//       isSender: true,
//       isSelected: isSelected,
//       onLongPressed: onLongPressed,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final splashColor = ValueNotifier<Color>(Colors.transparent);
//     final animControl = ValueNotifier<Control>(Control.play);
//     final double screenWidth = MediaQuery.sizeOf(context).width;
//     final bool hasMedia = messageModel.mediaUrl != null && messageModel.mediaUrl!.isNotEmpty;
//     final bool hasMediaCaption = messageModel.mediaCaption != null && messageModel.mediaCaption!.isNotEmpty;
//     final double msgBubbleWidth = hasMedia ? screenWidth * 0.7 : screenWidth * 0.8;
//     final bool isJustImgOverlay = hasMedia &&
//         MessageTypeExtension.fromInt(messageModel.mediaType) != MessageType.text &&
//         (messageModel.mediaCaption == null || (messageModel.mediaCaption != null && messageModel.mediaCaption!.isEmpty));

//     final Text messageContent = CustomWidgets.text(
//       context,
//       hasMedia && hasMediaCaption ? messageModel.mediaCaption! : messageModel.content,
//       fontSize: 16,
//       color: Colors.white,
//       align: TextAlign.left,
//       fontWeight: FontWeight.w600,
//     );

//     final Text dateContent = CustomWidgets.text(
//       context,
//       DateFormat.jm().format(messageModel.sentAt),
//       fontSize: 11,
//       fontWeight: FontWeight.w500,
//       color: Colors.white70,
//     );
//     final double dateContentWidth = UtilitiesFuncs.getTextSize(dateContent.data!, dateContent.style!).width;
//     final bool doesTextHasSpaceLeft = MsgBubbleFunctions.doesTextHasSpaceLeft(
//       context,
//       textStyle: messageContent.style!,
//       hasMedia: hasMedia,
//       content: messageModel.content,
//       mediaCaption: messageModel.mediaCaption,
//       hasMediaCaption: hasMediaCaption,
//       msgBubbleWidth: msgBubbleWidth,
//       neededSpace: isSender ? dateContentWidth + 16 : dateContentWidth + 4,
//     );

//     log("doesTextHasSpaceLeft: $doesTextHasSpaceLeft");

//     return GestureDetector(
//       behavior: HitTestBehavior.deferToChild,
//       onTapDown: (details) => MsgBubbleFunctions.onTapDownMsgBubble(splashColor, animControl),
//       onTapUp: (details) => MsgBubbleFunctions.onTapUpMsgBubble(splashColor, animControl),
//       onTapCancel: () => MsgBubbleFunctions.onTapUpMsgBubble(splashColor, animControl),
//       child: CustomElevatedButton(
//         backgroundColor: isSelected ? Theme.of(context).primaryColor.withAlpha(60) : Colors.transparent,
//         borderRadius: 0,
//         contentPadding: EdgeInsets.only(
//             left: isSender ? 0 : 12,
//             right: isSender ? 12 : 0,
//             top: doesTextHasSpaceLeft
//                 ? 0
//                 : isFirstMsg
//                     ? 4
//                     : 2,
//             bottom: doesTextHasSpaceLeft
//                 ? 0
//                 : isFirstMsg
//                     ? 4
//                     : 2),
//         overlayColor: Theme.of(context).primaryColor.withAlpha(40),
//         pixelWidth: MediaQuery.sizeOf(context).width,
//         onClick: () {},
//         onLongClick: () {
//           if (onLongPressed != null) onLongPressed!();
//         },
//         child: Align(
//           alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
//           child: ValueListenableBuilder<Color>(
//             valueListenable: splashColor,
//             builder: (context, value, child) => CustomAnimationBuilder(
//                 control: animControl.value,
//                 duration: const Duration(milliseconds: 150),
//                 tween: ColorTween(
//                   begin: Colors.transparent,
//                   end: splashColor.value,
//                 ),
//                 builder: (context, value, child) {
//                   return Transform.translate(
//                     offset: doesTextHasSpaceLeft ? const Offset(0, 6) : Offset.zero,
//                     child: GestureDetector(
//                       onTapDown: (details) => MsgBubbleFunctions.onTapDownMsgBubble(splashColor, animControl),
//                       onTapUp: (details) => MsgBubbleFunctions.onTapUpMsgBubble(splashColor, animControl),
//                       onTapCancel: () => MsgBubbleFunctions.onTapUpMsgBubble(splashColor, animControl),
//                       onLongPress: () {
//                         if (onLongPressed != null) onLongPressed!();
//                       },
//                       child: CustomPaint(
//                         foregroundPainter: BubblePainter(
//                             isSender: isSender,
//                             backgroundColor: value ?? Colors.transparent,
//                             showTail: isFirstMsg,
//                             canRepaint: true,
//                             doesTextHasSpaceLeft: doesTextHasSpaceLeft),
//                         painter: BubblePainter(
//                             isSender: isSender,
//                             backgroundColor: bgColor ?? (isSender ? WhatsAppColors.accent : WhatsAppColors.arsenic),
//                             showTail: isFirstMsg,
//                             doesTextHasSpaceLeft: doesTextHasSpaceLeft),
//                         child: ConstrainedBox(
//                           constraints: BoxConstraints(maxWidth: msgBubbleWidth, minWidth: 64),
//                           child: Padding(
//                               padding: const EdgeInsets.only(left: 4, right: 4, top: 4, bottom: 4),
//                               child: MsgBubbleContent(
//                                 messageModel: messageModel,
//                                 hasMedia: hasMedia,
//                                 doesTextHasSpaceLeft: doesTextHasSpaceLeft,
//                                 messageContent: messageContent,
//                                 dateContent: dateContent,
//                                 isSender: isSender,
//                                 dateContentWidth: dateContentWidth,
//                                 taggedMsgColor: taggedMsgColor ?? (isSender ? WhatsAppColors.accentCompliment1 : Colors.black.withAlpha(219)),
//                                 isJustImgOverlay: isJustImgOverlay,
//                                 hasMediaCaption: hasMediaCaption,
//                               )),
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//           ),
//         ),
//       ),
//     );
//   }
// }

// /*

// hasMedia && (messageModel.mediaCaption == null || messageModel.mediaCaption!.isEmpty)
//                         ? BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withAlpha(85), blurRadius: 6, spreadRadius: 4, offset: Offset.zero)])
//                         */

// // CustomPainter for drawing the bubble with color fill
// class BubblePainter extends CustomPainter {
//   final bool isSender;
//   final Color backgroundColor;
//   final bool showTail;
//   final bool canRepaint;
//   final bool doesTextHasSpaceLeft;
//   BubblePainter({
//     this.isSender = false,
//     required this.backgroundColor,
//     required this.showTail,
//     this.canRepaint = false,
//     required this.doesTextHasSpaceLeft,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = backgroundColor
//       ..style = PaintingStyle.fill;
//     final Path path = Path();
//     const double tailHeight = 12.0;
//     const double tailWidth = 6.0;
//     const double borderRadius = 12.0;
//     final double adjustedHeight = doesTextHasSpaceLeft ? size.height - 12 : size.height;
//     double radius = 10;
//     double nipHeight = 13;
//     double nipWidth = 12;
//     double nipRadius = 4;

//     if (isSender) {
//       path.lineTo(size.width - nipRadius, 0);
//       path.arcToPoint(Offset(size.width - nipRadius, nipRadius),
//           radius: Radius.circular(nipRadius));
//       path.lineTo(size.width - nipWidth, nipHeight);
//       path.lineTo(size.width - nipWidth, size.height - radius);
//       path.arcToPoint(Offset(size.width - nipWidth - radius, size.height),
//           radius: Radius.circular(radius));
//       path.lineTo(radius, size.height);
//       path.arcToPoint(Offset(0, size.height - radius),
//           radius: Radius.circular(radius));
//       path.lineTo(0, radius);
//       path.arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));
//     } else {
//       path.lineTo(size.width - radius, 0);
//       path.arcToPoint(Offset(size.width, radius),
//           radius: Radius.circular(radius));
//       path.lineTo(size.width, size.height - radius);
//       path.arcToPoint(Offset(size.width - radius, size.height),
//           radius: Radius.circular(radius));
//       path.lineTo(radius + nipWidth, size.height);
//       path.arcToPoint(Offset(nipWidth, size.height - radius),
//           radius: Radius.circular(radius));
//       path.lineTo(nipWidth, nipHeight);
//       path.lineTo(nipRadius, nipRadius);
//       path.arcToPoint(Offset(nipRadius, 0), radius: Radius.circular(nipRadius));
//     }

//     path.close();

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return canRepaint;
//   }
// }

// Widget statusIconWidget(context, messageModel, isSender, {required bool isJustImgOverlay}) {
//   if (isJustImgOverlay) {
//     return DecoratedBox(
//       decoration: const BoxDecoration(boxShadow: [
//         BoxShadow(
//           color: Colors.black26,
//           offset: Offset.zero,
//           spreadRadius: 2,
//           blurRadius: 8,
//         )
//       ]),
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(8, 2, 2, 0),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           spacing: 2,
//           children: [
//             // Shows time message was sent
//             CustomWidgets.text(context, DateFormat.jm().format(messageModel.sentAt), fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white70),

//             // Shows message delivered and sort
//             if (isSender)
//               MsgBubbleFunctions.getMsgStatusIcon(messageModel.seenAt != null
//                   ? MsgStatus.read
//                   : messageModel.deliveredAt != null
//                       ? MsgStatus.delivered
//                       : MsgStatus.offline),
//           ],
//         ),
//       ),
//     );
//   }

//   if (!isJustImgOverlay) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(8, 2, isSender ? 2 : 0, 0),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         spacing: 2,
//         children: [
//           CustomWidgets.text(context, DateFormat.jm().format(messageModel.sentAt), fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white70),

//           if (!isSender) const SizedBox(width: 2),

//           // Shows message delivered and sort
//           if (isSender)
//             MsgBubbleFunctions.getMsgStatusIcon(messageModel.seenAt != null
//                 ? MsgStatus.read
//                 : messageModel.deliveredAt != null
//                     ? MsgStatus.delivered
//                     : MsgStatus.offline),
//         ],
//       ),
//     );
//   }
//   return const SizedBox();
// }



// /*

// class BubblePainter extends CustomPainter {
//   final bool isSender;
//   final Color backgroundColor;
//   final bool showTail;
//   final bool canRepaint;
//   final bool doesTextHasSpaceLeft;
//   BubblePainter({this.isSender = false, required this.backgroundColor, required this.showTail, this.canRepaint = false, required this.doesTextHasSpaceLeft});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = backgroundColor
//       ..style = PaintingStyle.fill;
//     final Path path = Path();
//     const double tailHeight = 12.0;
//     const double tailWidth = 6.0;
//     const double borderRadius = 12.0;
//     final double adjustedHeight = doesTextHasSpaceLeft ? size.height - 12 : size.height;

//     if (isSender) {
//       path.addRRect(RRect.fromLTRBAndCorners(
//         0,
//         0,
//         size.width,
//         adjustedHeight,
//         topLeft: const Radius.circular(borderRadius),
//         topRight: Radius.circular(showTail ? 0 : borderRadius),
//         bottomLeft: const Radius.circular(borderRadius),
//         bottomRight: const Radius.circular(borderRadius),
//       ));
//       if (showTail) {
//         path.moveTo(size.width + tailWidth - 2, 0);
//         path.lineTo(size.width, 0);
//         path.lineTo(size.width, tailHeight);
//         path.lineTo(size.width + tailWidth - 2, tailWidth);
//         path.quadraticBezierTo(size.width + tailWidth + 1, tailWidth / 2, size.width + tailWidth - 2, 0);
//       }
//     } else {
//       path.addRRect(RRect.fromLTRBAndCorners(
//         0,
//         0,
//         size.width,
//         adjustedHeight,
//         topRight: const Radius.circular(borderRadius),
//         topLeft: Radius.circular(showTail ? 0 : borderRadius),
//         bottomLeft: const Radius.circular(borderRadius),
//         bottomRight: const Radius.circular(borderRadius),
//       ));
//       if (showTail) {
//         path.moveTo(-tailWidth + 2, 0); // Start of the tail on the left
//         path.lineTo(0, 0); // Top-left corner
//         path.lineTo(0, tailHeight); // Down along the left edge
//         path.lineTo(-tailWidth + 2, tailWidth); // Diagonal line for the tail
//         path.quadraticBezierTo(-tailWidth - 1, tailWidth / 2, -tailWidth + 2, 0); // Rounded curve
//       }
//     }

//     path.close();

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return canRepaint;
//   }
// }
// */