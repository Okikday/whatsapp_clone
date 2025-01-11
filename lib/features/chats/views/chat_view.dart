import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:heroine/heroine.dart';
import 'package:whatsapp_clone/common/app_constants.dart';
import 'package:whatsapp_clone/common/constants.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';
import 'package:whatsapp_clone/common/widgets/custom_elevated_button.dart';
import 'package:whatsapp_clone/common/widgets/custom_native_text_input.dart';
import 'package:whatsapp_clone/features/chats/use_cases/models/chat_model.dart';
import 'package:whatsapp_clone/features/chats/use_cases/models/message_model.dart';
import 'package:whatsapp_clone/features/chats/views/chat_msgs_view.dart';
import 'package:whatsapp_clone/features/chats/views/profile_view.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/msg_box/chat_msg_box.dart';
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
    final double height = MediaQuery.sizeOf(context).height;
    final double width = MediaQuery.sizeOf(context).width;
    final double keyboardHeight = MediaQuery.viewInsetsOf(context).bottom.clamp(4.0, (height / 1.9));

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
          systemNavigationBarColor: scaffoldBgColor, statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark, statusBarColor: scaffoldBgColor),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: customAppBar(context,
            scaffoldBgColor: scaffoldBgColor,
            padding: EdgeInsets.zero,
            child: ChatViewAppBar(
              chatModel: chatModel,
              scaffoldBgColor: scaffoldBgColor,
              isDarkMode: isDarkMode,
              onTapProfile: () {
                final ProfileView preloadedProfileView = ProfileView(isDarkMode: isDarkMode, width: width, height: height, chatModel: chatModel);
                Future.delayed(const Duration(milliseconds: 175), ()=> Get.to(() => preloadedProfileView,
                transition: Transition.rightToLeftWithFade
                ));
              },
            )),
        body: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              // Chat background
              ChatMsgsView(
                  height: height,
                  width: width,
                  isDarkMode: isDarkMode,
                  messageModel: [
                    messageModel,
                    MessageModel.fromMap({
                      ...messageModel.toMap(),
                    })
                  ],
                  keyboardHeight: keyboardHeight),

              ChatMsgBox(height: height, width: width, keyboardHeight: keyboardHeight, isDarkMode: isDarkMode, scaffoldBgColor: scaffoldBgColor)
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
    const double iconSize = 24;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          width: 4,
        ),
        GestureDetector(
          onTap: () => navigator?.pop(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Hero(
                tag: "icon_arrow_back",
                child: SizedBox(
                    height: 64,
                    child: Icon(
                      Icons.arrow_back_rounded,
                    )),
              ),
              Hero(
                tag: "profilePhoto",
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey.shade500,
                  backgroundImage: Utilities.imgProvider(imgsrc: ImageSource.network, imgurl: chatModel.chatProfilePhoto),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
            child: CustomElevatedButton(
                pixelHeight: 64,
                backgroundColor: Colors.transparent,
                overlayColor: isDarkMode ? Colors.white10 : Colors.black12,
                borderRadius: 0,
                contentPadding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
                onClick: () {
                  if (onTapProfile != null) onTapProfile!();
                },
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomWidgets.text(
                      context,
                      chatModel.chatName,
                      fontSize: Constants.fontSizeMedium + 2,
                      fontWeight: FontWeight.w500,
                    )))),
        const SizedBox(
          width: 4,
        ),
        IconButton(
            style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            onPressed: () {},
            icon: Image.asset(
              IconStrings.videoCallIcon,
              width: iconSize,
              height: iconSize,
              colorBlendMode: BlendMode.srcIn,
              color: isDarkMode ? Colors.white : Colors.black,
            )),
        const SizedBox(
          width: 6,
        ),
        IconButton(
            style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            onPressed: () {},
            icon: Image.asset(
              IconStrings.callsIconOutlined,
              width: iconSize,
              height: iconSize,
              color: isDarkMode ? Colors.white : Colors.black,
              colorBlendMode: BlendMode.srcIn,
            )),
        const SizedBox(
          width: 6,
        ),
        Hero(
          tag: "icon_more_vert",
          child: IconButton(
              style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              onPressed: () {},
              icon: Icon(Icons.more_vert, size: iconSize, color: isDarkMode ? Colors.white : Colors.black)),
        ),
        const SizedBox(
          width: 6,
        ),
      ],
    );
  }
}
