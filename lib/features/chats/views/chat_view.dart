import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:heroine/heroine.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/common/app_constants.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';
import 'package:whatsapp_clone/common/widgets/custom_native_text_input.dart';
import 'package:whatsapp_clone/features/chats/controllers/chat_view_controller.dart';
import 'package:whatsapp_clone/features/chats/views/chat_msgs_view.dart';
import 'package:whatsapp_clone/features/chats/views/profile_view.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/chat_bubble_selection_app_bar.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/msg_box/chat_msg_box.dart';
import 'package:whatsapp_clone/features/home/views/widgets/custom_app_bar_container.dart';
import 'package:whatsapp_clone/models/chat_model.dart';


final CustomNativeTextInputController nativeTextInputController = CustomNativeTextInputController();

class ChatView extends StatelessWidget {
  final ChatModel chatModel;
  final String myUserId;
  const ChatView({
    super.key,
    required this.chatModel, required this.myUserId,
  });

  @override
  Widget build(BuildContext context) {
    final Color scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;
    return GetBuilder<ChatViewController>(
        init: ChatViewController(chatModel, myUserId),
        builder: (chatViewController) {
          return Obx(
                () {
              final double width = appUiState.deviceWidth.value;
              final double height = appUiState.deviceHeight.value;
              final bool isDarkMode = appUiState.isDarkMode.value;
              return PopScope(
                canPop: chatViewController.allowPagePop.value,
                onPopInvokedWithResult: (didPop, result) => onPopChatView(chatViewController),
                child: AnnotatedRegion(
                  value: SystemUiOverlayStyle(
                      systemNavigationBarColor: scaffoldBgColor,
                      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
                      statusBarColor: scaffoldBgColor),
                  child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    backgroundColor: scaffoldBgColor,
                    appBar: chatViewController.chatsSelected.isEmpty
                        ? CustomAppBarContainer(
                        scaffoldBgColor: scaffoldBgColor,
                        padding: EdgeInsets.zero,
                        child: ChatViewAppBar(
                          chatViewController: chatViewController,
                          scaffoldBgColor: scaffoldBgColor,
                          isDarkMode: isDarkMode,
                          onTapProfile: () async {
                            // chatViewController.focusNode.unfocus();
                            final ProfileView preloadedProfileView = ProfileView(chatModel: chatModel,);
                            Future.delayed(const Duration(milliseconds: 150),
                                    () => navigator?.push(CupertinoPageRoute(builder: (context) => preloadedProfileView)));
                          },
                        ))
                        : CustomAppBarContainer(scaffoldBgColor: scaffoldBgColor, child: ChatBubbleSelectionAppBar(chatViewController: chatViewController,)),
                    body: SizedBox(
                      width: width,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: isDarkMode ? Colors.black.withAlpha(242) : WhatsAppColors.seaShell,
                            image: DecorationImage(
                                image: const AssetImage(
                                  ImagesStrings.chatBackground,
                                ),
                                repeat: ImageRepeat.repeat,
                                alignment: Alignment.topLeft,
                                scale: 1.3,
                                filterQuality: FilterQuality.high,
                                colorFilter: ColorFilter.mode(isDarkMode ? WhatsAppColors.darkGray : WhatsAppColors.linen, BlendMode.srcIn),
                                fit: BoxFit.none)),
                        child: Column(
                          children: [
                            // Chat background
                            ChatMsgsView(
                              chatViewController: chatViewController,
                              myUserId: myUserId,
                              height: height,
                              width: width,
                              isDarkMode: isDarkMode,
                            ),

                            ChatMsgBox(scaffoldBgColor: scaffoldBgColor, chatViewController: chatViewController),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
    );
  }
}

void onPopChatView(ChatViewController chatViewController) {
  if (chatViewController.chatsSelected.isNotEmpty) {
    chatViewController.clearSelectedChatBubble();
  } else {
    chatViewController.resetMsgBox();
  }
}

class ChatViewAppBar extends StatelessWidget {
  const ChatViewAppBar({
    super.key,
    this.onTapProfile,
    required this.scaffoldBgColor,
    required this.isDarkMode,
    required this.chatViewController,
  });

  final ChatViewController chatViewController;
  final void Function()? onTapProfile;
  final Color scaffoldBgColor;
  final bool isDarkMode;


  @override
  Widget build(BuildContext context) {
    const double iconSize = 24;
    final ChatModel chatModel = chatViewController.chatModel;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          width: 4,
        ),
        GestureDetector(
          onTap: () async {
            if (chatViewController.chatsSelected.isEmpty) {
              navigator?.pop();
            }
          },
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
              Heroine(
                tag: "${chatModel.chatId}_profile",
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey.shade500,
                  backgroundImage: (chatModel.chatProfilePhoto != null && chatModel.chatProfilePhoto!.isNotEmpty)
                      ? Utilities.imgProvider(imgsrc: ImageSource.network, imgurl: chatModel.chatProfilePhoto)
                      : Utilities.imgProvider(imgsrc: ImageSource.asset, defaultAssetImage: IconStrings.userIcon),
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
                    child: CustomText(
                        chatModel.chatName,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis
                    )))),
        const SizedBox(
          width: 4,
        ),
        IconButton(
            style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            onPressed: () {},
            icon: Image.asset(
              IconStrings.videoCall,
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
              IconStrings.callsOutlined,
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