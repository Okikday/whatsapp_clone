
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/common/app_constants.dart';
import 'package:whatsapp_clone/common/constants.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';
import 'package:whatsapp_clone/common/widgets/custom_native_text_input.dart';
import 'package:whatsapp_clone/features/chats/use_cases/models/chat_model.dart';
import 'package:whatsapp_clone/features/chats/use_cases/models/message_model.dart';
import 'package:whatsapp_clone/features/chats/views/chat_msgs_view.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/chat_msg_box.dart';
import 'package:whatsapp_clone/features/home/views/home_view.dart';

final CustomNativeTextInputController nativeTextInputController = CustomNativeTextInputController();

class ChatView extends StatelessWidget {
  final ChatModel chatModel;
  final MessageModel messageModel;
  const ChatView({super.key, required this.chatModel, required this.messageModel});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;
    final double keyboardHeight = MediaQuery.viewInsetsOf(context).bottom.clamp(4.0, (Get.height / 1.9));

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
          systemNavigationBarColor: scaffoldBgColor, statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark, statusBarColor: scaffoldBgColor),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        appBar: customAppBar(scaffoldBgColor: scaffoldBgColor, padding: EdgeInsets.zero, child: ChatViewAppBar(chatModel: chatModel, scaffoldBgColor: scaffoldBgColor, isDarkMode: isDarkMode)),
        body: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              // Chat background
              ChatMsgsView(isDarkMode: isDarkMode, messageModel: [messageModel, MessageModel.fromMap({...messageModel.toMap(), })],),

              ChatMsgBox(keyboardHeight: keyboardHeight, isDarkMode: isDarkMode, scaffoldBgColor: scaffoldBgColor)
            ],
          ),
        ),
      ),
    );
  }
}

class ChatViewAppBar extends StatelessWidget {
  const ChatViewAppBar({
    super.key,
    required this.chatModel,
    this.onTapProfile,
    required this.scaffoldBgColor,
    required this.isDarkMode,
    
  });
  
  final ChatModel chatModel;
  final void Function()? onTapProfile;
  final Color scaffoldBgColor;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const BackButton(),
        CircleAvatar(
          backgroundColor: Colors.grey.shade500,
          backgroundImage: Utilities.imgProvider(imgsrc: ImageSource.network, imgurl: chatModel.chatProfilePhoto),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(child: CustomWidgets.text(context, chatModel.chatName, fontSize: Constants.fontSizeMedium, fontWeight: FontWeight.w500)),
        IconButton(onPressed: () {}, icon: Image.asset(IconStrings.videoCallIcon, width: 24, height: 24, colorBlendMode: BlendMode.srcIn, color: isDarkMode ? Colors.white : Colors.black,)),
        IconButton(
            onPressed: () {},
            icon: Image.asset(
              IconStrings.callsIconOutlined,
              width: 24,
              height: 24,
              color: isDarkMode ? Colors.white : Colors.black,
              colorBlendMode: BlendMode.srcIn,
            )),
        IconButton(onPressed: () {}, icon: Icon(Icons.more_vert, size: 24, color: isDarkMode ? Colors.white : Colors.black)),
      ],
    );
  }
}
